from cursors cimport Cursor
from errors cimport raise_error
from exceptions import ProgrammingError

cdef class Connection:
    def __cinit__(self, str host=None, str user=None, str passwd=None, str db=None, unsigned int port=3306):
        self.conn = mysql_init(NULL)
        if not self.conn:
            raise MemoryError('Failed to allocate connection object')

        if not mysql_real_connect(self.conn, host.encode('utf-8'), user.encode('utf-8'),
                                  passwd.encode('utf-8'), db.encode('utf-8'), port, NULL, 0):
            raise_error(self.conn)

    def __dealloc__(self):
        self.close()

    def __bool__(self):
        return bool(<bint> self.conn)

    cdef _is_closed(self):
        if not self.conn:
            raise ProgrammingError('Connection closed')

    def ping(self):
        self._is_closed()
        if mysql_ping(self.conn):
            raise_error(self.conn)
        return True

    def cursor(self):
        self._is_closed()
        return Cursor(self)

    def close(self):
        if self.conn:
            mysql_close(self.conn)
            self.conn = NULL

    def commit(self):
        self._is_closed()
        error = mysql_commit(self.conn)
        if error:
            raise_error(self.conn)

    def rollback(self):
        self._is_closed()
        error = mysql_rollback(self.conn)
        if error:
            raise_error(self.conn)
