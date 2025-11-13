# User Requirement Specification

## 1. Purpose
This document outlines the functional and non-functional requirements for the Food Delivery Mini-Project, an academic prototype demonstrating a complete web application for online food ordering.

## 2. Scope
The system allows users to:
- Browse available restaurants
- View restaurant menus with prices
- Add items to a shopping cart
- Place orders
- Track order history

## 3. Functional Requirements

### FR1: Restaurant Browsing
- **FR1.1:** System shall display a list of all available restaurants
- **FR1.2:** Each restaurant shall show name, cuisine type, address, and contact information
- **FR1.3:** Users can select a restaurant to view its menu

### FR2: Menu Viewing
- **FR2.1:** System shall display menu items for selected restaurant
- **FR2.2:** Each menu item shall show name, description, price, and category
- **FR2.3:** Users can add items to cart with quantity selection

### FR3: Shopping Cart
- **FR3.1:** System shall maintain a shopping cart session
- **FR3.2:** Users can adjust item quantities in cart
- **FR3.3:** Users can remove items from cart
- **FR3.4:** Cart shall display real-time total price

### FR4: Order Placement
- **FR4.1:** System shall validate order data before submission
- **FR4.2:** System shall calculate correct total price
- **FR4.3:** System shall generate unique order ID
- **FR4.4:** System shall confirm successful order placement

### FR5: User Registration (API)
- **FR5.1:** System shall accept user registration with name, email, phone
- **FR5.2:** System shall validate email uniqueness
- **FR5.3:** System shall return user ID upon successful registration

### FR6: Order History
- **FR6.1:** System shall retrieve all orders for a specific user
- **FR6.2:** Each order shall include restaurant name, items, quantities, and total price

## 4. Non-Functional Requirements

### NFR1: Performance
- API responses shall return within 2 seconds under normal load

### NFR2: Data Integrity
- Database shall enforce foreign key constraints
- All prices shall be positive values
- Order quantities shall be positive integers

### NFR3: Security (Basic)
- API shall validate all input data
- API shall return appropriate HTTP status codes
- Database shall reject invalid data types

### NFR4: Usability
- Frontend shall provide clear visual feedback for user actions
- Error messages shall be descriptive and actionable

### FR7: Order Management (UPDATE)
- **FR7.1:** System shall allow updating order status
- **FR7.2:** Valid statuses: pending, confirmed, delivered, cancelled
- **FR7.3:** Status changes shall be logged for audit trail

### FR8: Menu Management (UPDATE/DELETE)
- **FR8.1:** System shall allow updating menu item details
- **FR8.2:** System shall allow deleting unused menu items
- **FR8.3:** System shall prevent deletion of items in existing orders

### FR9: Analytics & Reporting
- **FR9.1:** System shall provide restaurant performance metrics
- **FR9.2:** System shall identify top-selling items
- **FR9.3:** System shall calculate customer lifetime value
- **FR9.4:** System shall generate comprehensive dashboard

## 5. Implementation Mapping

| Requirement | Implementation |
|-------------|----------------|
| FR1 | `GET /api/restaurants` endpoint + Restaurant listing UI |
| FR2 | `GET /api/menu/<id>` endpoint + Menu display UI |
| FR3 | React state management in `App.js` |
| FR4 | `POST /api/orders` endpoint + Checkout UI |
| FR5 | `POST /api/register` endpoint |
| FR6 | `GET /api/orders/<user_id>` endpoint |
| FR7 | `PUT /api/orders/<id>/status` endpoint |
| FR8 | `PUT /api/menu/<id>`, `DELETE /api/menu/<id>` endpoints |
| FR9 | `GET /api/analytics/dashboard` endpoint |
| NFR2 | SQL CHECK constraints + 4 triggers |
| NFR3 | Flask input validation + error handling |

## 6. Out of Scope (Future Enhancements)
- User authentication and sessions
- Payment processing
- Real-time order tracking
- Restaurant admin panel
- Delivery driver management
- Mobile responsive design optimization
