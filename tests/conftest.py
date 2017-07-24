import pytest
from mysql.connection import Connection


@pytest.fixture(scope='function')
def db():
    db = Connection(host='127.0.0.1', user='root', passwd='test123', db='test')
    yield db
    with db.cursor() as cursor:
        cursor.execute('''
            DROP DATABASE test;
        ''')
        cursor.execute('''
            CREATE DATABASE IF NOT EXISTS test;
        ''')
    db.close()
