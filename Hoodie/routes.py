from flask import render_template, request, redirect, flash, url_for
from flask_login import login_user, login_required, logout_user
from werkzeug.security import check_password_hash, generate_password_hash

from Hoodie import db, app
from Hoodie.models import Client, User, Equipment, EquipmentCategory

@app.route('/')
def index():
    return render_template('index.html')


@app.route('/about')
@login_required
def about():
    clients = Client.query.order_by(Client.lastname).all()
    return render_template('about.html', clients=clients)


@app.route('/createEquipment', methods=['GET', 'POST'])
@login_required
def createEquipment():
    category = EquipmentCategory.query.order_by(EquipmentCategory.equipment_catid).all()

    if request.method == "POST":
        serialnumber = request.form['serialnumber']
        brand = request.form['brand']
        model = request.form['model']
        acceptancedate = request.form['acceptancedate']
        issuedate = request.form['issuedate']
        warrantyenddate = request.form['warrantyenddate']
        photobeforerepair = request.form['photobeforerepair']
        photoafterrepair = request.form['photoafterrepair']
        category = request.form['category']

        new_equipment = Equipment(
            serialnumber=serialnumber,
            brand=brand,
            model=model,
            acceptancedate=acceptancedate,
            issuedate=issuedate,
            warrantyenddate=warrantyenddate,
            photobeforerepair=photobeforerepair,
            photoafterrepair=photoafterrepair,
            category=category
        )

        try:
            db.session.add(new_equipment)
            db.session.commit()
            return redirect('/about')
        except:
            return "Ошибка"
    
    return render_template('createEquipment.html', category=category)

@app.route('/create', methods=['GET', 'POST'])
@login_required
def create():
    clients = Client.query.order_by(Client.lastname).all()

    if request.method == "POST":
        serialnumber = request.form['serialnumber']
        brand = request.form['brand']
        model = request.form['model']
        acceptancedate = request.form['acceptancedate']
        issuedate = request.form['issuedate']
        warrantyenddate = request.form['warrantyenddate']
        photobeforerepair = request.form['photobeforerepair']
        photoafterrepair = request.form['photoafterrepair']

        new_equipment = Equipment(
            serialnumber=serialnumber,
            brand=brand,
            model=model,
            acceptancedate=acceptancedate,
            issuedate=issuedate,
            warrantyenddate=warrantyenddate,
            photobeforerepair=photobeforerepair,
            photoafterrepair=photoafterrepair
        )

        try:
            db.session.add(new_equipment)
            db.session.commit()
            return redirect('/about')
        except:
            return "Ошибка"
    
    return render_template('create.html', clients=clients)

@app.route('/createClient', methods=['GET', 'POST'])
@login_required
def createClient():

    if request.method == "POST":
        lastname = request.form['lastname']
        firstname = request.form['firstname']
        middlename = request.form['middlename']
        mobilephone = request.form['mobilephone']
        email = request.form['email']

        if not(lastname or firstname or mobilephone):
            flash('Заполните обязательный поля')
        else:
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
                return redirect('/create')
            except:
                return redirect('/createClient')
    
    return render_template('createClient.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    login = request.form.get('login')
    password = request.form.get('password')
    password2 = request.form.get('password2')

    if request.method == 'POST':
        if not(login or password or password2):
            flash('Заполните все поля')
        elif password != password2:
            flash('Пароли не совпадают')
        else:
            hash_pwd = generate_password_hash(password)
            new_user = User(login = login, password = hash_pwd)
            db.session.add(new_user)
            db.session.commit()

            return redirect(url_for('login'))
        
    return render_template("register.html")


@app.route('/login', methods=['GET', 'POST'])
def login():
    login = request.form.get('login')
    password = request.form.get('password')

    if login and password:
        user = User.query.filter_by(login=login).first()

        if user and check_password_hash(user.password, password):
            login_user(user)

            next_page = request.args.get('next')

            return redirect(next_page) if next_page else redirect(url_for('index'))
        else:
            flash('Логин и/или пароль неправильны')
    else:
        flash('Заполните все поля')

    return render_template('login.html')


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