from Hoodie import db, manager
from flask_login import UserMixin

class Client(db.Model):
    __tablename__ = 'clients'
    clientid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    lastname = db.Column(db.String(30))
    firstname = db.Column(db.String(30))
    middlename = db.Column(db.String(30))
    mobilephone = db.Column(db.String(12))
    email = db.Column(db.String(255))

class Equipment(db.Model):
    __tablename__ = 'equipment'
    equipmentid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    serialnumber = db.Column(db.String(100), nullable=False)
    brand = db.Column(db.String(30), nullable=False)
    model = db.Column(db.String(50), nullable=False)
    warrantyenddate = db.Column(db.Date)
    photobeforerepair = db.Column(db.String(255))
    photoafterrepair = db.Column(db.String(255))
    equipment_catid = db.Column(db.Integer, db.ForeignKey('equipment_categories.equipment_catid'), nullable=False)

    EquipmentCategory = db.relationship('EquipmentCategory', backref='equipment')

class EquipmentCategory(db.Model):
    __tablename__ = 'equipment_categories'
    equipment_catid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    equipment_catname = db.Column(db.String(20), nullable=False)

class Operator(db.Model):
    __tablename__ = "operators"
    operatorid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    lastname = db.Column(db.String(30))
    firstname = db.Column(db.String(30))
    middlename = db.Column(db.String(30))
    birthdate = db.Column(db.Date)
    passportseries = db.Column(db.String(5))
    passportnumber = db.Column(db.String(6))
    passportissuedate = db.Column(db.Date)
    passportissuingauthority = db.Column(db.String(100))
    mobilephone = db.Column(db.String(11))
    email = db.Column(db.String(255))
    city = db.Column(db.String(50))
    house = db.Column(db.String(4))
    apartment = db.Column(db.String(5))
    photo = db.Column(db.String(255))

class PrimaryInspection(db.Model):
    __tablename__ = 'primaryinspections'
    primaryinspectionid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    operatorid = db.Column(db.Integer, db.ForeignKey('operators.operatorid'), nullable=False)
    equipmentid = db.Column(db.Integer, db.ForeignKey('equipment.equipmentid'), nullable=False)
    result = db.Column(db.String(255), nullable=False)

    operator = db.relationship('Operator', backref='primary_inspections')
    equipment = db.relationship('Equipment', backref='primary_inspections')

class Order(db.Model):
    __tablename__ = 'orders'

    orderid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    clientid = db.Column(db.Integer, db.ForeignKey('clients.clientid'), nullable=False)
    operatorid = db.Column(db.Integer, db.ForeignKey('operators.operatorid'), nullable=False)
    equipmentid = db.Column(db.Integer, db.ForeignKey('equipment.equipmentid'))
    creationdate = db.Column(db.Date)
    workstartdate = db.Column(db.Date, nullable=True)
    workenddate = db.Column(db.Date, nullable=True)
    underwarranty = db.Column(db.Boolean, nullable=True)
    partscost = db.Column(db.Numeric(12, 2))
    laborcost = db.Column(db.Numeric(12, 2))
    totalcost = db.Column(db.Numeric(12, 2))
    status = db.Column(db.String(20))
    ord_status_id = db.Column(db.Integer, db.ForeignKey('orders_status.ord_status_id'), nullable=False)

    client = db.relationship('Client', backref='orders')
    operator = db.relationship('Operator', backref='orders')
    equipment = db.relationship('Equipment', backref='orders')
    order_status = db.relationship('OrderStatus', backref='orders')

class OrderStatus(db.Model):
    __tablename__ = 'orders_status'

    ord_status_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    status_name = db.Column(db.String(20), nullable=False)

class OrderEngineer(db.Model):
    __tablename__ = 'orders_engineers'
    oeid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    orderid = db.Column(db.Integer, db.ForeignKey('orders.orderid'))
    engineerid = db.Column(db.Integer, db.ForeignKey('engineers.engineerid'))
    userid = db.Column(db.Integer, db.ForeignKey('users.id'))

    order = db.relationship('Order', backref='orders_engineers')
    engineer = db.relationship('Engineer', backref='orders_engineers')
    user = db.relationship('User', backref='orders_engineers')

class OrderInspection(db.Model):
    __tablename__ = 'orders_inspections'
    oiid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    orderid = db.Column(db.Integer, db.ForeignKey('orders.orderid'))
    primaryinspectionid = db.Column(db.Integer, db.ForeignKey('primaryinspections.primaryinspectionid'))

    order = db.relationship('Order', backref='orders_inspections')
    primaryinspection = db.relationship('PrimaryInspection', backref='orders_inspections')

class Engineer(db.Model):
    __tablename__ = 'engineers'

    engineerid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    lastname = db.Column(db.String(30), nullable=False)
    firstname = db.Column(db.String(30), nullable=False)
    middlename = db.Column(db.String(30), nullable=False)
    birthdate = db.Column(db.Date)
    passportseries = db.Column(db.String(5))
    passportnumber = db.Column(db.String(6))
    passportissuedate = db.Column(db.Date)
    passportissuingauthority = db.Column(db.String(100))
    mobilephone = db.Column(db.String(11))
    email = db.Column(db.String(255))
    city = db.Column(db.String(50))
    district = db.Column(db.String(50))
    street = db.Column(db.String(50))
    house = db.Column(db.String(4))
    apartment = db.Column(db.String(5))
    photo = db.Column(db.String(255))
    qualification = db.Column(db.Integer, db.ForeignKey('qualifications.qualiid'), nullable=False)

    qualification_rel = db.relationship('Qualification', backref='engineers')

class Qualification(db.Model):
    __tablename__ = 'qualifications'

    qualiid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    qualificationname = db.Column(db.String(30), nullable=False)

class User(db.Model, UserMixin):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    login = db.Column(db.String(128), nullable = False, unique = True)
    password = db.Column(db.String(255), nullable = False)

    roles = db.relationship("Role", secondary="users_roles", back_populates="users")

    def has_role(self, role):
        return bool(
            Role.query
            .join(Role.users)
            .filter(User.id == self.id)
            .filter(Role.roleslug == role)
            .count() == 1
        )

class Role(db.Model):
    __tablename__ = 'roles'
    roleid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    rolename = db.Column(db.String(20), nullable = False)
    roleslug = db.Column(db.String(20), nullable = False)

    users = db.relationship("User", secondary="users_roles", back_populates="roles")

class UserRole(db.Model):
    __tablename__ = 'users_roles'
    userid = db.Column(db.Integer, db.ForeignKey('users.id'), primary_key = True)
    roleid = db.Column(db.Integer, db.ForeignKey('roles.roleid'), primary_key = True)

@manager.user_loader
def load_user(user_id):
    return User.query.get(user_id)

def get_primary_inspection_result(order_id):
    order_inspection = OrderInspection.query.filter_by(orderid=order_id).first()

    if order_inspection:
        return order_inspection.primaryinspection.result
    else:
        return "Результат первичного осмотра отсутствует"