# Food Delivery App - DBMS Mini Project

A complete full-stack food delivery application with React frontend, Flask backend, and SQLite database. Built for DBMS course demonstrations with comprehensive trigger implementation, CRUD operations, and complex queries.

## Features

- **5 Normalized Tables** (3NF) with proper foreign key relationships
- **4 Working Triggers** (auto-increment, deletion protection, total calculation, audit logging)
- **10 REST API Endpoints** for full CRUD operations
- **4 Complex Queries** with multi-table JOINs and aggregations
- **Modern React UI** with purple gradient theme and animations
- **Live Demo Pages** with interactive buttons for Review 2 and Review 4
- **Complete Documentation** with ER diagrams and feature reports
- **Auto-Launcher** to start all services with one click

## Quick Start (ONE CLICK!)

### Prerequisites
- Python 3.x
- Node.js and npm
- Git (optional)

### Fastest Way to Run

Simply double-click:
```
START_PROJECT.bat
```

This will automatically:
- Initialize the SQLite database
- Start the Flask backend (port 5000)
- Start the React frontend (port 3001)
- Open both demo pages in your browser
- Launch the main application

**That's it! Everything runs automatically.**

## Manual Setup

If you prefer to run services individually:

### 1. Initialize Database
```powershell
cd backend
python init_db.py
```

### 2. Start Backend
```powershell
cd backend
python app.py
```
Backend runs on: http://localhost:5000

### 3. Start Frontend
```powershell
cd frontend
npm install  # First time only
npm start
```
Frontend runs on: http://localhost:3001

### 4. Open Demos
- **Review 2:** Double-click `REVIEW_2_DEMO.html` (works offline)
- **Review 4:** Double-click `REVIEW_4_DEMO.html` (requires backend)

## Project Structure

```
DBMS miniproject/
├── backend/
│   ├── app.py              # Flask REST API (10 endpoints)
│   ├── init_db.py          # Database initialization
│   ├── requirements.txt    # Python dependencies
│   └── food.db             # SQLite database (generated)
├── frontend/
│   ├── src/
│   │   ├── App.js          # Main React component
│   │   ├── index.js        # Entry point
│   │   └── index.css       # Styles (purple gradient theme)
│   ├── public/
│   │   └── index.html      # HTML template
│   └── package.json        # Node dependencies
├── sql/
│   ├── schema.sql          # 5 tables + 4 triggers
│   ├── seed_data.sql       # Sample data (6 restaurants, 64 items)
│   └── procedures_functions.sql  # Procedures, functions, queries
├── docs/
│   ├── ER_Diagram.md       # Entity-Relationship diagram
│   ├── User_Requirement_Spec.md  # Requirements
│   └── Deliverables_Checklist.md # Project checklist
├── REVIEW_2_DEMO.html      # Database design demo
├── REVIEW_4_DEMO.html      # Live functionality demo
├── START_PROJECT.bat       # Auto-launcher (RECOMMENDED)
├── SETUP_GIT_REPO.bat      # Git repository setup
├── PROJECT_FEATURES.md     # Complete feature documentation
├── PROJECT_SUMMARY.md      # Project overview
└── README.md               # This file
```

## Demo Credentials

No passwords required! Use any of these emails to login:
- alice@example.com
- bob@example.com
- charlie@example.com
- diana@example.com
- eve@example.com
- frank@example.com

## Documentation Files

- **`PROJECT_FEATURES.md`** - Complete feature report with technical details
- **`PROJECT_SUMMARY.md`** - High-level project overview
- **`docs/ER_Diagram.md`** - Entity-relationship diagram with ASCII art
- **`docs/User_Requirement_Spec.md`** - Functional and non-functional requirements
- **`docs/Deliverables_Checklist.md`** - Academic requirements checklist

## Technology Stack

### Backend
- **Python 3.13.2** - Programming language
- **Flask 2.3.2** - Web framework for REST API
- **Flask-CORS 4.0.0** - Cross-origin resource sharing
- **SQLite3** - Relational database

### Frontend
- **React 18.2.0** - UI library
- **JavaScript (ES6+)** - Programming language
- **CSS3** - Custom animations and purple gradient theme

### Database
- **5 Main Tables:** users, restaurants, menu_items, orders, order_items
- **1 Audit Table:** order_status_log (created by trigger)
- **4 Active Triggers:** Auto-increment, deletion protection, total calculation, audit logging
- **5 Foreign Keys:** Maintaining referential integrity
- **20+ Constraints:** PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK, DEFAULT

## Features Implemented

### Database Design (Review 2 Requirements)
- Normalized to 3NF (Third Normal Form)
- ER diagram with 5 entities and relationships
- 6 constraint types implemented (PK, FK, NOT NULL, UNIQUE, CHECK, DEFAULT)
- Sample data: 6 restaurants, 64 menu items, 6 users, 10 orders

### Implementation (Review 4 Requirements)
- **4 Triggers:**
  1. `increment_order_count` - Auto-increment restaurant order count
  2. `prevent_restaurant_delete` - Block deletion of restaurants with orders
  3. `update_order_total` - Auto-calculate order totals
  4. `log_order_status_change` - Audit trail for status changes
  
