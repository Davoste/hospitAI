from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector

app = Flask(__name__)
CORS(app)  # allows cross-origin requests from Flutter

# ✅ MySQL connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Sm100",  
    database="medical"
)
cursor = db.cursor()

# 📥 API to receive patient data
@app.route('/add_patient', methods=['POST'])
def add_patient():
    data = request.get_json()

    try:
        query = """
        INSERT INTO patients 
        (name, age, gender, dob, address, phone, email, conditions, allergies, medications, emergency_contact_name, emergency_contact_number)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        values = (
            data['name'],
            data['age'],
            data['gender'],
            data['dob'],
            data['address'],
            data['phone'],
            data.get('email', ''),
            data.get('conditions', ''),
            data.get('allergies', ''),
            data.get('medications', ''),
            data['emergency_contact_name'],
            data['emergency_contact_number']
        )

        cursor.execute(query, values)
        db.commit()

        return jsonify({"status": "success"}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500
    
@app.route('/get_patients', methods=['GET'])
def get_patients():
    page = int(request.args.get('page', 1))
    limit = int(request.args.get('limit', 10))
    offset = (page - 1) * limit

    try:
        cursor.execute("SELECT id, name, dob, phone FROM patients LIMIT %s OFFSET %s", (limit, offset))
        rows = cursor.fetchall()
        patients = [{
            "id": row[0],
            "name": row[1],
            "dob": str(row[2]),
            "phone": row[3],
        } for row in rows]
        return jsonify(patients), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

    
# 🗑 Delete a patient by ID
@app.route('/delete_patient/<int:patient_id>', methods=['DELETE'])
def delete_patient(patient_id):
    try:
        cursor.execute("DELETE FROM patients WHERE id = %s", (patient_id,))
        db.commit()
        return jsonify({"status": "success"}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

# ✏️ Update a patient by ID
@app.route('/update_patient/<int:patient_id>', methods=['PUT'])
def update_patient(patient_id):
    data = request.get_json()
    try:
        query = """
        UPDATE patients
        SET name=%s, dob=%s, phone=%s
        WHERE id=%s
        """
        cursor.execute(query, (
            data['name'],
            data['dob'],
            data['phone'],
            patient_id
        ))
        db.commit()
        return jsonify({"status": "success"}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500
    
# 🔢 Get total number of patients
@app.route('/total_patients')
def total_patients():
    try:
        cursor.execute("SELECT COUNT(*) FROM patients")
        total = cursor.fetchone()[0]
        return jsonify({'total': total}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

@app.route('/search_patients')
def search_patients():
    query = request.args.get('q', '')
    try:
        cursor.execute("""
            SELECT id, name, dob, phone FROM patients
            WHERE name LIKE %s OR email LIKE %s OR phone LIKE %s
        """, (f'%{query}%', f'%{query}%', f'%{query}%'))
        rows = cursor.fetchall()
        result = [
            {'id': row[0], 'name': row[1], 'dob': str(row[2]), 'phone': row[3]}
            for row in rows
        ]
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

@app.route('/add_patient_symptoms', methods=['POST'])
def add_patient_symptoms():
    data = request.get_json()
    patient_id = data.get('patient_id')
    symptoms = data.get('symptom', 'mild')  # 📝 This is actually a symptom description
    severity = data.get('severity', 'mild')
    notes = data.get('notes', '')
    diagnosis = data.get('diagnosis', '')

    try:
        # 1️⃣ Confirm the patient exists
        cursor.execute("SELECT id FROM patients WHERE id = %s", (patient_id,))
        if cursor.fetchone() is None:
            return jsonify({"status": "error", "message": "Patient not found"}), 404

        # 2️⃣ Insert into patient_symptoms
        query = """
        INSERT INTO patient_symbols (patient_id, date_reported, severity, notes, symptoms, diagnosis)
        VALUES (%s, NOW(), %s, %s, %s, %s)
        """
        values = (patient_id, severity, notes, symptoms, diagnosis)

        cursor.execute(query, values)
        db.commit()

        return jsonify({"status": "success", "message": "Symptoms added"}), 200

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)
