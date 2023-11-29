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
    acceptancedate = db.Column(db.Date)
    issuedate = db.Column(db.Date)
    warrantyenddate = db.Column(db.Date)
    photobeforerepair = db.Column(db.String(255))
    photoafterrepair = db.Column(db.String(255))
    # category = db.Column(db.Integer, db.ForeignKey('equipment_categories.equipment_catid'), nullable=False)

class User(db.Model, UserMixin):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    login = db.Column(db.String(128), nullable = False, unique = True)
    password = db.Column(db.String(255), nullable = False)

@manager.user_loader
def load_user(user_id):
    return User.query.get(user_id)