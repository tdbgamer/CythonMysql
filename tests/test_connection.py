import pytest
from mysql.exceptions import ProgrammingError


def test_create_connection(db):
    assert db.ping() is True


def test_close_connection(db):
    db.close()
    with pytest.raises(ProgrammingError):
        db.ping()
    with pytest.raises(ProgrammingError):
        db.commit()
    with pytest.raises(ProgrammingError):
        db.rollback()
    with pytest.raises(ProgrammingError):
        db.cursor()
