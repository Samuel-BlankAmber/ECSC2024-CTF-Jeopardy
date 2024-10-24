from functools import wraps
from flask import Flask, abort, request, g
from db import DB
from werkzeug.security import generate_password_hash, check_password_hash
import random

def generate_session_token():
    return ''.join(random.choices('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', k=32))

app = Flask(__name__)

def auth_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        session_token = request.headers.get('Authorization', '')
        db = DB()
        user = db.get_user_by_token(session_token)

        if not user:
            abort(401)

        g.user = user
        return f(*args, **kwargs)

    return wrapper


# Register
@app.route('/api/v1/register/', methods=['POST'])
def register():
    username = request.form.get('username', '')
    password = request.form.get('password', '')
    password_confirm = request.form.get('password_confirm', '')

    if not isinstance(username, str) or len(username) < 8:
        return {
            "error": "Username must be at least 8 characters"
        }, 400

    if not isinstance(password, str) or len(password) < 8:
        return {
            "error": "Password must be at least 8 characters"
        }, 400

    if password != password_confirm:
        return {
            "error": "Password mismatch"
        }, 400

    db = DB()
    user = db.get_user(username)

    if user:
        return {
            "error": "User already exists"
        }, 400

    db.add_user(username, generate_password_hash(password))

    return {
        "message": "User created successfully"
    }, 201


# Login
@app.route('/api/v1/login/', methods=['POST'])
def login():
    username = request.form.get('username', '')
    password = request.form.get('password', '')

    db = DB()
    user = db.get_user(username)

    if not user:
        return {
            "error": "Invalid username"
        }, 400

    if not check_password_hash(user['password'], password):
        return {
            "error": "Invalid password"
        }, 400

    session_token = generate_session_token()

    db.set_token(username, session_token)
    
    return {
        "message": "Login successful",
        "session_token": session_token
    }, 201
    

# List all concerts
@app.route('/api/v1/concert/', methods=['GET'])
def concert_list():
    db = DB()
    concerts = db.get_concerts()

    return concerts


# List concert detail by id
@app.route('/api/v1/concert/<int:concert_id>/', methods=['GET'])
def concert_detail(concert_id):
    db = DB()
    concert = db.get_concert(concert_id)

    if concert:
        return concert
    
    abort(404)


# User info
@app.route('/api/v1/user/')
@auth_required
def user_info():
    user = g.user

    return {
        "username": user['username'],
        "funds": user['funds'],
    }


# Buy ticket
@app.route('/api/v1/concert/<int:concert_id>/book/', methods=['POST'])
@auth_required
def book_concert(concert_id):
    user = g.user
    db = DB()
    concert = db.get_concert(concert_id)

    if not concert:
        abort(404)

    if concert['price'] > user['funds']:
        return {
            "error": "Insufficient funds"
        }, 400

    serial = generate_session_token()

    db.book_concert(user['id'], concert_id, serial)

    return {
        "message": "Concert booked successfully"
    }, 201


# List user bookings
@app.route('/api/v1/user/bookings/', methods=['GET'])
@auth_required
def user_bookings():
    user = g.user
    db = DB()
    bookings = db.get_user_bookings(user['id'])

    return bookings


# Book by id for the owner
@app.route('/api/v1/user/bookings/<int:book_id>/', methods=['GET'])
@auth_required
def book_by_id(book_id):
    user = g.user
    db = DB()
    booking = db.get_booking_by_id(book_id, user['id'])

    if not booking:
        raise(404)

    return booking


# Add concert
@app.route('/api/v1/user/concert/', methods=['POST'])
@auth_required
def add_concert():
    user = g.user

    name = request.form.get('name')
    date = request.form.get('date')
    secret_code = request.form.get('secret_code')
    price = request.form.get('price')
    
    if not name or not date or not secret_code or not price:
        return {
            "error": "Missing fields"
        }, 400
    
    try:
        price = float(price)
    except ValueError:
        return {
            "error": "Invalid price"
        }, 400
    
    if not isinstance(name, str) or not isinstance(date, str) or not isinstance(secret_code, str) or price < 0:
        return {
            "error": "Invalid fields"
        }, 400
        
    db = DB()
    
    db.add_concert(name, date, secret_code, price, user['id'])

    return {
        "message": "Concert added successfully"
    }, 201


# Add checker to concert
@app.route('/api/v1/concert/<int:concert_id>/checker/', methods=['POST'])
@auth_required
def add_checker(concert_id):
    user = g.user
    db = DB()

    concert = db.get_concert(concert_id)

    if not concert:
        abort(404)

    if not db.check_user_in_concert(user['id'], concert_id):
        abort(403)

    username = request.form.get('username')

    if not username:
        return {
            "error": "Missing fields"
        }, 400

    user = db.get_user_by_username(username)
    
    if not user:
        return {
            "error": "User not found"
        }, 404

    db.add_checker(user['id'], concert_id)

    return {
        "message": "Checker added successfully"
    }, 201


# List concerts owned by user, only owner
@app.route('/api/v1/user/concert/', methods=['GET'])
@auth_required
def user_concerts():
    user = g.user
    db = DB()

    concerts = db.get_user_concerts(user['id'])

    return concerts


@app.route('/api/v1/user/concert/<int:concert_id>/', methods=['GET'])
@auth_required
def user_concert(concert_id):
    user = g.user
    db = DB()

    concert = db.get_user_concert(user['id'], concert_id)

    if concert is None:
        abort(404)

    return concert


# Check booking
@app.route('/api/v1/check/<serial>/', methods=['POST'])
@auth_required
def check_booking(serial):
    user = g.user
    db = DB()

    booking = db.get_booking(serial)
    
    if not booking:
        abort(404)

    concert_id = booking['concert_id']
    
    if not db.check_user_in_concert(user['id'], concert_id):
        abort(403)

    db.check_booking(serial, request.form.get('comment'))

    return {
        "message": "Booking checked successfully"
    }, 201    


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
