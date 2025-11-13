from flask import Flask, request, jsonify
from flask_cors import CORS
import sqlite3
from pathlib import Path
from datetime import datetime

app = Flask(__name__)
CORS(app)

# Database path
DB_PATH = Path(__file__).parent / "food.db"

def get_db_connection():
    """Create database connection with foreign keys enabled"""
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    return conn

def dict_from_row(row):
    """Convert sqlite3.Row to dictionary"""
    return dict(zip(row.keys(), row))

@app.route('/api/restaurants', methods=['GET'])
def get_restaurants():
    """Get all restaurants"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM restaurants")
        restaurants = [dict_from_row(row) for row in cursor.fetchall()]
        conn.close()
        return jsonify(restaurants), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/menu/<int:restaurant_id>', methods=['GET'])
def get_menu(restaurant_id):
    """Get menu items for a specific restaurant"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "SELECT * FROM menu_items WHERE restaurant_id = ?",
            (restaurant_id,)
        )
        menu_items = [dict_from_row(row) for row in cursor.fetchall()]
        conn.close()
        
        if not menu_items:
            return jsonify({"error": "Restaurant not found or no menu items"}), 404
        
        return jsonify(menu_items), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/register', methods=['POST'])
def register_user():
    """Register a new user"""
    try:
        data = request.get_json()
        
        # Validate input
        if not data or not all(k in data for k in ['name', 'email', 'phone']):
            return jsonify({"error": "Missing required fields: name, email, phone"}), 400
        
        name = data['name'].strip()
        email = data['email'].strip()
        phone = data['phone'].strip()
        
        if not name or not email or not phone:
            return jsonify({"error": "All fields must be non-empty"}), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Check if email already exists
        cursor.execute("SELECT id FROM users WHERE email = ?", (email,))
        if cursor.fetchone():
            conn.close()
            return jsonify({"error": "Email already registered"}), 409
        
        # Insert new user
        cursor.execute(
            "INSERT INTO users (name, email, phone) VALUES (?, ?, ?)",
            (name, email, phone)
        )
        conn.commit()
        user_id = cursor.lastrowid
        conn.close()
        
        return jsonify({"id": user_id, "name": name, "email": email, "phone": phone}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/orders', methods=['POST'])
def create_order():
    """Create a new order"""
    try:
        data = request.get_json()
        
        # Validate input
        if not data or not all(k in data for k in ['user_id', 'restaurant_id', 'items']):
            return jsonify({"error": "Missing required fields: user_id, restaurant_id, items"}), 400
        
        user_id = data['user_id']
        restaurant_id = data['restaurant_id']
        items = data['items']
        
        if not items or not isinstance(items, list):
            return jsonify({"error": "Items must be a non-empty list"}), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Verify user exists
        cursor.execute("SELECT id FROM users WHERE id = ?", (user_id,))
        if not cursor.fetchone():
            conn.close()
            return jsonify({"error": "User not found"}), 404
        
        # Verify restaurant exists
        cursor.execute("SELECT id FROM restaurants WHERE id = ?", (restaurant_id,))
        if not cursor.fetchone():
            conn.close()
            return jsonify({"error": "Restaurant not found"}), 404
        
        # Calculate total price
        total_price = 0
        item_details = []
        
        for item in items:
            if 'item_id' not in item or 'quantity' not in item:
                conn.close()
                return jsonify({"error": "Each item must have item_id and quantity"}), 400
            
            item_id = item['item_id']
            quantity = item['quantity']
            
            if quantity <= 0:
                conn.close()
                return jsonify({"error": "Quantity must be positive"}), 400
            
            # Get item price
            cursor.execute(
                "SELECT price, name FROM menu_items WHERE id = ? AND restaurant_id = ?",
                (item_id, restaurant_id)
            )
            result = cursor.fetchone()
            
            if not result:
                conn.close()
                return jsonify({"error": f"Menu item {item_id} not found for this restaurant"}), 404
            
            price = result['price']
            name = result['name']
            subtotal = price * quantity
            total_price += subtotal
            item_details.append({"name": name, "quantity": quantity, "price": price, "subtotal": subtotal})
        
        # Create order
        cursor.execute(
            "INSERT INTO orders (user_id, restaurant_id, total_price, status) VALUES (?, ?, ?, ?)",
            (user_id, restaurant_id, total_price, "pending")
        )
        order_id = cursor.lastrowid
        
        # Add order items
        for item in items:
            cursor.execute(
                "SELECT price FROM menu_items WHERE id = ?",
                (item['item_id'],)
            )
            price = cursor.fetchone()['price']
            
            cursor.execute(
                "INSERT INTO order_items (order_id, item_id, quantity, price) VALUES (?, ?, ?, ?)",
                (order_id, item['item_id'], item['quantity'], price)
            )
        
        conn.commit()
        conn.close()
        
        return jsonify({
            "order_id": order_id,
            "total_price": total_price,
            "status": "pending",
            "items": item_details
        }), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/orders/<int:user_id>', methods=['GET'])
def get_user_orders(user_id):
    """Get all orders for a user"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT o.*, r.name as restaurant_name
            FROM orders o
            JOIN restaurants r ON o.restaurant_id = r.id
            WHERE o.user_id = ?
            ORDER BY o.created_at DESC
        """, (user_id,))
        
        orders = [dict_from_row(row) for row in cursor.fetchall()]
        
        # Get items for each order
        for order in orders:
            cursor.execute("""
                SELECT oi.*, mi.name as item_name
                FROM order_items oi
                JOIN menu_items mi ON oi.item_id = mi.id
                WHERE oi.order_id = ?
            """, (order['id'],))
            order['items'] = [dict_from_row(row) for row in cursor.fetchall()]
        
        conn.close()
        return jsonify(orders), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/orders/<int:order_id>/status', methods=['PUT'])
