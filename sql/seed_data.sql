-- Insert users (with passwords - in real app these would be hashed!)
INSERT INTO users (name, email, phone) VALUES
('Alice Johnson', 'alice@example.com', '555-0101'),
('Bob Smith', 'bob@example.com', '555-0102'),
('Charlie Davis', 'charlie@example.com', '555-0103'),
('Diana Miller', 'diana@example.com', '555-0104'),
('Eve Wilson', 'eve@example.com', '555-0105'),
('Frank Brown', 'frank@example.com', '555-0106');

-- Insert restaurants
INSERT INTO restaurants (name, address, phone, cuisine_type) VALUES
('Pizza Palace', '123 Main St', '555-1000', 'Italian'),
('Burger Barn', '456 Oak Ave', '555-2000', 'American'),
('Sushi Supreme', '789 Cherry Blvd', '555-3000', 'Japanese'),
('Taco Fiesta', '321 Pine Rd', '555-4000', 'Mexican'),
('Thai Paradise', '654 Maple Dr', '555-5000', 'Thai'),
('Dragon Wok', '987 Elm St', '555-6000', 'Chinese');

-- Insert menu items for Pizza Palace (restaurant_id = 1)
INSERT INTO menu_items (restaurant_id, name, description, price, category) VALUES
(1, 'Margherita Pizza', 'Classic tomato and mozzarella', 12.99, 'Pizza'),
(1, 'Pepperoni Pizza', 'Loaded with pepperoni', 14.99, 'Pizza'),
(1, 'BBQ Chicken Pizza', 'BBQ sauce, chicken, red onions', 15.99, 'Pizza'),
(1, 'Veggie Supreme Pizza', 'Bell peppers, mushrooms, olives', 13.99, 'Pizza'),
(1, 'Caesar Salad', 'Fresh romaine with Caesar dressing', 8.99, 'Salad'),
(1, 'Garlic Bread', 'Toasted with garlic butter', 4.99, 'Appetizer'),
(1, 'Tiramisu', 'Classic Italian dessert', 6.99, 'Dessert'),
(1, 'Lasagna', 'Layered pasta with meat sauce', 13.99, 'Pasta');

-- Insert menu items for Burger Barn (restaurant_id = 2)
INSERT INTO menu_items (restaurant_id, name, description, price, category) VALUES
(2, 'Classic Burger', 'Beef patty with lettuce and tomato', 10.99, 'Burger'),
(2, 'Cheeseburger', 'Classic burger with cheddar cheese', 11.99, 'Burger'),
(2, 'Double Bacon Burger', 'Two patties with crispy bacon', 14.99, 'Burger'),
(2, 'Veggie Burger', 'Plant-based patty with avocado', 11.99, 'Burger'),
(2, 'French Fries', 'Crispy golden fries', 3.99, 'Side'),
(2, 'Onion Rings', 'Beer-battered onion rings', 4.99, 'Side'),
(2, 'Milkshake', 'Chocolate, vanilla, or strawberry', 5.99, 'Beverage'),
(2, 'Chicken Wings', '8 pieces with choice of sauce', 9.99, 'Appetizer');

-- Insert menu items for Sushi Supreme (restaurant_id = 3)
INSERT INTO menu_items (restaurant_id, name, description, price, category) VALUES
(3, 'California Roll', 'Crab, avocado, cucumber', 8.99, 'Roll'),
(3, 'Spicy Tuna Roll', 'Fresh tuna with spicy mayo', 10.99, 'Roll'),
(3, 'Dragon Roll', 'Shrimp tempura, eel, avocado', 14.99, 'Roll'),
(3, 'Salmon Nigiri', '2 pieces fresh salmon', 6.99, 'Nigiri'),
(3, 'Tuna Sashimi', '5 pieces premium tuna', 12.99, 'Sashimi'),
(3, 'Miso Soup', 'Traditional Japanese soup', 3.99, 'Soup'),
(3, 'Edamame', 'Steamed soybeans with sea salt', 4.99, 'Appetizer'),
(3, 'Green Tea Ice Cream', 'Authentic matcha flavor', 5.99, 'Dessert');