- **Full CRUD Operations:**
  - CREATE: Register users, place orders, add items
  - READ: Fetch restaurants, menus, orders, analytics
  - UPDATE: Change order status, modify menu items
  - DELETE: Cancel orders, remove menu items

- **4 Procedures & 4 Functions** (documented in SQL)
  
- **4 Complex Queries:**
  1. Restaurant performance dashboard (LEFT JOIN, GROUP BY, aggregations)
  2. Customer order history (3-table INNER JOIN)
  3. Customer lifetime value (subqueries, aggregations)
  4. Popular menu items (3-table JOIN with sorting)

- **3-Page Frontend:**
  1. Login page (email-based authentication)
  2. Home page (browse restaurants, add to cart, checkout)
  3. My Orders page (order history with status badges)

- **10 REST API Endpoints** (see table below)

## API Endpoints

| Method | Endpoint | Purpose | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api/restaurants` | List all restaurants | - | Array of restaurants |
| GET | `/api/menu/:id` | Get restaurant menu | restaurant_id | Array of menu items |
| GET | `/api/orders/:id` | Get order details | order_id | Order with items |
| GET | `/api/orders/user/:id` | Get user's orders | user_id | Array of orders |
| GET | `/api/analytics` | Restaurant analytics | - | Performance data |
| POST | `/api/register` | Create new user | {name, email, phone} | User object |
| POST | `/api/orders` | Place new order | {user_id, restaurant_id, items} | Order object |
| POST | `/api/orders/:id/items` | Add item to order | {item_id, quantity, price} | Success message |
| PUT | `/api/orders/:id/status` | Update order status | {status} | Success message |
| DELETE | `/api/menu/:id` | Delete menu item | - | Success message |

## Demo Pages

### REVIEW_2_DEMO.html (Database Design)
- Works **offline** (no backend required)
- Demonstrates database design concepts
- Shows ER diagram, normalization, schema DDL
- Displays constraints and sample data
- Includes example queries with expected results

### REVIEW_4_DEMO.html (Live Functionality)
- Requires **backend running** on port 5000
- Interactive buttons that execute **real** database operations
- **4 Trigger Demos:** Click buttons to see triggers in action
- **5 CRUD Demos:** Actually creates users, fetches data, updates orders
- **3 Complex Query Demos:** Runs analytics queries and displays results
- **Auto-Execute Mode:** Click "RUN ALL" buttons for complete demos

## Database Schema

### Tables
1. **users** (id, name, email*, phone, created_at)
2. **restaurants** (id, name, address, phone, cuisine_type, order_count)
3. **menu_items** (id, restaurant_id→, name, description, price, category, available)
4. **orders** (id, user_id→, restaurant_id→, total_price, status, created_at)
5. **order_items** (id, order_id→, item_id→, quantity, price)
6. **order_status_log** (id, order_id, old_status, new_status, changed_at)

*email is UNIQUE  
→ indicates FOREIGN KEY

## Sample Data
- **6 Restaurants:** Pizza Palace, Burger Barn, Sushi Supreme, Taco Fiesta, Thai Paradise, Dragon Wok
- **64 Menu Items:** 8 items per restaurant across multiple categories
- **6 Users:** Alice, Bob, Charlie, Diana, Eve, Frank
- **10 Orders:** Various statuses (delivered, confirmed, pending, cancelled)

## Git Repository Setup

To create a Git repository with organized commits:

```powershell
# Run the Git setup script
SETUP_GIT_REPO.bat
```

This creates 5 organized commits:
1. Documentation files
2. Database schema and SQL scripts
3. Backend Flask API
4. Frontend React application
5. Demo pages and automation

To push to GitHub:
```bash
git remote add origin YOUR_REPO_URL
git branch -M main
git push -u origin main
```

## Academic Compliance

This project meets all DBMS course requirements:
- Database design and normalization (3NF)
- ER diagrams and schema definition
- Multiple constraints and foreign keys
- Triggers with before/after operations
- Complete CRUD implementation
- Stored procedures and functions
- Complex queries with multiple JOINs
- Full-stack application with UI
- Comprehensive documentation
- Live demonstration capability

## Troubleshooting

### Backend won't start
- Make sure Python 3.x is installed: `python --version`
- Install dependencies: `pip install -r backend/requirements.txt`
- Check if port 5000 is available

### Frontend won't start
- Make sure Node.js is installed: `node --version`
- Install dependencies: `npm install` in frontend folder
- Check if port 3001 is available

### Database errors
- Delete `backend/food.db` and run `python backend/init_db.py` again

### REVIEW_4_DEMO.html buttons not working
- Make sure Flask backend is running on port 5000
- Check browser console for error messages

## Contributing

This is an academic project built for learning purposes. Feel free to:
- Fork the repository
- Study the code
- Modify for your own projects
- Use as reference for DBMS assignments

## License

MIT License - Free to use for educational purposes.

## Contact

For questions or issues, please refer to the documentation files or check the inline code comments.

---

**Project Status:** Complete and Demo-Ready  
**Last Updated:** January 2025  
**Lines of Code:** ~2,500 (Backend: 400, Frontend: 300, SQL: 800, HTML: 1,000)
