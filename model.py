import pandas as pd
import mysql.connector
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline
import joblib

# 🔹 Connect to the database
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'Sm100',
    'database': 'medical'
}

try:
    conn = mysql.connector.connect(**db_config)
    query = "SELECT symptoms, diagnosis FROM patient_symptoms WHERE diagnosis IS NOT NULL AND symptoms IS NOT NULL"
    data = pd.read_sql(query, conn)

    if data.empty:
        raise ValueError("No data found in 'patient_symptoms' table.")

    # 🔹 Build model pipeline
    model = Pipeline([
        ('tfidf', TfidfVectorizer()),
        ('clf', MultinomialNB())
    ])

    # 🔹 Train model
    model.fit(data['symptoms'], data['diagnosis'])

    # 🔹 Save model
    joblib.dump(model, 'diagnosis_model.pkl')
    print("✅ Model trained and saved based on DB data.")

except mysql.connector.Error as err:
    print(f"❌ MySQL Error: {err}")

except Exception as e:
    print(f"❌ Other Error: {e}")

finally:
    if 'conn' in locals() and conn.is_connected():
        conn.close()
