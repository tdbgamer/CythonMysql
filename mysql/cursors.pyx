from errors cimport raise_error
from connection cimport Connection
from converter cimport mysql_to_python
from exceptions import ProgrammingError

cdef class Cursor:
    def __cinit__(self, Connection conn):
        self.conn = conn
        self.closed = 0
        self.rowcount = -1
        self._result = NULL
        self._executed = False

    def __dealloc__(self):
        if self._result:
            mysql_free_result(self._result)

    cdef _is_closed(self):
        if not self.conn.conn:
            raise ProgrammingError('Connection closed')
        if self.closed:
            raise ProgrammingError('Cursor closed')

    cdef _store_description(self, MYSQL_RES* result):
        cdef unsigned int num_fields
        cdef MYSQL_FIELD* fields

        num_fields = mysql_num_fields(result)
        fields = mysql_fetch_fields(result)

        description = []
        for i in range(num_fields):
            field = fields[i]
            description.append((
                field.name.decode('utf-8'),
                field.type,
                field.max_length,
                field.length,
                field.length,
                field.decimals,
                field.flags & NOT_NULL_FLAG != NOT_NULL_FLAG
            ))
        self.description = tuple(description)

    cdef _raise_error(self):
        raise_error(self.conn.conn)

    cdef _has_executed(self):
        if not self._executed:
            raise ProgrammingError('execute() has not been called yet')

    def close(self):
        self.closed = 1

    def __iter__(self):
        return self

    def __next__(self):
        row = self.fetchone()
        if not row:
            raise StopIteration
        return row

    def __enter__(self):
        self._is_closed()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type is None:
            self.conn.commit()
        else:
            self.conn.rollback()
        self.close()

    cdef MYSQL_ROW _get_row(self):
        return mysql_fetch_row(self._result)

    def fetchone(self):
        cdef MYSQL_ROW row
        self._has_executed()
        row = self._get_row()
        if not row:
            return None
        lengths = mysql_fetch_lengths(self._result)
        return tuple(mysql_to_python(row[i], self.description[i], lengths[i]) for i in range(len(self.description)))
        # return tuple(row[i] for i in range(len(self.description)))

    def execute(self, query):
        self._is_closed()
        self._executed = True
        if mysql_real_query(self.conn.conn, query.encode('utf-8'), len(query)):
            self._raise_error()
        result = mysql_store_result(self.conn.conn)
        cdef MYSQL_ROW row
        if result:
            self._store_description(result)
            self._result = result

