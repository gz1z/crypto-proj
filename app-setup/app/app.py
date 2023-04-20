from flask import Flask, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine
from datetime import datetime
import random

# Initialize Flask app
app = Flask(__name__)

# Configure database connection
connection_db = "postgresql://postgres_user:postgrespwd@db:5432/postgresdb"
app.config["SQLALCHEMY_DATABASE_URI"] = connection_db
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize SQLAlchemy database object
engine = create_engine(connection_db)
db = SQLAlchemy(app)

# Define a data model for the database
class SensorData(db.Model):
    __tablename__ = 'sensor_data'
    id = db.Column(db.Integer, primary_key=True)
    sensor_type = db.Column(db.String(50), nullable=False)
    data_value = db.Column(db.Float, nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

    def __repr__(self):
        return f"<SensorData(sensor_type='{self.sensor_type}', data_value='{self.data_value}', timestamp='{self.timestamp}')>"

# Create database table if it doesn't exist
if not engine.dialect.has_table(engine, SensorData.__tablename__):
    db.create_all()


@app.route('/app', methods=['GET'])
def index():
    return "Hey there! \n"

# Define the endpoint for receiving data and inserting it to the database
@app.route('/api/sensor-data', methods=['POST'])
def add_sensor_data():
    # Parse the data from the request
    data = request.json
    sensor_type = data.get('sensor_type')
    data_value = data.get('data_value')

    # Insert the data into the database
    sensor_data = SensorData(sensor_type=sensor_type, data_value=data_value)
    db.session.add(sensor_data)
    db.session.commit()

    # Return a response indicating success
    return {'message': 'Data successfully added to database.'}, 201

# Define an endpoint for generating fake sensor data
@app.route('/api/fake-sensor-data', methods=['POST'])
def generate_fake_sensor_data():
    # Parse the data from the request
    data = request.json
    sensor_type = data.get('sensor_type')
    num_values = data.get('num_values')

    # Generate fake sensor data
    fake_data = []
    for i in range(num_values):
        data_value = round(random.uniform(0, 100), 2)
        timestamp = datetime.utcnow()
        sensor_data = SensorData(sensor_type=sensor_type, data_value=data_value, timestamp=timestamp)
        db.session.add(sensor_data)
        fake_data.append(sensor_data)

    db.session.commit()

    # Return a response with the generated fake data
    return {'message': 'Fake data successfully added to database.'}, 201