def update_order_status(order_id):
    """Update order status (UPDATE operation)"""
    try:
        data = request.get_json()
        
        if not data or 'status' not in data:
            return jsonify({"error": "Missing required field: status"}), 400
        
        new_status = data['status']
        valid_statuses = ['pending', 'confirmed', 'delivered', 'cancelled']
        
        if new_status not in valid_statuses:
            return jsonify({"error": f"Invalid status. Must be one of: {', '.join(valid_statuses)}"}), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Check if order exists
        cursor.execute("SELECT * FROM orders WHERE id = ?", (order_id,))
        order = cursor.fetchone()
        
        if not order:
            conn.close()
            return jsonify({"error": "Order not found"}), 404
        
        # Update status
        cursor.execute(
            "UPDATE orders SET status = ? WHERE id = ?",
            (new_status, order_id)
        )
        conn.commit()
        
        # Get updated order
        cursor.execute("SELECT * FROM orders WHERE id = ?", (order_id,))
        updated_order = dict_from_row(cursor.fetchone())
        
        conn.close()
        return jsonify(updated_order), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/menu/<int:item_id>', methods=['PUT'])
def update_menu_item(item_id):
    """Update menu item details (UPDATE operation)"""
    try:
        data = request.get_json()
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Check if item exists
        cursor.execute("SELECT * FROM menu_items WHERE id = ?", (item_id,))
        if not cursor.fetchone():
            conn.close()
            return jsonify({"error": "Menu item not found"}), 404
        
        # Build update query dynamically based on provided fields
        update_fields = []
        values = []
        
        allowed_fields = ['name', 'description', 'price', 'category', 'available']
        for field in allowed_fields:
            if field in data:
                update_fields.append(f"{field} = ?")
                values.append(data[field])
        
        if not update_fields:
            conn.close()
            return jsonify({"error": "No valid fields to update"}), 400
        
        values.append(item_id)
        query = f"UPDATE menu_items SET {', '.join(update_fields)} WHERE id = ?"
        
        cursor.execute(query, values)
        conn.commit()
        
        # Get updated item
        cursor.execute("SELECT * FROM menu_items WHERE id = ?", (item_id,))
        updated_item = dict_from_row(cursor.fetchone())
        
        conn.close()
        return jsonify(updated_item), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/menu/<int:item_id>', methods=['DELETE'])