-- Insert menu items for Taco Fiesta (restaurant_id = 4)
INSERT INTO menu_items (restaurant_id, name, description, price, category) VALUES
(4, 'Beef Tacos', '3 tacos with seasoned beef', 9.99, 'Tacos'),
(4, 'Chicken Tacos', '3 tacos with grilled chicken', 9.99, 'Tacos'),
(4, 'Fish Tacos', '3 tacos with battered fish', 11.99, 'Tacos'),
(4, 'Burrito Bowl', 'Rice, beans, meat, veggies', 10.99, 'Bowl'),
(4, 'Quesadilla', 'Cheese and choice of meat', 8.99, 'Main'),
(4, 'Nachos Supreme', 'Loaded with cheese and toppings', 9.99, 'Appetizer'),
(4, 'Guacamole & Chips', 'Fresh made guacamole', 6.99, 'Appetizer'),
(4, 'Churros', 'Fried dough with cinnamon sugar', 5.99, 'Dessert');

-- Insert menu items for Thai Paradise (restaurant_id = 5)
INSERT INTO menu_items (restaurant_id, name, description, price, category) VALUES
(5, 'Pad Thai', 'Stir-fried noodles with shrimp', 12.99, 'Noodles'),
(5, 'Green Curry', 'Spicy curry with coconut milk', 13.99, 'Curry'),
(5, 'Tom Yum Soup', 'Hot and sour soup with shrimp', 8.99, 'Soup'),
(5, 'Massaman Curry', 'Mild curry with peanuts', 13.99, 'Curry'),
(5, 'Spring Rolls', 'Fresh vegetables wrapped in rice paper', 6.99, 'Appetizer'),
(5, 'Fried Rice', 'Thai-style fried rice', 10.99, 'Rice'),
(5, 'Mango Sticky Rice', 'Sweet coconut rice with mango', 6.99, 'Dessert'),
(5, 'Thai Iced Tea', 'Sweet and creamy tea', 4.99, 'Beverage');

-- Insert menu items for Dragon Wok (restaurant_id = 6)
INSERT INTO menu_items (restaurant_id, name, description, price, category) VALUES
(6, 'Kung Pao Chicken', 'Spicy chicken with peanuts', 12.99, 'Main'),
(6, 'Sweet and Sour Pork', 'Crispy pork in tangy sauce', 11.99, 'Main'),
(6, 'Beef with Broccoli', 'Tender beef in brown sauce', 13.99, 'Main'),
(6, 'Fried Dumplings', '6 pieces pan-fried', 7.99, 'Appetizer'),
(6, 'Egg Drop Soup', 'Classic Chinese soup', 3.99, 'Soup'),
(6, 'Lo Mein', 'Soft noodles with vegetables', 10.99, 'Noodles'),
(6, 'General Tso Chicken', 'Crispy chicken in spicy sauce', 13.99, 'Main'),
(6, 'Fortune Cookies', '3 cookies', 1.99, 'Dessert');

-- Insert sample orders with various statuses
INSERT INTO orders (user_id, restaurant_id, total_price, status) VALUES
(1, 1, 27.98, 'delivered'),
(2, 2, 26.97, 'delivered'),
(3, 3, 25.97, 'delivered'),
(1, 4, 20.98, 'confirmed'),
(4, 5, 26.98, 'pending'),
(5, 6, 25.98, 'pending'),
(2, 1, 18.98, 'delivered'),
(6, 3, 31.96, 'confirmed'),
(3, 2, 16.98, 'delivered'),
(4, 4, 15.98, 'cancelled');

-- Insert order items for the orders above
INSERT INTO order_items (order_id, item_id, quantity, price) VALUES
-- Order 1: Alice from Pizza Palace
(1, 1, 1, 12.99),
(1, 2, 1, 14.99),
-- Order 2: Bob from Burger Barn
(2, 9, 2, 10.99),
(2, 13, 1, 3.99),
-- Order 3: Charlie from Sushi Supreme
(3, 17, 1, 8.99),
(3, 18, 1, 10.99),
(3, 22, 1, 3.99),
-- Order 4: Alice from Taco Fiesta
(4, 25, 2, 9.99),
-- Order 5: Diana from Thai Paradise
(5, 33, 1, 12.99),
(5, 34, 1, 13.99),
-- Order 6: Eve from Dragon Wok
(6, 41, 1, 12.99),
(6, 42, 1, 11.99),
-- Order 7: Bob from Pizza Palace
(7, 5, 2, 8.99),
-- Order 8: Frank from Sushi Supreme
(8, 19, 2, 14.99),
-- Order 9: Charlie from Burger Barn
(9, 10, 1, 11.99),
(9, 13, 1, 3.99),
-- Order 10: Diana from Taco Fiesta
(10, 26, 1, 9.99),
(10, 31, 1, 5.99);
