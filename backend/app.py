import os
import sqlite3
import hashlib
import secrets
import numpy as np
from flask import Flask, request, jsonify, send_from_directory
import joblib
from werkzeug.utils import safe_join

from ai.fault_details import get_fault_details

app = Flask(__name__)
app.secret_key = secrets.token_hex(16)

AI_DIR = os.path.join(os.path.dirname(__file__), 'ai')
MODEL_PATH = os.path.join(AI_DIR, 'fault_model.pkl')
_model_data = None


def load_model():
    global _model_data
    if _model_data is None and os.path.exists(MODEL_PATH):
        _model_data = joblib.load(MODEL_PATH)
    return _model_data

_BACKEND_DIR = os.path.dirname(os.path.abspath(__file__))
DATABASE = os.path.join(_BACKEND_DIR, 'database.db')
WEB_ROOT = os.path.join(_BACKEND_DIR, 'web')


def get_db():
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row
    return conn


def _hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()


def init_db():
    conn = get_db()
    conn.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE NOT NULL,
            password_hash TEXT NOT NULL,
            name TEXT NOT NULL,
            phone TEXT,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    conn.execute('''
        CREATE TABLE IF NOT EXISTS user_tokens (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            token TEXT NOT NULL UNIQUE,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id)
        )
    ''')
    conn.execute('''
        CREATE TABLE IF NOT EXISTS devices (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            device_type TEXT NOT NULL,
            brand TEXT NOT NULL,
            model TEXT NOT NULL,
            custom_name TEXT NOT NULL,
            purchase_date TEXT,
            warranty_expiry TEXT,
            status TEXT DEFAULT 'يعمل جيداً',
            FOREIGN KEY (user_id) REFERENCES users(id)
        )
    ''')
    try:
        cursor = conn.execute('PRAGMA table_info(devices)')
        columns = [row[1] for row in cursor.fetchall()]
        if 'user_id' not in columns:
            conn.execute('ALTER TABLE devices ADD COLUMN user_id INTEGER')
    except sqlite3.OperationalError:
        pass
    conn.execute('''
        CREATE TABLE IF NOT EXISTS issues (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            device_type TEXT NOT NULL,
            issue_name TEXT NOT NULL,
            possible_causes TEXT NOT NULL,
            solutions TEXT NOT NULL,
            warnings TEXT NOT NULL
        )
    ''')
    cursor = conn.execute('SELECT COUNT(*) FROM issues')
    if cursor.fetchone()[0] == 0:
        _seed_issues(conn)
    conn.commit()
    conn.close()


