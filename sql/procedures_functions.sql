-- ====================================================================
-- STORED PROCEDURES AND FUNCTIONS FOR FOOD DELIVERY SYSTEM
-- ====================================================================

-- Note: SQLite doesn't support stored procedures/functions directly
-- These are implemented in the application layer (backend/app.py)
-- This file documents the business logic that would be stored procedures in MySQL/PostgreSQL

-- ====================================================================
-- PROCEDURE 1: Calculate Restaurant Revenue
-- ====================================================================
-- Purpose: Calculate total revenue for a restaurant within a date range
-- Parameters: restaurant_id, start_date, end_date
-- Returns: Total revenue, order count, average order value

-- SQL Implementation:
SELECT 
    r.id,
    r.name,
    COUNT(o.id) as total_orders,
    SUM(o.total_price) as total_revenue,
    AVG(o.total_price) as avg_order_value,
    MIN(o.total_price) as min_order,
    MAX(o.total_price) as max_order
FROM restaurants r
LEFT JOIN orders o ON r.id = o.restaurant_id
WHERE o.created_at BETWEEN :start_date AND :end_date
GROUP BY r.id, r.name;


-- ====================================================================
-- PROCEDURE 2: Get Top Selling Items
-- ====================================================================
-- Purpose: Find most popular menu items across all restaurants
-- Parameters: limit (default 10)
-- Returns: Item details with total quantity sold

-- SQL Implementation:
SELECT 
    mi.id,
    mi.name,
    mi.restaurant_id,
    r.name as restaurant_name,
    mi.price,
    SUM(oi.quantity) as total_sold,
    COUNT(DISTINCT oi.order_id) as order_count,
    SUM(oi.price * oi.quantity) as total_revenue
FROM menu_items mi
JOIN order_items oi ON mi.id = oi.item_id
JOIN restaurants r ON mi.restaurant_id = r.id
GROUP BY mi.id, mi.name, mi.restaurant_id, r.name, mi.price
ORDER BY total_sold DESC
LIMIT :limit;


-- ====================================================================
-- PROCEDURE 3: Update Order Status
-- ====================================================================
-- Purpose: Update order status and log the change (triggers will handle logging)
-- Parameters: order_id, new_status
-- Validates: Status must be valid (pending, confirmed, delivered, cancelled)

-- SQL Implementation:
UPDATE orders 
SET status = :new_status 
WHERE id = :order_id 
AND :new_status IN ('pending', 'confirmed', 'delivered', 'cancelled');


-- ====================================================================
-- PROCEDURE 4: Get Customer Order History with Details
-- ====================================================================
-- Purpose: Retrieve complete order history for a customer with all items
-- Parameters: user_id
-- Returns: All orders with restaurant, items, and status

-- SQL Implementation:
SELECT 
    o.id as order_id,
    o.created_at,
    o.status,
    o.total_price,
    r.name as restaurant_name,
    r.cuisine_type,
    u.name as customer_name,
    u.email,
    json_group_array(
        json_object(
            'item_name', mi.name,
            'quantity', oi.quantity,
            'price', oi.price,
            'subtotal', oi.price * oi.quantity
        )
    ) as items
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN restaurants r ON o.restaurant_id = r.id
JOIN order_items oi ON o.id = oi.order_id
JOIN menu_items mi ON oi.item_id = mi.id
WHERE u.id = :user_id
GROUP BY o.id
ORDER BY o.created_at DESC;


-- ====================================================================
-- FUNCTION 1: Calculate User Lifetime Value
-- ====================================================================
-- Purpose: Calculate total spending by a customer
-- Parameters: user_id
-- Returns: Total amount spent

-- SQL Implementation:
SELECT 
    u.id,
    u.name,
    u.email,
    COUNT(o.id) as total_orders,
    COALESCE(SUM(o.total_price), 0) as lifetime_value,
    COALESCE(AVG(o.total_price), 0) as avg_order_value
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.id = :user_id
GROUP BY u.id, u.name, u.email;


-- ====================================================================
-- FUNCTION 2: Get Available Menu Items
-- ====================================================================
-- Purpose: Get all available menu items for a restaurant
-- Parameters: restaurant_id
-- Returns: Only items marked as available

-- SQL Implementation:
SELECT * FROM menu_items 
WHERE restaurant_id = :restaurant_id 
AND available = 1
ORDER BY category, price;


