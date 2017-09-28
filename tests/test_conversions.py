from datetime import datetime, date, time


def test_date_types(db):
    with db.cursor() as cursor:
        cursor.execute("create table blah"
                       "(test_timestamp TIMESTAMP, test_datetime DATETIME, test_date DATE,"
                       "test_time TIME, test_year YEAR);")
        cursor.execute("insert into blah"
                       "(test_timestamp, test_datetime, test_date, test_time, test_year)"
                       "values (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_DATE, CURRENT_TIME, '2017')")
        cursor.execute("select test_timestamp, test_datetime, test_date, test_time, test_year from blah")
        for (ts, dt, d, t, y) in cursor:
            assert isinstance(ts, datetime)
            assert isinstance(dt, datetime)
            assert isinstance(d, date)
            assert isinstance(t, time)
            assert isinstance(y, int)


def test_numeric_types(db):
    with db.cursor() as cursor:
        cursor.execute("create table blah"
                       "(test_decimal DECIMAL(10, 2), test_tiny TINYINT, test_short SMALLINT, test_long INT,"
                       "test_float FLOAT, test_double DOUBLE, test_longlong BIGINT, test_int24 MEDIUMINT,"
                       "test_bit BIT(64));")
        cursor.execute("insert into blah"
                       "(test_decimal, test_tiny, test_short, test_long, test_float, test_double, test_longlong,"
                       "test_int24, test_bit)"
                       "values (1.01, 10, 15, 100, 1.02, 1.03, 1000, 50, 1000);")
        cursor.execute("select test_decimal, test_tiny, test_short, test_long, "
                       "test_float, test_double, test_longlong, test_int24, test_bit from blah")
        for (d, ti, s, l, f, dbl, ll, i24, bit) in cursor:
            assert isinstance(d, float)
            assert isinstance(ti, int)
            assert isinstance(s, int)
            assert isinstance(l, int)
            assert isinstance(f, float)
            assert isinstance(f, float)
            assert isinstance(dbl, float)
            assert isinstance(ll, int)
            assert isinstance(i24, int)
            assert isinstance(bit, int)

def test_none_against_empty_string(db):
    with db.cursor() as cursor:
        cursor.execute("create table blah (id INT AUTO_INCREMENT primary key, "
                       "test_null VARCHAR(255));")
        cursor.execute("insert into blah (test_null) values (NULL);")
        cursor.execute("insert into blah (test_null) values ('');")
        cursor.execute("select test_null from blah")
        cursor_iter = iter(cursor)

        first, = next(cursor_iter)
        second, = next(cursor_iter)

        assert first is None
        assert isinstance(second, str)

def test_not_none(db):
    with db.cursor() as cursor:
        cursor.execute("create table blah (id INT AUTO_INCREMENT primary key, "
                       "test_not_null VARCHAR(255));")
        cursor.execute("insert into blah (test_not_null) values ('')")
        cursor.execute("select test_not_null from blah")
        for nn, in cursor:
            assert isinstance(nn, str)