def _seed_issues(conn):
    issues_data = [
        ('ثلاجة', 'لا تبرد', 'عدم وجود كهرباء\nانسداد الفلتر\nعطل في الكمبروسر',
         'تحقق من القاطع الكهربائي\nافصل الجهاز لمدة 5 دقائق\nأعد تشغيل الجهاز\nتأكد من نظافة الفلاتر',
         'لا تفتح غطاء الكمبروسر\nلا تلمس الأسلاك المكشوفة\nافصل الكهرباء قبل الفحص'),
        ('ثلاجة', 'تسريب ماء', 'انسداد فتحة التصريف\nتلف خرطوم التصريف',
         'نظف فتحة التصريف\nتحقق من خرطوم التصريف\nتأكد من مستوى الجهاز',
         'افصل الكهرباء قبل الفحص\nلا تلمس الماء مع الكهرباء'),
        ('ثلاجة', 'صوت مرتفع', 'الجهاز غير مستوٍ\nمروحة متسخة\nمشكلة في الكمبروسر',
         'تأكد من استواء الجهاز\nنظف المروحة\nتحقق من ثبات الأرفف',
         'افصل الكهرباء قبل الفحص'),
        ('ثلاجة', 'تجمد زائد', 'درجة حرارة منخفضة جداً\nمروحة التبريد لا تعمل',
         'اضبط درجة الحرارة\nتحقق من المروحة\nافصل الجهاز واترك الجليد يذوب',
         'افصل الكهرباء قبل الفحص'),
        ('ثلاجة', 'توقف عن العمل', 'عدم وجود كهرباء\nعطل في الكمبروسر',
         'تحقق من القاطع الكهربائي\nافصل لمدة 5 دقائق وأعد التشغيل',
         'لا تفتح غطاء الكمبروسر'),
        ('مكيف', 'لا يبرد', 'عدم وجود كهرباء\nفلتر مسدود\nنقص في الفريون',
         'تحقق من القاطع الكهربائي\nنظف الفلتر\nتحقق من إعدادات التبريد',
         'لا تفتح وحدة الضغط\nافصل الكهرباء قبل الفحص'),
        ('مكيف', 'تسريب ماء', 'انسداد مجرى التصريف\nفلتر متسخ',
         'نظف مجرى التصريف\nنظف الفلتر',
         'افصل الكهرباء قبل الفحص'),
        ('مكيف', 'صوت مرتفع', 'الجهاز غير مستوٍ\nمروحة متسخة',
         'تأكد من استواء الجهاز\nنظف المروحة والفلتر',
         'افصل الكهرباء قبل الفحص'),
        ('تلفزيون', 'لا يعمل', 'عدم وجود كهرباء\nمشكلة في الريموت\nعطل في الشاشة',
         'تحقق من القاطع الكهربائي\nتحقق من البطاريات\nافصل وأعد التشغيل',
         'لا تفتح الجهاز بنفسك'),
        ('تلفزيون', 'صورة مشوشة', 'إشارة ضعيفة\nكابل تالف',
         'تحقق من الإشارة\nتحقق من الكابلات',
         'افصل الكهرباء قبل الفحص'),
        ('غسالة', 'لا تدور', 'حمل غير متوازن\nمشكلة في المحرك',
         'وزّع الملابس بشكل متوازن\nتحقق من إغلاق الباب',
         'افصل الكهرباء قبل الفحص'),
        ('غسالة', 'تسريب ماء', 'خرطوم تالف\nفلتر مسدود',
         'تحقق من الخراطيم\nنظف الفلتر',
         'افصل الكهرباء والماء قبل الفحص'),
        ('جوال', 'لا يشحن', 'كابل تالف\nمنفذ الشحن متسخ',
         'جرب كابل آخر\nنظف منفذ الشحن',
         'لا تستخدم شاحن غير أصلي'),
        ('رسيفر', 'لا يعمل', 'عدم وجود كهرباء\nمشكلة في الإشارة',
         'تحقق من القاطع الكهربائي\nتحقق من كابل الإشارة',
         'افصل الكهرباء قبل الفحص'),
        ('حاسب', 'لا يعمل', 'عدم وجود كهرباء\nمشكلة في الشاحن',
         'تحقق من القاطع الكهربائي\nتحقق من كابل الشحن',
         'افصل الكهرباء قبل الفحص'),
    ]
    for row in issues_data:
        conn.execute(
            'INSERT INTO issues (device_type, issue_name, possible_causes, solutions, warnings) VALUES (?, ?, ?, ?, ?)',
            row
        )


def _get_user_from_token():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    if not token:
        return None
    conn = get_db()
    cursor = conn.execute(
        'SELECT user_id FROM user_tokens WHERE token = ?', (token,)
    )
    row = cursor.fetchone()
    conn.close()
    return row['user_id'] if row else None


