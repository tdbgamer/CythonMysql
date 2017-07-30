import pytest
from datetime import datetime

from mysql.exceptions import ProgrammingError


def test_iterating_over_cursor(db):
    test_values = [1, 2, 3, 4, 5]
    with db.cursor() as cursor:
        cursor.execute('create table blah (id int);')
        for value in test_values:
            cursor.execute('insert into blah (`id`) values (' + str(value) + ')')

    with db.cursor() as cursor:
        cursor.execute('select id from blah')
        cursor.execute('select id from blah')
        cursor.execute('select id from blah')
        values = set(test_values)
        for (id,) in cursor:
            assert id in values


def test_date_types(db):
    with db.cursor() as cursor:
        cursor.execute("create table blah (test_timestamp TIMESTAMP, test_datetime DATETIME);")
        cursor.execute("insert into blah (test_timestamp, test_datetime) values (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
        cursor.execute("select test_timestamp, test_datetime from blah")
        for (t, d) in cursor:
            assert isinstance(t, datetime)
            assert isinstance(d, datetime)


def test_cursor_close(db):
    cursor = db.cursor()
    cursor.execute('select 1')
    cursor.close()
    with pytest.raises(ProgrammingError):
        cursor.execute('select 1')


def test_close_connection(db):
    cursor = db.cursor()
    db.close()
    with pytest.raises(ProgrammingError):
        cursor.execute('select 1')
