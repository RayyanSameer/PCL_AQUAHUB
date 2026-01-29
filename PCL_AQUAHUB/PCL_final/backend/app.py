"""
AquaHub Registration Backend
Flask application to handle customer and vendor registration
"""

from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
import psycopg2
from psycopg2.extras import RealDictCursor
import bcrypt
import uuid
from datetime import datetime
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = Flask(__name__)
CORS(app)

# Database configuration
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'database': os.getenv('DB_NAME', 'aquahub_db'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', 'your_password'),
    'port': os.getenv('DB_PORT', '5432')
}

def get_db_connection():
    """Create database connection"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except psycopg2.Error as e:
        print(f"Database connection error: {e}")
        return None

def hash_password(password):
    """Hash password using bcrypt"""
    salt = bcrypt.gensalt()
    return bcrypt.hashpw(password.encode('utf-8'), salt).decode('utf-8')

def verify_password(password, hashed):
    """Verify password against hash"""
    return bcrypt.checkpw(password.encode('utf-8'), hashed.encode('utf-8'))

@app.route('/')
def index():
    """Serve the main page"""
    return render_template('index.html')

@app.route('/api/register/customer', methods=['POST'])
def register_customer():
    """Handle customer registration"""
    try:
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['email', 'password', 'firstName', 'lastName', 'phone', 'address', 'city', 'state', 'postalCode']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({'error': f'Missing required field: {field}'}), 400
        
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        
        cur = conn.cursor(cursor_factory=RealDictCursor)
        
        # Check if email already exists
        cur.execute("SELECT id FROM users WHERE email = %s", (data['email'],))
        if cur.fetchone():
            return jsonify({'error': 'Email already registered'}), 400
        
        # Hash password
        password_hash = hash_password(data['password'])
        
        # Insert user
        user_id = str(uuid.uuid4())
        cur.execute("""
            INSERT INTO users (id, email, password_hash, user_type)
            VALUES (%s, %s, %s, 'customer')
        """, (user_id, data['email'], password_hash))
        
        # Insert customer profile
        cur.execute("""
            INSERT INTO customer_profiles 
            (user_id, first_name, last_name, phone, date_of_birth, gender,
             address_line1, address_line2, city, state, postal_code, country,
             emergency_contact_name, emergency_contact_phone)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            user_id, data['firstName'], data['lastName'], data['phone'],
            data.get('dateOfBirth'), data.get('gender'),
            data['address'], data.get('address2', ''), data['city'], 
            data['state'], data['postalCode'], data.get('country', 'India'),
            data.get('emergencyContactName', ''), data.get('emergencyContactPhone', '')
        ))
        
        # Insert water requirements if provided
        if 'waterRequirements' in data:
            reqs = data['waterRequirements']
            cur.execute("""
                INSERT INTO customer_water_requirements
                (customer_id, required_quantity, frequency, preferred_delivery_days,
                 preferred_time_slots, water_type, storage_capacity, special_instructions)
                VALUES (
                    (SELECT id FROM customer_profiles WHERE user_id = %s),
                    %s, %s, %s, %s, %s, %s, %s
                )
            """, (
                user_id, reqs.get('quantity', 5000), reqs.get('frequency', 'weekly'),
                reqs.get('preferredDays', []), reqs.get('preferredTimeSlots', []),
                reqs.get('waterType', 'potable'), reqs.get('storageCapacity'),
                reqs.get('specialInstructions', '')
            ))
        
        conn.commit()
        cur.close()
        conn.close()
        
        return jsonify({
            'message': 'Customer registered successfully',
            'userId': user_id
        }), 201
        
    except Exception as e:
        print(f"Registration error: {e}")
        return jsonify({'error': 'Registration failed'}), 500

