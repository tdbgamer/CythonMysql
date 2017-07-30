include 'mysql.pxd'
include 'mysql.pyx'

cdef class Connection:
    cdef MYSQL *conn
    cdef _is_closed(self)
