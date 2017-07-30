include 'mysql.pxd'
include 'mysql.pyx'

cdef python_to_mysql(object field)
cdef mysql_to_python(char * data, object description, unsigned long length)
