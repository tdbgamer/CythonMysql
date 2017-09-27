from datetime import datetime

def str_to_set(char * input):
    pass

p_to_m = {

}

m_to_p = {
    MYSQL_TYPE_DECIMAL: float,
    MYSQL_TYPE_TINY: int,
    MYSQL_TYPE_SHORT: int,
    MYSQL_TYPE_LONG: int,
    MYSQL_TYPE_FLOAT: float,
    MYSQL_TYPE_DOUBLE: float,
    MYSQL_TYPE_NULL: lambda x: None,
    MYSQL_TYPE_TIMESTAMP: lambda x: datetime.strptime(x.decode('utf-8'), '%Y-%m-%d %H:%M:%S'),
    MYSQL_TYPE_LONGLONG: int,
    MYSQL_TYPE_INT24: int,
    MYSQL_TYPE_DATE: lambda x: datetime.strptime(x.decode('utf-8'), '%Y-%m-%d').date(),
    MYSQL_TYPE_TIME: lambda x: datetime.strptime(x.decode('utf-8'), '%H:%M:%S').time(),
    MYSQL_TYPE_DATETIME: lambda x: datetime.strptime(x.decode('utf-8'), '%Y-%m-%d %H:%M:%S'),
    MYSQL_TYPE_YEAR: int,
    MYSQL_TYPE_NEWDATE: lambda x: datetime.strptime(x.decode('utf-8'), '%Y-%m-%d').date(),
    MYSQL_TYPE_VARCHAR: str,
    MYSQL_TYPE_BIT: lambda x: int.from_bytes(x, byteorder='big'),
    MYSQL_TYPE_NEWDECIMAL: float,
    MYSQL_TYPE_ENUM: str,
    MYSQL_TYPE_SET: str_to_set,
    MYSQL_TYPE_TINY_BLOB: bytes,
    MYSQL_TYPE_MEDIUM_BLOB: bytes,
    MYSQL_TYPE_LONG_BLOB: bytes,
    MYSQL_TYPE_BLOB: bytes,
    MYSQL_TYPE_VAR_STRING: str,
    MYSQL_TYPE_STRING: str,
    MYSQL_TYPE_GEOMETRY: bytes
}

cdef python_to_mysql(object field):
    pass

cdef mysql_to_python(char * data, object description, unsigned long length):
    try:
        byte_data = data[:length]
        if byte_data == b"":
            return None
        return m_to_p[description[1]](byte_data)
    except Exception as e:
        print(e)
        return data[:length]
