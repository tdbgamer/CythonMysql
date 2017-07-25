import pytest
from mysql.exceptions import ProgrammingError


def test_iterating_over_cursor(db):
    test_values = [1, 2, 3, 4, 5]
    with db.cursor() as cursor:
        cursor.execute('create table blah (id int);')
        for value in test_values:
            cursor.execute('insert into blah (`id`) values (' + str(value) + ')')

    with db.cursor() as cursor:
        cursor.execute('select id from blah')
        for (id,) in cursor:
            assert id in test_values


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
