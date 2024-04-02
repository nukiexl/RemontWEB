from flask import render_template, request, redirect, flash, url_for
from flask_login import login_user, login_required, logout_user, current_user
from werkzeug.security import check_password_hash, generate_password_hash
from datetime import datetime, timedelta

from Hoodie import db, app
# from Hoodie.models import Client, User, Equipment, EquipmentCategory, PrimaryInspection, Operator, Order
from Hoodie.models import *
from Hoodie.decorators import auth_role


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/orderlist')
@login_required
def orderlist():
    orders = (Order.query
    .join(Equipment, Order.equipmentid == Equipment.equipmentid)
    .join(OrderStatus, Order.ord_status_id == OrderStatus.ord_status_id)
    .order_by(Order.creationdate.desc()).all())
    return render_template('orderlist.html', orders=orders, get_primary_inspection_result=get_primary_inspection_result)

@app.route('/enginOrderlist')
@login_required
@auth_role(['engin', 'admin'])
def enginOrderlist():
    orders = (Order.query
    .join(Equipment, Order.equipmentid == Equipment.equipmentid)
    .join(OrderStatus, Order.ord_status_id == OrderStatus.ord_status_id)
    .filter(Order.status == 'Принято')
    .order_by(Order.creationdate.desc())
    .all())
    engineers = (Engineer.query.all())
    return render_template('enginOrderlist.html', orders=orders, get_primary_inspection_result=get_primary_inspection_result, engineers=engineers)

@app.route('/take_order/<int:order_id>', methods=['POST'])
@login_required
@auth_role(['engin', 'admin'])
def take_order(order_id):
    engineer_id = request.form.get('engineerid')

    engineer = Engineer.query.get(engineer_id)
    order = Order.query.get(order_id)

    if engineer and order:
        order.status = 'В работе'
        order_engineer = OrderEngineer(order=order, engineer=engineer, user=current_user)
        db.session.add(order_engineer)
        db.session.commit()

        flash('Вы успешно взяли заказ.')
    else:
        flash('Произошла ошибка при взятии заказа.')

    return redirect(url_for('enginOrderlist'))

@app.route('/enginOrders')
@login_required
@auth_role(['engin', 'admin'])
def enginOrders():
    # Находим все заказы, связанные с текущим пользователем через таблицу orders_engineers
    user_orders = (
        OrderEngineer.query
        .filter_by(userid=current_user.id)
        .join(OrderEngineer.order)
        .all()
    )

    return render_template('enginOrders.html', user_orders=user_orders)

