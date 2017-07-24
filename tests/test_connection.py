import pytest
from mysql.connection import Connection, MySqlException


def test_good_queries(db):
    with db.cursor() as cursor:
        cursor.execute('create table blah (id int);')
        cursor.execute('insert into blah (`id`) values (1)')
        cursor.execute('insert into blah (`id`) values (2)')
        cursor.execute('insert into blah (`id`) values (3)')
        cursor.execute('insert into blah (`id`) values (4)')
        cursor.execute('select * from blah')


def test_duplicate_table(db):
    with pytest.raises(MySqlException):
        with db.cursor() as cursor:
            cursor.execute('create table duplicate_table (id int);')
            cursor.execute('create table duplicate_table (id int);')


def test_unique_contraint(db):
    with pytest.raises(MySqlException):
        with db.cursor() as cursor:
            cursor.execute('create table unique_test (id int unique)')
            cursor.execute('insert into unique_test (`id`) values (1)')
            cursor.execute('insert into unique_test (`id`) values (1)')


def test_syntax_error(db):
    with pytest.raises(MySqlException):
        with db.cursor() as cursor:
            cursor.execute('selec * from blah')
