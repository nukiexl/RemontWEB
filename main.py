from Hoodie import app
# from flask import Flask, render_template, request, redirect
# from flask_sqlalchemy import SQLAlchemy

# app = Flask(__name__)
# app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:admin@localhost:5433/remont'
# db = SQLAlchemy(app)


# class Client(db.Model):
#     __tablename__ = 'clients'
#     clientid = db.Column(db.Integer, primary_key=True, autoincrement=True)
#     lastname = db.Column(db.String(30))
#     firstname = db.Column(db.String(30))
#     middlename = db.Column(db.String(30))
#     mobilephone = db.Column(db.String(12))
#     email = db.Column(db.String(255))


# @app.route('/')
# def index():
#     return render_template('index.html')


# @app.route('/about')
# def about():
#     clients = Client.query.order_by(Client.lastname).all()
#     return render_template('about.html', clients=clients)


# @app.route('/create', methods=['GET', 'POST'])
# def create():
#     if request.method == "POST":
#         lastname = request.form['lastname']
#         firstname = request.form['firstname']
#         middlename = request.form['middlename']
#         mobilephone = request.form['mobilephone']
#         email = request.form['email']

#         new_client = Client(
#             lastname=lastname,
#             firstname=firstname,
#             middlename=middlename,
#             mobilephone=mobilephone,
#             email=email
#         )

#         try:
#             db.session.add(new_client)
#             db.session.commit()
#             return redirect('/about')
#         except:
#             return "Ошибка"
    
#     return render_template('create.html')


if __name__ == "__main__":
    app.run(debug=True)