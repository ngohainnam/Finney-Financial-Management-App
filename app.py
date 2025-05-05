from flask import Flask, request, jsonify
import joblib
import numpy as np
import pandas as pd
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Load trained model
model = joblib.load("model.pkl")

# Convert transactions into feature (avg monthly saving)
def preprocess(transactions):
    df = pd.DataFrame(transactions)
    df['date'] = pd.to_datetime(df['date'])
    df['month'] = df['date'].dt.to_period('M')
    monthly_net = df.groupby('month')['amount'].sum()
    avg_saving = monthly_net.mean()
    return np.array([[avg_saving]])

@app.route('/predict-savings', methods=['POST'])
def predict_savings():
    data = request.get_json()
    transactions = data.get("transactions", [])

    if not transactions:
        return jsonify({"error": "No transactions provided"}), 400

    X = preprocess(transactions)
    pred = model.predict(X)[0]

    margin = pred * 0.15
    lower = round(pred - margin)
    upper = round(pred + margin)

    return jsonify({
        "predicted_savings": round(pred),
        "lower_bound": lower,
        "upper_bound": upper
    })

if __name__ == '__main__':
   if __name__ == '__main__':
    print("✅ Starting Flask API on port 5050...")
    app.run(debug=True, port=5050)