-- ====================================================================
-- FUNCTION 3: Calculate Order Item Count
-- ====================================================================
-- Purpose: Get total number of items in an order
-- Parameters: order_id
-- Returns: Sum of all quantities

-- SQL Implementation:
SELECT SUM(quantity) as item_count
FROM order_items
WHERE order_id = :order_id;


-- ====================================================================
-- FUNCTION 4: Check Restaurant Availability
-- ====================================================================
-- Purpose: Verify if restaurant has available menu items
-- Parameters: restaurant_id
-- Returns: Boolean (has available items or not)

-- SQL Implementation:
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN 1 
        ELSE 0 
    END as has_available_items
FROM menu_items
WHERE restaurant_id = :restaurant_id 
AND available = 1;


-- ====================================================================
-- COMPLEX QUERY 1: Restaurant Performance Dashboard
-- ====================================================================
-- Purpose: Analytics dashboard showing restaurant metrics

SELECT 
    r.id,
    r.name,
    r.cuisine_type,
    r.order_count,
    COUNT(DISTINCT o.id) as completed_orders,
    COUNT(DISTINCT o.user_id) as unique_customers,
    COUNT(DISTINCT mi.id) as menu_item_count,
    COALESCE(SUM(o.total_price), 0) as total_revenue,
    COALESCE(AVG(o.total_price), 0) as avg_order_value,
    (SELECT COUNT(*) FROM orders WHERE restaurant_id = r.id AND status = 'cancelled') as cancelled_orders,
    (SELECT COUNT(*) FROM orders WHERE restaurant_id = r.id AND status = 'delivered') as delivered_orders
FROM restaurants r
LEFT JOIN orders o ON r.id = o.restaurant_id
LEFT JOIN menu_items mi ON r.id = mi.restaurant_id
GROUP BY r.id, r.name, r.cuisine_type, r.order_count
ORDER BY total_revenue DESC;


-- ====================================================================
-- COMPLEX QUERY 2: Daily Sales Report
-- ====================================================================
-- Purpose: Generate daily sales summary with comparisons

SELECT 
    DATE(o.created_at) as order_date,
    COUNT(o.id) as total_orders,
    COUNT(DISTINCT o.user_id) as unique_customers,
    COUNT(DISTINCT o.restaurant_id) as restaurants_with_orders,
    SUM(o.total_price) as daily_revenue,
    AVG(o.total_price) as avg_order_value,
    SUM(CASE WHEN o.status = 'delivered' THEN 1 ELSE 0 END) as delivered_count,
    SUM(CASE WHEN o.status = 'cancelled' THEN 1 ELSE 0 END) as cancelled_count
FROM orders o
WHERE o.created_at >= DATE('now', '-30 days')
GROUP BY DATE(o.created_at)
ORDER BY order_date DESC;


-- ====================================================================
-- COMPLEX QUERY 3: Customer Segmentation Analysis
-- ====================================================================
-- Purpose: Segment customers by spending behavior

SELECT 
    CASE 
        WHEN total_spent >= 100 THEN 'High Value'
        WHEN total_spent >= 50 THEN 'Medium Value'
        ELSE 'Low Value'
    END as customer_segment,
    COUNT(*) as customer_count,
    AVG(total_spent) as avg_spending,
    AVG(order_count) as avg_orders,
    SUM(total_spent) as segment_revenue
FROM (
    SELECT 
        u.id,
        u.name,
        COUNT(o.id) as order_count,
        COALESCE(SUM(o.total_price), 0) as total_spent
    FROM users u
    LEFT JOIN orders o ON u.id = o.user_id
    GROUP BY u.id, u.name
) customer_stats
GROUP BY customer_segment
ORDER BY avg_spending DESC;


-- ====================================================================
-- COMPLEX QUERY 4: Menu Item Performance with Recommendations
-- ====================================================================
-- Purpose: Analyze which items perform well together (market basket analysis)

SELECT 
    mi1.name as item1,
    mi2.name as item2,
    COUNT(*) as times_ordered_together,
    SUM(oi1.quantity + oi2.quantity) as total_quantity,
    AVG(o.total_price) as avg_order_value
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.item_id < oi2.item_id
JOIN menu_items mi1 ON oi1.item_id = mi1.id
JOIN menu_items mi2 ON oi2.item_id = mi2.id
JOIN orders o ON oi1.order_id = o.id
GROUP BY mi1.name, mi2.name
HAVING times_ordered_together >= 2
ORDER BY times_ordered_together DESC
LIMIT 10;
