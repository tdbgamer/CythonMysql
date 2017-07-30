include 'mysql.pxd'
include 'mysql.pyx'
from connection cimport Connection

cdef class Cursor:
    cdef Connection conn
    cdef readonly object description, rowcount, lastrowid
    cdef bint closed
    cdef object rows
    cdef object _executed
    cdef MYSQL_RES * _result

    cdef _is_closed(self)
    cdef _store_description(self, MYSQL_RES* result)
    cdef _raise_error(self)
    cdef MYSQL_ROW _get_row(self)
    cdef _has_executed(self)
