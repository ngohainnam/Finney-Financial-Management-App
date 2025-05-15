
import pandas as pd
import joblib
import xgboost as xgb
from sklearn.model_selection import train_test_split

# Load the cleaned dataset (no Occupation)
df = pd.read_csv("final_training_dataset.csv")

# Define features and targets
features = df.drop(columns=["Predicted_Expense", "Predicted_Savings", "Suggested_Budget"])
targets = df[["Predicted_Expense", "Predicted_Savings", "Suggested_Budget"]]

# Train/test split
X_train, X_test, y_train, y_test = train_test_split(features, targets, test_size=0.2, random_state=42)

# Train and save models
for column in targets.columns:
    model = xgb.XGBRegressor(n_estimators=100, max_depth=4, learning_rate=0.1)
    model.fit(X_train, y_train[column])
    joblib.dump(model, f"{column.lower()}_model.joblib")

# Save feature list
with open("model_features.txt", "w") as f:
    f.write(",".join(features.columns.tolist()))

print("Models trained and saved.")
