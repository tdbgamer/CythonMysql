from errors cimport raise_error
from connection cimport Connection
from exceptions import ProgrammingError

cdef class Cursor:
    def __cinit__(self, Connection conn):
        self.conn = conn
        self.closed = 0
        self.rowcount = -1

    cdef _is_closed(self):
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

    def close(self):
        self.closed = 1

    def __enter__(self):
        self._is_closed()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type is None:
            self.conn.commit()
        else:
            self.conn.rollback()
        self.close()

    def fetchone(self):


    def execute(self, query):
        self._is_closed()
        if mysql_real_query(self.conn.conn, query.encode('utf-8'), len(query)):
            self._raise_error()
        result = mysql_store_result(self.conn.conn)
        cdef MYSQL_ROW row
        if result:
            self._store_description(result)
            row = mysql_fetch_row(result)
            while row:

                row = mysql_fetch_row(result)
            mysql_free_result(result)

