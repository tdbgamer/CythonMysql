include 'mysql.pxd'
include 'mysql.pyx'
from connection cimport Connection

cdef class Cursor:
    cdef Connection conn
    cdef readonly object description, rowcount, lastrowid
    cdef bint closed
    cdef object rows

    cdef _is_closed(self)
    cdef _store_description(self, MYSQL_RES* result)
    cdef _raise_error(self)
