import sqlite3
import os
from werkzeug.security import generate_password_hash
import random

DATABASE = './database.db'

TABLES = [
    """
    CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        username TEXT UNIQUE,
        password TEXT,
        funds INTEGER DEFAULT 10,
        
        session_token TEXT
    );
    """,
    f"""
    INSERT INTO users (username, password) VALUES ('elkeke69', '{generate_password_hash(os.environ.get("TARGET_PASSWORD", "582c963680f7ac49af20e30cfe6e5234"))}');
    """,
    """
    CREATE TABLE concert (
        id INTEGER PRIMARY KEY,
        name TEXT,
        date TEXT,
        
        secret_code TEXT,
        price INTEGER DEFAULT 10
    );
    """,
    f"""
        INSERT INTO concert (name, date, secret_code, price) VALUES
            ('The flag - Online', '2024-09-21', '{os.environ.get("FLAG", "flag{fake_flag}")}', 1000),
            ('David Gilmour - Rome', '2024-09-27', '3f58ecb98b17137051bd6148585181e3', 10),
            ('Dutch Nazari', 'Never', '8cccfc255753b8702a4d8b8ebf21c54b', 10),
            ('Mace - Milan', '2024-10-18', '0974e1d52599f45201c50313019db146', 10),
            ('Calcutta - Lucca', '2024-07-17', 'a409a0c8602bab4669a1c1d9202132a1', 10);
    """,
    """
    CREATE TABLE booking (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        concert_id INTEGER,
        
        checked BOOLEAN DEFAULT 0,
        comment TEXT DEFAULT NULL,
        
        serial TEXT DEFAULT NULL,

        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(concert_id) REFERENCES concert(id)
    );
    """,
    """
    CREATE TABLE checker (
        id INTEGER PRIMARY KEY,

        user_id INTEGER,
        concert_id INTEGER,

        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(concert_id) REFERENCES concert(id)
    );
    """,
    """
    INSERT INTO checker (user_id, concert_id) VALUES 
        (1, 1),
        (1, 2),
        (1, 3),
        (1, 4),
        (1, 5);
    """
]

def dict_factory(cursor, row):
    d = {}
    for idx, col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d


class DB():


    def __init__(self) -> None:
        self.conn = sqlite3.connect(DATABASE)
        self.conn.row_factory = dict_factory

        self.commit()


    def get_cursor(self) -> sqlite3.Cursor:
        return self.conn.cursor()
    

    def commit(self):
        self.conn.commit()


    def get_user(self, username):
        cursor = self.get_cursor()

        cursor.execute("SELECT * FROM users WHERE username = ?", (username,))
        user = cursor.fetchone()

        self.commit()

        return user


    def add_user(self, username, password):
        cursor = self.get_cursor()

        cursor.execute("INSERT INTO users (username, password) VALUES (?, ?)", (username, password))

        self.commit()


    def set_token(self, username, token):
        cursor = self.get_cursor()

        cursor.execute("UPDATE users SET session_token = ? WHERE username = ?", (token, username))

        self.commit()


    def get_user_by_token(self, token):
        cursor = self.get_cursor()

        cursor.execute("SELECT * FROM users WHERE session_token = ?", (token,))
        user = cursor.fetchone()

        self.commit()

        return user


    def get_concerts(self):
        cursor = self.get_cursor()

        cursor.execute("SELECT id, name, date, price FROM concert")
        concerts = cursor.fetchall()

        self.commit()

        return concerts if concerts else []


    def get_concert(self, concert_id):
        cursor = self.get_cursor()

        cursor.execute("SELECT id, name, date, price FROM concert WHERE id = ?", (concert_id,))
        concert = cursor.fetchone()

        self.commit()

        return concert


    def book_concert(self, user_id, concert_id, serial):
        cursor = self.get_cursor()

        cursor.execute("UPDATE users SET funds = funds - (SELECT price FROM concert WHERE id = ?) WHERE id = ?", (concert_id, user_id))

        cursor.execute("INSERT INTO booking (user_id, concert_id, serial) VALUES (?, ?, ?)", (user_id, concert_id, serial))

        self.commit()
        
    
    def get_user_bookings(self, user_id):
        cursor = self.get_cursor()

        cursor.execute("""
            SELECT b.*, concert.name, concert.date
            FROM booking b
            INNER JOIN concert ON b.concert_id = concert.id
            WHERE user_id = ?"""
        , (user_id,))
        bookings = cursor.fetchall()

        self.commit()

        return bookings if bookings else []


    def get_booking_by_id(self, booking_id, user_id):
        cursor = self.get_cursor()

        cursor.execute("""
            SELECT b.*, concert.name, concert.date
            FROM booking b
            INNER JOIN concert ON b.concert_id = concert.id
            WHERE b.id = ? AND b.user_id = ?
        """, (booking_id, user_id))
        booking = cursor.fetchone()

        self.commit()

        return booking

    
    def get_concert_bookings(self, concert_id):
        cursor = self.get_cursor()

        cursor.execute("SELECT * FROM booking WHERE concert_id = ?", (concert_id,))
        bookings = cursor.fetchall()

        self.commit()

        return bookings if bookings else []

    
    def get_user_concerts(self, user_id):
        cursor = self.get_cursor()

        cursor.execute("""
            SELECT *
            FROM concert
            INNER JOIN checker ON concert.id = checker.concert_id
            WHERE checker.user_id = ?
        """, (user_id,))
        concerts = cursor.fetchall()

        self.commit()

        return concerts if concerts else []
    
    def get_user_concert(self, user_id, concert_id):
        cursor = self.get_cursor()

        cursor.execute("""
            SELECT *
            FROM concert
            INNER JOIN checker ON concert.id = checker.concert_id
            WHERE checker.user_id = ? AND concert.id = ?
        """, (user_id, concert_id))
        concert = cursor.fetchone()

        self.commit()

        return concert


    def add_concert(self, name, date, secret_code, price, owner_id):
        cursor = self.get_cursor()

        cursor.execute("INSERT INTO concert (name, date, secret_code, price) VALUES (?, ?, ?, ?)", (name, date, secret_code, price))
        
        last_id = cursor.lastrowid
        
        cursor.execute("INSERT INTO checker (user_id, concert_id) VALUES (?, ?)", (owner_id, last_id))

        self.commit()


    def check_user_in_concert(self, user_id, concert_id):
        cursor = self.get_cursor()

        cursor.execute("SELECT * FROM checker WHERE user_id = ? AND concert_id = ?", (user_id, concert_id))
        check = cursor.fetchone()

        self.commit()

        return check


    def get_booking(self, serial):
        cursor = self.get_cursor()
        
        cursor.execute("SELECT * FROM booking WHERE serial = ?", (serial,))
        booking = cursor.fetchone()
        
        self.commit()
        
        return booking
        

    def check_booking(self, serial, comment):
        cursor = self.get_cursor()

        cursor.execute("UPDATE booking SET checked=1, comment = ? WHERE serial = ?", (comment, serial))

        self.commit()


    def add_checker(self, user_id, concert_id):
        cursor = self.get_cursor()

        cursor.execute("INSERT INTO checker (user_id, concert_id) VALUES (?, ?)", (user_id, concert_id))

        self.commit()


    def get_user_by_username(self, username):
        cursor = self.get_cursor()

        cursor.execute("SELECT id FROM users WHERE username = ?", (username,))
        user = cursor.fetchone()

        self.commit()

        return user


if __name__ == "__main__":
    db = DB()

    for table in TABLES:
        print(f"Doing: {table}")
        db.get_cursor().execute(table)

    db.commit()
    db.conn.close()
