from exceptions import MySqlException

cdef raise_error(MYSQL* conn):
    cdef int errno = mysql_errno(conn)
    cdef object error_message = mysql_error(conn)

    #TODO: Raise different exception types
    raise MySqlException(error_message)