@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    if not data:
        return jsonify({'error': 'No data'}), 400
    email = data.get('email', '').strip().lower()
    password = data.get('password', '')
    name = data.get('name', '').strip()
    phone = data.get('phone', '').strip()

    if not email or not password or not name:
        return jsonify({'error': 'البريد الإلكتروني وكلمة المرور والاسم مطلوبة'}), 400
    if len(password) < 6:
        return jsonify({'error': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'}), 400

    conn = get_db()
    cursor = conn.execute('SELECT id FROM users WHERE email = ?', (email,))
    if cursor.fetchone():
        conn.close()
        return jsonify({'error': 'البريد الإلكتروني مستخدم مسبقاً'}), 400

    password_hash = _hash_password(password)
    conn.execute(
        'INSERT INTO users (email, password_hash, name, phone) VALUES (?, ?, ?, ?)',
        (email, password_hash, name, phone or None)
    )
    user_id = conn.execute('SELECT last_insert_rowid()').fetchone()[0]
    token = secrets.token_hex(32)
    conn.execute('INSERT INTO user_tokens (user_id, token) VALUES (?, ?)', (user_id, token))
    conn.commit()

    cursor = conn.execute(
        'SELECT id, email, name, phone FROM users WHERE id = ?', (user_id,)
    )
    user = dict(cursor.fetchone())
    conn.close()

    user['token'] = token
    return jsonify(user)


@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    if not data:
        return jsonify({'error': 'No data'}), 400
    email = data.get('email', '').strip().lower()
    password = data.get('password', '')

    if not email or not password:
        return jsonify({'error': 'البريد الإلكتروني وكلمة المرور مطلوبة'}), 400

    password_hash = _hash_password(password)
    conn = get_db()
    cursor = conn.execute(
        'SELECT id, email, name, phone FROM users WHERE email = ? AND password_hash = ?',
        (email, password_hash)
    )
    row = cursor.fetchone()
    if not row:
        conn.close()
        return jsonify({'error': 'البريد الإلكتروني أو كلمة المرور غير صحيحة'}), 401

    user = dict(row)
    token = secrets.token_hex(32)
    conn.execute('INSERT INTO user_tokens (user_id, token) VALUES (?, ?)', (user['id'], token))
    conn.commit()
    conn.close()

    user['token'] = token
    return jsonify(user)


@app.route('/user/profile', methods=['GET'])
def get_profile():
    user_id = _get_user_from_token()
    if not user_id:
        return jsonify({'error': 'غير مصرح'}), 401

    conn = get_db()
    cursor = conn.execute(
        'SELECT id, email, name, phone FROM users WHERE id = ?', (user_id,)
    )
    row = cursor.fetchone()
    conn.close()
    if not row:
        return jsonify({'error': 'Not found'}), 404
    return jsonify(dict(row))


@app.route('/user/update', methods=['PUT'])
def update_profile():
    user_id = _get_user_from_token()
    if not user_id:
        return jsonify({'error': 'غير مصرح'}), 401

    data = request.get_json()
    if not data:
        return jsonify({'error': 'No data'}), 400

    name = data.get('name', '').strip()
    phone = data.get('phone', '').strip()
    new_password = data.get('new_password', '')

    conn = get_db()
    updates = []
    params = []

    if name:
        updates.append('name = ?')
        params.append(name)
    if phone is not None:
        updates.append('phone = ?')
        params.append(phone or None)
    if new_password and len(new_password) >= 6:
        updates.append('password_hash = ?')
        params.append(_hash_password(new_password))

    if not updates:
        return jsonify({'error': 'لا توجد بيانات للتحديث'}), 400

    params.append(user_id)
    conn.execute(
        f"UPDATE users SET {', '.join(updates)} WHERE id = ?",
        params
    )
    conn.commit()

    cursor = conn.execute(
        'SELECT id, email, name, phone FROM users WHERE id = ?', (user_id,)
    )
    user = dict(cursor.fetchone())
    conn.close()
    return jsonify(user)


@app.route('/add_device', methods=['POST'])
def add_device():
    data = request.get_json()
    if not data:
        return jsonify({'error': 'No data'}), 400
    required = ['device_type', 'brand', 'model', 'custom_name']
    for key in required:
        if key not in data:
            return jsonify({'error': f'Missing {key}'}), 400

    user_id = _get_user_from_token()

    conn = get_db()
    conn.execute(
        '''INSERT INTO devices (user_id, device_type, brand, model, custom_name, purchase_date, warranty_expiry)
           VALUES (?, ?, ?, ?, ?, ?, ?)''',
        (
            user_id,
            data['device_type'],
            data['brand'],
            data['model'],
            data['custom_name'],
            data.get('purchase_date'),
            data.get('warranty_expiry'),
        )
    )
    conn.commit()
    conn.close()
    return jsonify({'success': True})


@app.route('/devices', methods=['GET'])
def get_devices():
    user_id = _get_user_from_token()

    conn = get_db()
    if user_id:
        cursor = conn.execute(
            'SELECT id, device_type, brand, model, custom_name, purchase_date, warranty_expiry, status FROM devices WHERE user_id = ?',
            (user_id,)
        )
    else:
        cursor = conn.execute(
            'SELECT id, device_type, brand, model, custom_name, purchase_date, warranty_expiry, status FROM devices WHERE user_id IS NULL'
        )
    rows = cursor.fetchall()
    conn.close()
    devices = [dict(row) for row in rows]
    return jsonify(devices)


@app.route('/device_issues', methods=['GET'])
def get_device_issues():
    device_type = request.args.get('device_type')
    if not device_type:
        return jsonify({'error': 'Missing device_type'}), 400

    conn = get_db()
    cursor = conn.execute(
        'SELECT id, device_type, issue_name, possible_causes, solutions, warnings FROM issues WHERE device_type = ?',
        (device_type,)
    )
    rows = cursor.fetchall()
    conn.close()
    issues = [dict(row) for row in rows]
    return jsonify(issues)


@app.route('/predict_fault', methods=['POST'])
def predict_fault():
    data = request.get_json()
    if not data:
        return jsonify({'error': 'No data'}), 400

    device_type = data.get('device_type', '').strip()
    symptom_1 = data.get('symptom_1', '').strip() or 'لا يوجد'
    symptom_2 = data.get('symptom_2', '').strip() or 'لا يوجد'
    symptom_3 = data.get('symptom_3', '').strip() or 'لا يوجد'

    if not device_type:
        return jsonify({'error': 'Missing device_type'}), 400

    model_data = load_model()
    if not model_data:
        return jsonify({'error': 'Model not loaded. Run train_model.py first.'}), 503

    try:
        encoders = model_data['encoders']
        model = model_data['model']

        device_encoded = encoders['device_type'].transform([device_type])[0]
        s1_encoded = encoders['symptom_1'].transform([symptom_1])[0]
        s2_encoded = encoders['symptom_2'].transform([symptom_2])[0]
        s3_encoded = encoders['symptom_3'].transform([symptom_3])[0]

        X = np.array([[device_encoded, s1_encoded, s2_encoded, s3_encoded]], dtype=np.int64)
        pred_encoded = model.predict(X)[0]
        predicted_fault = encoders['fault_label'].inverse_transform([pred_encoded])[0]

        details = get_fault_details(predicted_fault)

        return jsonify({
            'predicted_fault': predicted_fault,
            'possible_causes': details['causes'],
            'solutions': details['solutions'],
            'warnings': details['warnings'],
            'call_technician': 'إذا لم تنجح الخطوات السابقة أو كان العطل كهربائياً داخلياً يجب الاتصال بفني مختص.',
        })
    except (ValueError, KeyError):
        details = get_fault_details('')
        return jsonify({
            'predicted_fault': 'يحتاج فحص من فني مختص',
            'possible_causes': details['causes'],
            'solutions': details['solutions'],
            'warnings': details['warnings'],
            'call_technician': 'يُنصح بالاتصال بفني مختص لفحص الجهاز وتشخيص العطل بشكل دقيق.',
        })


@app.route('/issue_details', methods=['GET'])
def get_issue_details():
    issue_id = request.args.get('id')
    if not issue_id:
        return jsonify({'error': 'Missing id'}), 400

    conn = get_db()
    cursor = conn.execute(
        'SELECT id, device_type, issue_name, possible_causes, solutions, warnings FROM issues WHERE id = ?',
        (int(issue_id),)
    )
    row = cursor.fetchone()
    conn.close()
    if not row:
        return jsonify({'error': 'Not found'}), 404
    return jsonify(dict(row))


@app.route('/', defaults={'path': ''}, methods=['GET', 'HEAD'])
@app.route('/<path:path>', methods=['GET', 'HEAD'])
def serve_frontend(path):
    """واجهة Flutter Web من مجلد web/ (نفس الرابط الذي يخدم الـ API)."""
    index_html = os.path.join(WEB_ROOT, 'index.html')
    if not os.path.isfile(index_html):
        return jsonify({
            'error': 'Web UI not built',
            'hint': 'Run from repo root: flutter build web --dart-define=FIXMATE_SAME_ORIGIN=true, then copy build/web/* to backend/web/',
        }), 503
    if path:
        try:
            candidate = safe_join(WEB_ROOT, path)
            if candidate is not None and os.path.isfile(candidate):
                return send_from_directory(WEB_ROOT, path)
        except (TypeError, ValueError, OSError):
            pass
    return send_from_directory(WEB_ROOT, 'index.html')


init_db()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