@app.route('/api/register/vendor', methods=['POST'])
def register_vendor():
    """Handle vendor registration"""
    try:
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['email', 'password', 'businessName', 'contactPersonName', 'phone', 'businessAddress', 'city', 'state', 'postalCode']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({'error': f'Missing required field: {field}'}), 400
        
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        
        cur = conn.cursor(cursor_factory=RealDictCursor)
        
        # Check if email already exists
        cur.execute("SELECT id FROM users WHERE email = %s", (data['email'],))
        if cur.fetchone():
            return jsonify({'error': 'Email already registered'}), 400
        
        # Hash password
        password_hash = hash_password(data['password'])
        
        # Insert user
        user_id = str(uuid.uuid4())
        cur.execute("""
            INSERT INTO users (id, email, password_hash, user_type)
            VALUES (%s, %s, %s, 'vendor')
        """, (user_id, data['email'], password_hash))
        
        # Insert vendor profile
        cur.execute("""
            INSERT INTO vendor_profiles 
            (user_id, business_name, contact_person_name, phone, alternate_phone,
             business_address_line1, business_address_line2, city, state, postal_code, country,
             business_type, years_in_business, license_number, tax_id,
             service_areas, tanker_capacity, delivery_radius_km)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            user_id, data['businessName'], data['contactPersonName'], data['phone'],
            data.get('alternatePhone', ''), data['businessAddress'], data.get('businessAddress2', ''),
            data['city'], data['state'], data['postalCode'], data.get('country', 'India'),
            data.get('businessType', ''), data.get('yearsInBusiness'), data.get('licenseNumber', ''),
            data.get('taxId', ''), data.get('serviceAreas', []), data.get('tankerCapacity', []),
            data.get('deliveryRadius', 50)
        ))
        
        # Insert vendor services if provided
        if 'services' in data and data['services']:
            for service in data['services']:
                cur.execute("""
                    INSERT INTO vendor_services
                    (vendor_id, service_name, water_type, tanker_capacity, price_per_liter,
                     minimum_order_quantity, available_days, available_time_slots, coverage_areas)
                    VALUES (
                        (SELECT id FROM vendor_profiles WHERE user_id = %s),
                        %s, %s, %s, %s, %s, %s, %s, %s
                    )
                """, (
                    user_id, service.get('serviceName', ''), service.get('waterType', 'potable'),
                    service.get('tankerCapacity', 5000), service.get('pricePerLiter', 1.50),
                    service.get('minimumOrder', 1000), service.get('availableDays', []),
                    service.get('availableTimeSlots', []), service.get('coverageAreas', [])
                ))
        
        conn.commit()
        cur.close()
        conn.close()
        
        return jsonify({
            'message': 'Vendor registered successfully',
            'userId': user_id
        }), 201
        
    except Exception as e:
        print(f"Registration error: {e}")
        return jsonify({'error': 'Registration failed'}), 500

@app.route('/api/users', methods=['GET'])
def get_users():
    """Get all users (for testing)"""
    try:
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("""
            SELECT u.id, u.email, u.user_type, u.created_at,
                   CASE 
                       WHEN u.user_type = 'customer' THEN cp.first_name || ' ' || cp.last_name
                       WHEN u.user_type = 'vendor' THEN vp.business_name
                   END as name
            FROM users u
            LEFT JOIN customer_profiles cp ON u.id = cp.user_id
            LEFT JOIN vendor_profiles vp ON u.id = vp.user_id
            ORDER BY u.created_at DESC
        """)
        
        users = cur.fetchall()
        cur.close()
        conn.close()
        
        return jsonify({'users': users}), 200
        
    except Exception as e:
        print(f"Error fetching users: {e}")
        return jsonify({'error': 'Failed to fetch users'}), 500

@app.route('/api/health', methods=['GET'])
def health():
    """Health check endpoint that verifies DB connectivity"""
    try:
        conn = get_db_connection()
        if not conn:
            return jsonify({'status': 'fail', 'db': 'disconnected'}), 503
        cur = conn.cursor()
        cur.execute('SELECT 1')
        cur.fetchone()
        cur.close()
        conn.close()
        return jsonify({'status': 'ok', 'db': 'connected'}), 200
    except Exception as e:
        print(f"Health check error: {e}")
        return jsonify({'status': 'fail', 'error': str(e)}), 500

# --- Vendor login and order/fleet management endpoints ---
@app.route('/api/vendor/login', methods=['POST'])
def vendor_login():
    try:
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')
        if not email or not password:
            return jsonify({'error': 'Missing credentials'}), 400

        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT id, email, password_hash FROM users WHERE email = %s AND user_type = 'vendor'", (email,))
        user = cur.fetchone()
        if not user:
            cur.close()
            conn.close()
            return jsonify({'error': 'Invalid credentials'}), 401

        if not verify_password(password, user['password_hash']):
            cur.close()
            conn.close()
            return jsonify({'error': 'Invalid credentials'}), 401

        # fetch vendor profile
        cur.execute("SELECT id, user_id, business_name, contact_person_name, phone FROM vendor_profiles WHERE user_id = %s", (user['id'],))
        vendor = cur.fetchone()
        cur.close()
        conn.close()
        if not vendor:
            return jsonify({'error': 'Vendor profile not found'}), 404

        # do not include password hash
        vendor_response = { 'vendor_profile_id': vendor['id'], 'user_id': vendor['user_id'], 'business_name': vendor['business_name'], 'contact_name': vendor['contact_person_name'], 'phone': vendor['phone'], 'email': user['email'] }
        return jsonify({'vendor': vendor_response}), 200
    except Exception as e:
        print(f"Vendor login error: {e}")
        return jsonify({'error': 'Login failed'}), 500

@app.route('/api/orders/available', methods=['GET'])
def available_orders():
    """List pending unassigned orders with client info"""
    try:
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT o.*, cp.first_name, cp.last_name, cp.phone FROM orders o JOIN customer_profiles cp ON o.client_id = cp.id WHERE o.status = 'pending' ORDER BY o.created_at DESC")
        orders = cur.fetchall()
        cur.close()
        conn.close()
        return jsonify({'orders': orders}), 200
    except Exception as e:
        print(f"Error fetching available orders: {e}")
        return jsonify({'error': 'Failed to fetch orders'}), 500

@app.route('/api/orders/<order_id>/assign', methods=['POST'])
def assign_order(order_id):
    """Assign an order to a vendor and optionally dispatch a truck"""
    try:
        data = request.get_json() or {}
        vendor_profile_id = data.get('vendor_profile_id')
        truck_id = data.get('truck_id')
        if not vendor_profile_id:
            return jsonify({'error': 'vendor_profile_id required'}), 400

        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        cur = conn.cursor(cursor_factory=RealDictCursor)

        # update order
        cur.execute("UPDATE orders SET vendor_id = %s, status = %s WHERE id = %s", (vendor_profile_id, 'accepted', order_id))

        # if truck specified, set truck dispatched
        if truck_id:
            cur.execute("UPDATE vendor_trucks SET is_dispatched = TRUE WHERE id = %s", (truck_id,))

        conn.commit()
        cur.close()
        conn.close()
        return jsonify({'assigned': True}), 200
    except Exception as e:
        print(f"Error assigning order: {e}")
        return jsonify({'error': 'Failed to assign order'}), 500

@app.route('/api/vendor/<vendor_profile_id>/orders', methods=['GET'])
def vendor_orders(vendor_profile_id):
    try:
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT o.*, cp.first_name, cp.last_name, cp.phone FROM orders o JOIN customer_profiles cp ON o.client_id = cp.id WHERE o.vendor_id = %s ORDER BY o.created_at DESC", (vendor_profile_id,))
        orders = cur.fetchall()
        cur.close()
        conn.close()
        return jsonify({'orders': orders}), 200
    except Exception as e:
        print(f"Error fetching vendor orders: {e}")
        return jsonify({'error': 'Failed to fetch vendor orders'}), 500

@app.route('/api/vendor/<vendor_profile_id>/fleet', methods=['GET'])
def vendor_fleet(vendor_profile_id):
    try:
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        cur = conn.cursor(cursor_factory=RealDictCursor)

        # trucks
        cur.execute("SELECT * FROM vendor_trucks WHERE vendor_id = %s ORDER BY created_at DESC", (vendor_profile_id,))
        trucks = cur.fetchall()

        # counts
        cur.execute("SELECT COUNT(*) as truck_count FROM vendor_trucks WHERE vendor_id = %s", (vendor_profile_id,))
        truck_count = cur.fetchone()['truck_count']

        # orders in queue (pending assigned to this vendor or unassigned)
        cur.execute("SELECT COUNT(*) as orders_in_queue FROM orders WHERE (vendor_id = %s OR vendor_id IS NULL) AND status = 'pending'", (vendor_profile_id,))
        orders_queue = cur.fetchone()['orders_in_queue']

        # earnings per truck
        cur.execute("SELECT vt.id, vt.truck_name, vt.capacity_liters, vt.is_dispatched, vt.total_earnings FROM vendor_trucks vt WHERE vt.vendor_id = %s", (vendor_profile_id,))
        trucks_info = cur.fetchall()

        cur.close()
        conn.close()
        return jsonify({'truck_count': truck_count, 'orders_in_queue': orders_queue, 'trucks': trucks_info}), 200
    except Exception as e:
        print(f"Error fetching fleet: {e}")
        return jsonify({'error': 'Failed to fetch fleet data'}), 500

@app.route('/api/vendor/<vendor_profile_id>/trucks', methods=['POST'])
def add_truck(vendor_profile_id):
    try:
        data = request.get_json() or {}
        truck_name = data.get('truck_name')
        capacity = data.get('capacity_liters')
        if not truck_name or not capacity:
            return jsonify({'error': 'truck_name and capacity_liters required'}), 400
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("INSERT INTO vendor_trucks (vendor_id, truck_name, capacity_liters) VALUES (%s, %s, %s) RETURNING id, truck_name, capacity_liters, is_dispatched, total_earnings", (vendor_profile_id, truck_name, capacity))
        new_truck = cur.fetchone()
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({'truck': new_truck}), 201
    except Exception as e:
        print(f"Error adding truck: {e}")
        return jsonify({'error': 'Failed to add truck'}), 500

@app.route('/api/orders/<order_id>', methods=['GET'])
def get_order(order_id):
    try:
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT o.*, cp.first_name, cp.last_name, cp.phone FROM orders o JOIN customer_profiles cp ON o.client_id = cp.id WHERE o.id = %s", (order_id,))
        order = cur.fetchone()
        cur.close()
        conn.close()
        if not order:
            return jsonify({'error': 'Order not found'}), 404
        return jsonify({'order': order}), 200
    except Exception as e:
        print(f"Error fetching order: {e}")
        return jsonify({'error': 'Failed to fetch order'}), 500

@app.route('/api/orders/<order_id>/complete', methods=['POST'])
def complete_order(order_id):
    try:
        data = request.get_json() or {}
        vendor_profile_id = data.get('vendor_profile_id')
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        cur = conn.cursor(cursor_factory=RealDictCursor)
        # fetch order
        cur.execute('SELECT * FROM orders WHERE id = %s', (order_id,))
        order = cur.fetchone()
        if not order:
            cur.close()
            conn.close()
            return jsonify({'error': 'Order not found'}), 404
        now = datetime.utcnow()
        cur.execute("UPDATE orders SET status = %s, delivered_at = %s WHERE id = %s", ('delivered', now, order_id))
        earnings = order.get('vendor_earnings') if order.get('vendor_earnings') is not None else (order.get('price', 0) * 0.8)
        cur.execute("INSERT INTO deliveries (order_id, vendor_id, earnings) VALUES (%s, %s, %s)", (order_id, vendor_profile_id, earnings))
        # update vendor_trucks/total earnings if truck_id was present in order (future enhancement)
        cur.execute("UPDATE vendor_profiles SET /* no-op for now */ user_id = user_id WHERE id = %s", (vendor_profile_id,))
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({'completed': True}), 200
    except Exception as e:
        print(f"Error completing order: {e}")
        return jsonify({'error': 'Failed to complete order'}), 500

@app.route('/api/trucks/<truck_id>', methods=['GET'])
def get_truck(truck_id):
    try:
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute('SELECT id, vendor_id, truck_name, capacity_liters, is_dispatched, total_earnings FROM vendor_trucks WHERE id = %s', (truck_id,))
        truck = cur.fetchone()
        cur.close()
        conn.close()
        if not truck:
            return jsonify({'error': 'Truck not found'}), 404
        return jsonify({'truck': truck}), 200
    except Exception as e:
        print(f"Error fetching truck: {e}")
        return jsonify({'error': 'Failed to fetch truck'}), 500

@app.route('/api/trucks/<truck_id>', methods=['PUT'])
def update_truck(truck_id):
    try:
        data = request.get_json() or {}
        truck_name = data.get('truck_name')
        capacity = data.get('capacity_liters')
        is_dispatched = data.get('is_dispatched')
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("UPDATE vendor_trucks SET truck_name = COALESCE(%s, truck_name), capacity_liters = COALESCE(%s, capacity_liters), is_dispatched = COALESCE(%s, is_dispatched), updated_at = CURRENT_TIMESTAMP WHERE id = %s RETURNING id, truck_name, capacity_liters, is_dispatched, total_earnings", (truck_name, capacity, is_dispatched, truck_id))
        updated = cur.fetchone()
        conn.commit()
        cur.close()
        conn.close()
        if not updated:
            return jsonify({'error': 'Truck not found'}), 404
        return jsonify({'truck': updated}), 200
    except Exception as e:
        print(f"Error updating truck: {e}")
        return jsonify({'error': 'Failed to update truck'}), 500

@app.route('/api/trucks/<truck_id>', methods=['DELETE'])
def delete_truck(truck_id):
    try:
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        cur = conn.cursor()
        cur.execute('DELETE FROM vendor_trucks WHERE id = %s', (truck_id,))
        changes = cur.rowcount
        conn.commit()
        cur.close()
        conn.close()
        if changes == 0:
            return jsonify({'error': 'Truck not found'}), 404
        return jsonify({'deleted': True}), 200
    except Exception as e:
        print(f"Error deleting truck: {e}")
        return jsonify({'error': 'Failed to delete truck'}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