@app.route('/createEquipment', methods=['GET', 'POST'])
@login_required
def createEquipment():

    if request.method == "POST":
        serialnumber = request.form.get('serialnumber')
        brand = request.form.get('brand')
        model = request.form.get('model')
        warrantyenddate = datetime.now() + timedelta(days=365)
        # warrantyenddate = request.form.get('warrantyenddate')
        photobeforerepair = request.form.get('photobeforerepair')
        photoafterrepair = request.form.get('photoafterrepair')
        equipment_catid = request.form.get('equipment_catid')

        new_equipment = Equipment(
            serialnumber=serialnumber,
            brand=brand,
            model=model,
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
@auth_role(['oper', 'admin'])
def createOrder():
    clients = Client.query.all()
    operators = Operator.query.all()
    equipment = Equipment.query.all()
    order_statuses = OrderStatus.query.all()
    

    if request.method == "POST":
        clientid = request.form.get('clientid')
        operatorid = request.form.get('operatorid')
        equipmentid = request.form.get('equipmentid')
        creationdate = datetime.now()
        status = 'Принято'
        ord_status_id = request.form.get('ord_status_id')

        new_order = Order(
            clientid=clientid,
            operatorid=operatorid,
            equipmentid=equipmentid,
            creationdate=creationdate,
            status=status,
            ord_status_id = ord_status_id
        )

        try:
            db.session.add(new_order)
            db.session.commit()

            result = request.form.get('result')
            pe_operator_id = new_order.operatorid
            new_inspection = PrimaryInspection(
                operatorid=pe_operator_id,
                equipmentid=equipmentid,
                result=result
            )

            db.session.add(new_inspection)
            db.session.commit()

            oi_order_id = new_order.orderid
            oi_inspection_id = new_inspection.primaryinspectionid
            new_oi = OrderInspection(
                orderid = oi_order_id,
                primaryinspectionid = oi_inspection_id
            )

            db.session.add(new_oi)
            db.session.commit()

            return redirect('/orderlist')
        except Exception as e:
            print(e)
            return "Ошибка"

    return render_template(
        'createOrder.html',
        clients=clients,
        operators=operators,
        equipment=equipment,
        order_statuses=order_statuses
    )

@app.route('/editOrder/<int:order_id>', methods=['GET', 'POST'])
@login_required
def editOrder(order_id):
    order = Order.query.get_or_404(order_id)

    clients = Client.query.all()
    operators = Operator.query.all()
    equipment = Equipment.query.all()
    inspection = db.session.query(PrimaryInspection).join(OrderInspection).filter(OrderInspection.orderid == order_id).all()
    order_statuses = OrderStatus.query.all()

    if request.method == "POST":
        clientid = request.form.get('clientid')
        operatorid = request.form.get('operatorid')
        equipmentid = request.form.get('equipmentid')
        workstartdate = request.form.get('workstartdate')
        workenddate = request.form.get('workenddate')
        partscost = request.form.get('partscost')
        laborcost = request.form.get('laborcost')
        totalcost = request.form.get('totalcost')
        status = request.form.get('status')
        ord_status_id = request.form.get('ord_status_id')

        order.clientid=clientid,
        order.operatorid=operatorid,
        order.equipmentid=equipmentid,
        if workenddate != "":
            order.workstartdate=workstartdate
        if workenddate != "":
            order.workenddate=workenddate,
        order.partscost=partscost,
        order.laborcost=laborcost,
        order.totalcost=totalcost,
        order.status=status,
        order.ord_status_id = ord_status_id

        try:
            db.session.commit()

            result = request.form.get('result')

            if inspection:
                inspection.result = result
                db.session.commit()
            else:
                new_inspection = PrimaryInspection(operatorid=operatorid, equipmentid=equipmentid, result=result)
                order_inspection = OrderInspection(order=order, primaryinspection=new_inspection)
                db.session.add_all([new_inspection, order_inspection])
                db.session.commit()

            return redirect('/orderlist')
        except Exception as e:
            print(e)
            return "Ошибка"

    return render_template(
        'editOrder.html',
        order=order,
        clients=clients,
        operators=operators,
        equipment=equipment,
        inspection=inspection,
        order_statuses=order_statuses
    )

from flask import redirect, url_for

@app.route('/deleteOrder/<int:order_id>', methods=['GET', 'POST'])
@login_required
def deleteOrder(order_id):
    order = Order.query.get_or_404(order_id)

    # Проверка, что текущий пользователь имеет права на удаление заказа
    if not current_user.has_role('admin'):
        # Редирект или возврат ошибки, в зависимости от ваших требований
        return "Недостаточно прав для удаления заказа."

    try:
        # Удаление заказа
        db.session.delete(order)
        db.session.commit()
        flash('Заказ успешно удален.')
    except Exception as e:
        print(e)
        flash('Произошла ошибка при удалении заказа.')

    return redirect(url_for('orderlist'))

@app.route('/createClient', methods=['GET', 'POST'])
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
                flash('Ваша заявка оставлена')
                return redirect('/createClient')
            except:
                return redirect('/createClient')
    
    return render_template('createClient.html')

@app.route('/users', methods=['GET'])
@login_required
@auth_role(['admin'])
def users():
    users = User.query.all()
    roles = Role.query.all()
    return render_template('users.html', users=users, roles=roles)

@app.route('/change_role/<int:user_id>', methods=['POST'])
def change_role(user_id):
    user = User.query.get(user_id)
    if user:
        role_id = request.form.get('role_id')
        if role_id:
            # Находим роль по ID
            role = Role.query.get(role_id)
            if role:
                # Очищаем текущие роли пользователя и добавляем новую роль
                user.roles = [role]
                db.session.commit()
    return redirect(url_for('users'))

@app.route('/register', methods=['GET', 'POST'])
def register():
    roles = Role.query.all()

    login = request.form.get('login')
    password = request.form.get('password')
    password2 = request.form.get('password2')
    roleid = request.form.get('role')

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

            new_user_role = UserRole(userid=new_user.id, roleid=roleid)
            db.session.add(new_user_role)
            db.session.commit()

            return redirect(url_for('login'))
        
    return render_template("register.html", roles=roles)


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
        return redirect(url_for('login') + '?next=' + request.url)
    
    return response