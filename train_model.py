# train_model.py (Upgraded ML training with smart features)

import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
import joblib
from datetime import datetime, timedelta

# Generate smarter mock data for training
np.random.seed(42)
data = []

for _ in range(500):
    avg_monthly_saving = np.random.uniform(100, 2000)
    total_income = np.random.uniform(3000, 7000)
    total_expense = total_income - avg_monthly_saving
    income_to_expense_ratio = total_income / total_expense
    spending_variability = np.random.uniform(0.1, 0.5) * avg_monthly_saving  # standard deviation
    months_active = np.random.randint(3, 24)

    yearly_saving = avg_monthly_saving * 12 + np.random.normal(0, 300)

    data.append([
        avg_monthly_saving,
        income_to_expense_ratio,
        spending_variability,
        months_active,
        yearly_saving
    ])

columns = [
    'avg_monthly_saving',
    'income_to_expense_ratio',
    'spending_variability',
    'months_active',
    'yearly_saving'
]

df = pd.DataFrame(data, columns=columns)

X = df.drop('yearly_saving', axis=1)
y = df['yearly_saving']

model = RandomForestRegressor(n_estimators=100, random_state=42)
model.fit(X, y)

joblib.dump(model, 'model.pkl')
print("✅ Upgraded model trained and saved as model.pkl")


# app.py (only the updated parts to use new features)

# In preprocess() replace with:
def preprocess(transactions):
    df = pd.DataFrame(transactions)
    df['date'] = pd.to_datetime(df['date'])
    df['month'] = df['date'].dt.to_period('M')

    monthly_net = df.groupby('month')['amount'].sum()
    avg_saving = monthly_net.mean()
    spending_std = monthly_net.std() if len(monthly_net) > 1 else 0
    months_active = len(monthly_net)

    income_total = sum(tx['amount'] for tx in transactions if tx['amount'] > 0)
    expense_total = abs(sum(tx['amount'] for tx in transactions if tx['amount'] < 0))

    income_to_expense_ratio = income_total / expense_total if expense_total else 1

    return np.array([[avg_saving, income_to_expense_ratio, spending_std, months_active]])