def delete_menu_item(item_id):
    """Delete a menu item (DELETE operation)"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Check if item exists
        cursor.execute("SELECT * FROM menu_items WHERE id = ?", (item_id,))
        item = cursor.fetchone()
        
        if not item:
            conn.close()
            return jsonify({"error": "Menu item not found"}), 404
        
        # Check if item is in any orders
        cursor.execute("SELECT COUNT(*) as count FROM order_items WHERE item_id = ?", (item_id,))
        count = cursor.fetchone()['count']
        
        if count > 0:
            conn.close()
            return jsonify({"error": f"Cannot delete item. It appears in {count} order(s)"}), 409
        
        # Delete item
        cursor.execute("DELETE FROM menu_items WHERE id = ?", (item_id,))
        conn.commit()
        conn.close()
        
        return jsonify({"message": "Menu item deleted successfully", "id": item_id}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/orders/<int:order_id>', methods=['DELETE'])
def cancel_order(order_id):
    """Cancel an order (DELETE operation - soft delete via status)"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Check if order exists
        cursor.execute("SELECT * FROM orders WHERE id = ?", (order_id,))
        order = cursor.fetchone()
        
        if not order:
            conn.close()
            return jsonify({"error": "Order not found"}), 404
        
        # Only allow cancellation of pending orders
        if order['status'] != 'pending':
            conn.close()
            return jsonify({"error": f"Cannot cancel order with status '{order['status']}'"}), 409
        
        # Soft delete: Update status to cancelled
        cursor.execute("UPDATE orders SET status = 'cancelled' WHERE id = ?", (order_id,))
        conn.commit()
        conn.close()
        
        return jsonify({"message": "Order cancelled successfully", "id": order_id}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/analytics/dashboard', methods=['GET'])
def get_dashboard_analytics():
    """Get comprehensive analytics dashboard data"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Restaurant performance
        cursor.execute("""
            SELECT 
                r.id,
                r.name,
                r.cuisine_type,
                r.order_count,
                COUNT(DISTINCT o.id) as completed_orders,
                COUNT(DISTINCT o.user_id) as unique_customers,
                COALESCE(SUM(o.total_price), 0) as total_revenue,
                COALESCE(AVG(o.total_price), 0) as avg_order_value
            FROM restaurants r
            LEFT JOIN orders o ON r.id = o.restaurant_id
            GROUP BY r.id, r.name, r.cuisine_type, r.order_count
            ORDER BY total_revenue DESC
        """)
        restaurants = [dict_from_row(row) for row in cursor.fetchall()]
        
        # Top selling items
        cursor.execute("""
            SELECT 
                mi.id,
                mi.name,
                r.name as restaurant_name,
                SUM(oi.quantity) as total_sold,
                SUM(oi.price * oi.quantity) as total_revenue
            FROM menu_items mi
            JOIN order_items oi ON mi.id = oi.item_id
            JOIN restaurants r ON mi.restaurant_id = r.id
            GROUP BY mi.id, mi.name, r.name
            ORDER BY total_sold DESC
            LIMIT 10
        """)
        top_items = [dict_from_row(row) for row in cursor.fetchall()]
        
        # Customer lifetime value
        cursor.execute("""
            SELECT 
                u.id,
                u.name,
                u.email,
                COUNT(o.id) as total_orders,
                COALESCE(SUM(o.total_price), 0) as lifetime_value
            FROM users u
            LEFT JOIN orders o ON u.id = o.user_id
            GROUP BY u.id, u.name, u.email
            ORDER BY lifetime_value DESC
            LIMIT 10
        """)
        top_customers = [dict_from_row(row) for row in cursor.fetchall()]
        
        conn.close()
        
        return jsonify({
            "restaurants": restaurants,
            "top_items": top_items,
            "top_customers": top_customers
        }), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)
