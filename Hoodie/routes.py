from flask import render_template, request, redirect, flash, url_for
from flask_login import login_user, login_required, logout_user
from werkzeug.security import check_password_hash, generate_password_hash

from Hoodie import db, app
from Hoodie.models import Client, User

@app.route('/')
def index():
    return render_template('index.html')


@app.route('/about')
@login_required
def about():
    clients = Client.query.order_by(Client.lastname).all()
    return render_template('about.html', clients=clients)


@app.route('/create', methods=['GET', 'POST'])
@login_required
def create():
    if request.method == "POST":
        lastname = request.form['lastname']
        firstname = request.form['firstname']
        middlename = request.form['middlename']
        mobilephone = request.form['mobilephone']
        email = request.form['email']

        new_client = Client(
            lastname=lastname,
            firstname=firstname,
            middlename=middlename,
            mobilephone=mobilephone,
            email=email
        )

        try:
            db.session.add(new_client)
            db.session.commit()
            return redirect('/about')
        except:
            return "Ошибка"
    
    return render_template('create.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    pass
    login = request.form.get('login')
    password = request.form.get('password')
    password2 = request.form.get('password2')

    if request.method == 'POST':
        if not(login or password or password2):
            flash('Please, fill all field')
        elif password != password2:
            flash('Passwords are not equal')
        else:
            hash_pwd = generate_password_hash(password)
            new_user = User(login = login, password = hash_pwd)
            db.session.add(new_user)
            db.session.commit()

            return redirect(url_for('login'))
        
    return render_template("register.html")
    
    # if login and password:
    #     pass
    # else:
    #     return render_template('login.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    login = request.form.get('login')
    password = request.form.get('password')

    if login and password:
        user = User.query.filter_by(login=login).first()

        if user and check_password_hash(user.password, password):
            login_user(user)

            next_page = request.args.get('next')

            return redirect(next_page)
        else:
            flash('Login or password incorrect')
    else:
        flash('Please fill login and password fields')

    return render_template('login.html')
    # return render_template('login.html')

@app.route('/logout', methods=['GET', 'POST'])
@login_required
def logout():
    logout_user()
    return redirect(url_for('index'))

@app.after_request
def redirect_to_login(response):
    if response.status_code == 401:
        return redirect(url_for('login') + '?next' + request.url)
    
    return response