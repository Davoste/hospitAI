import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline
import joblib

# 🔹 Load or create sample data
data = pd.DataFrame({
    'symptoms': [
        'fever cough body ache',
        'headache blurred vision',
        'nausea vomiting dizziness',
        'sore throat fever sneezing',
        'chest pain shortness of breath'
    ],
    'diagnosis': [
        'flu',
        'migraine',
        'food poisoning',
        'cold',
        'heart condition'
    ]
})

# 🔹 Build model pipeline
model = Pipeline([
    ('tfidf', TfidfVectorizer()),
    ('clf', MultinomialNB())
])

# 🔹 Train model
model.fit(data['symptoms'], data['diagnosis'])

# 🔹 Save model
joblib.dump(model, 'diagnosis_model.pkl')
print("Model trained and saved.")
