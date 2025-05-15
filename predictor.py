from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
import pandas as pd
import joblib

# ✅ Load models
expense_model = joblib.load("predicted_expense_model.joblib")
savings_model = joblib.load("predicted_savings_model.joblib")
budget_model = joblib.load("suggested_budget_model.joblib")

# ✅ Load features
with open("model_features.txt", "r") as f:
    model_features = f.read().split(",")

# ✅ Create FastAPI app
app = FastAPI()

# ✅ Define schemas
class Transaction(BaseModel):
    name: str
    category: str
    amount: float
    date: str
    description: str = ""

class PredictionRequest(BaseModel):
    transactions: List[Transaction]

# ✅ Define feature preprocessing
def preprocess_transactions(transactions: List[Transaction]) -> pd.DataFrame:
    df = pd.DataFrame([t.dict() for t in transactions])
    df["amount"] = pd.to_numeric(df["amount"], errors="coerce").fillna(0)
    df["date"] = pd.to_datetime(df["date"], errors="coerce")

    income = df[df["amount"] > 0]["amount"].sum()

    def total_for(cat_list):
        return abs(df[df["category"].str.lower().isin(cat_list)]["amount"].sum())

    feature_row = {
        "Income": income,
        "Rent": total_for(["rent", "housing"]),
        "Loan_Repayment": total_for(["loan", "repayment"]),
        "Insurance": total_for(["insurance"]),
        "Groceries": total_for(["groceries", "food"]),
        "Transport": total_for(["transport", "commute", "fuel"]),
        "Eating_Out": total_for(["eating out", "dining", "restaurant"]),
        "Entertainment": total_for(["entertainment", "netflix", "movies"]),
        "Utilities": total_for(["utilities", "electricity", "gas", "water"]),
        "Healthcare": total_for(["health", "medical"]),
        "Education": total_for(["education", "tuition", "books"]),
        "Miscellaneous": total_for(["misc", "other", "general"])
    }

    # Fill in any missing features with 0
    for col in model_features:
        if col not in feature_row:
            feature_row[col] = 0.0

    return pd.DataFrame([feature_row])[model_features]

# ✅ Define POST route (most important!)
@app.post("/predict")
def predict(request: PredictionRequest):
    try:
        input_df = preprocess_transactions(request.transactions)

        predicted_expense = float(expense_model.predict(input_df)[0])
        predicted_savings = float(savings_model.predict(input_df)[0])
        suggested_budget = float(budget_model.predict(input_df)[0])

        return {
            "predictedExpense": round(predicted_expense, 2),
            "predictedSavings": round(predicted_savings, 2),
            "suggestedBudget": round(suggested_budget, 2)
        }

    except Exception as e:
        return {"error": str(e)}
