import os
import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, confusion_matrix
import joblib

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DATASET_PATH = os.path.join(SCRIPT_DIR, 'fault_dataset.csv')
MODEL_PATH = os.path.join(SCRIPT_DIR, 'fault_model.pkl')


def main():
    print('تحميل البيانات...')
    df = pd.read_csv(DATASET_PATH, encoding='utf-8')

    print('تنظيف البيانات...')
    df = df.dropna()
    df = df.apply(lambda x: x.str.strip() if x.dtype == 'object' else x)

    print('تحويل النصوص إلى أرقام باستخدام LabelEncoder...')
    encoders = {}
    df_encoded = df.copy()

    for col in ['device_type', 'symptom_1', 'symptom_2', 'symptom_3', 'fault_label']:
        le = LabelEncoder()
        df_encoded[col] = le.fit_transform(df[col].astype(str))
        encoders[col] = le

    X = df_encoded[['device_type', 'symptom_1', 'symptom_2', 'symptom_3']]
    y = df_encoded['fault_label']

    print('تقسيم البيانات إلى Training Set و Testing Set...')
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42
    )

    print('\n--- Decision Tree Classifier ---')
    dt_model = DecisionTreeClassifier(random_state=42)
    dt_model.fit(X_train, y_train)
    dt_pred = dt_model.predict(X_test)
    dt_accuracy = accuracy_score(y_test, dt_pred)
    print(f'Accuracy: {dt_accuracy:.4f}')
    print('Confusion Matrix:')
    print(confusion_matrix(y_test, dt_pred))

    print('\n--- Random Forest Classifier (للمقارنة) ---')
    rf_model = RandomForestClassifier(random_state=42, n_estimators=100)
    rf_model.fit(X_train, y_train)
    rf_pred = rf_model.predict(X_test)
    rf_accuracy = accuracy_score(y_test, rf_pred)
    print(f'Accuracy: {rf_accuracy:.4f}')
    print('Confusion Matrix:')
    print(confusion_matrix(y_test, rf_pred))

    print('\n--- حفظ النموذج (Decision Tree) ---')
    model_data = {
        'model': dt_model,
        'encoders': encoders,
    }
    joblib.dump(model_data, MODEL_PATH)
    print(f'تم حفظ النموذج في: {MODEL_PATH}')


if __name__ == '__main__':
    main()
