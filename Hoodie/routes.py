from flask import render_template, request, redirect, flash, url_for
from flask_login import login_user, login_required, logout_user
from werkzeug.security import check_password_hash, generate_password_hash

from Hoodie import db, app
# from Hoodie.models import Client, User, Equipment, EquipmentCategory, PrimaryInspection, Operator, Order
from Hoodie.models import *


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

    if request.method == "POST":
        serialnumber = request.form.get('serialnumber')
        brand = request.form.get('brand')
        model = request.form.get('model')
        acceptancedate = request.form.get('acceptancedate')
        issuedate = request.form.get('issuedate')
        warrantyenddate = request.form.get('warrantyenddate')
        photobeforerepair = request.form.get('photobeforerepair')
        photoafterrepair = request.form.get('photoafterrepair')
        equipment_catid = request.form.get('equipment_catid')

        new_equipment = Equipment(
            serialnumber=serialnumber,
            brand=brand,
            model=model,
            acceptancedate=acceptancedate,
            issuedate=issuedate,
            warrantyenddate=warrantyenddate,
            photobeforerepair=photobeforerepair,
            photoafterrepair=photoafterrepair,
            equipment_catid=equipment_catid
        )

        try:
            db.session.add(new_equipment)
            db.session.commit()
            return redirect('/about')
        except:
            return "Ошибка"
    
    equipmentCategories = EquipmentCategory.query.all()

    return render_template('createEquipment.html', equipmentCategories=equipmentCategories)

@app.route('/add_primary_inspection', methods=['GET', 'POST'])
@login_required
def add_primary_inspection():
    if request.method == 'POST':
        operatorid = request.form.get('operator_id')
        equipmentid = request.form.get('equipment_id')
        result = request.form.get('result')

        new_primary_inspection = PrimaryInspection(
            operatorid=operatorid,
            equipmentid=equipmentid,
            result=result
        )

        try:
            db.session.add(new_primary_inspection)
            db.session.commit()
            # flash('Primary inspection added successfully!', 'success')
            return redirect(url_for('index'))  # Или куда вы хотите перенаправить пользователя после добавления
        except:
            return "Ошибка"

    operators = Operator.query.all()
    equipment = Equipment.query.all()

    return render_template('add_primary_inspection.html', operators=operators, equipment=equipment)

@app.route('/createOrder', methods=['GET', 'POST'])
@login_required
def createOrder():
    clients = Client.query.all()
    operators = Operator.query.all()
    engineers = Engineer.query.all()
    equipment = Equipment.query.all()
    inspections = PrimaryInspection.query.all()
    order_statuses = OrderStatus.query.all()

    if request.method == "POST":
        clientid = request.form.get('clientid')
        operatorid = request.form.get('operatorid')
        engineerid = request.form.get('engineerid')
        equipmentid = request.form.get('equipmentid')
        primaryinspectionid = request.form.get('primaryinspectionid')
        creationdate = request.form.get('creationdate')
        workstartdate = request.form.get('workstartdate')
        workenddate = request.form.get('workenddate')
        underwarranty = request.form.get('underwarranty') == 'True'
        partscost = request.form.get('partscost')
        laborcost = request.form.get('laborcost')
        totalcost = request.form.get('totalcost')
        status = request.form.get('status')
        ord_status_id = request.form.get('ord_status_id')

        new_order = Order(
            clientid=clientid,
            operatorid=operatorid,
            engineerid=engineerid,
            equipmentid=equipmentid,
            primaryinspectionid=primaryinspectionid,
            creationdate=creationdate,
            workstartdate=workstartdate,
            workenddate=workenddate,
            underwarranty=underwarranty,
            partscost=partscost,
            laborcost=laborcost,
            totalcost=totalcost,
            status=status,
            ord_status_id = ord_status_id
        )

        try:
            db.session.add(new_order)
            db.session.commit()
            return redirect('/about')  # Измените на нужный URL
        except Exception as e:
            print(e)
            return "Ошибка"

    return render_template(
        'createOrder.html',
        clients=clients,
        operators=operators,
        engineers=engineers,
        equipment=equipment,
        inspections=inspections,
        order_statuses=order_statuses
    )

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