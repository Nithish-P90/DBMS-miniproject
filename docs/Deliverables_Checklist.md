# Deliverables Checklist

This document maps common academic project deliverables to the files created in this project.

---

## 1. Database Design

### ER Diagram
- **File:** `docs/ER_Diagram.md`
- **Content:** Complete entity-relationship diagram with all tables, primary keys, foreign keys, and relationships
- **Format:** ASCII diagram + textual description

### Database Schema (DDL)
- **File:** `sql/schema.sql`
- **Content:** Complete SQL DDL statements for all tables with constraints, foreign keys, and trigger
- **Features:**
  - 5 tables: users, restaurants, menu_items, orders, order_items
  - Foreign key constraints with CASCADE rules
  - CHECK constraints for data validation
  - 1 trigger (increment_order_count)

### Sample Data
- **File:** `sql/seed_data.sql`
- **Content:** INSERT statements for initial test data
- **Data:** 2 users, 2 restaurants, 8 menu items

---

## 2. Backend Implementation

### REST API
- **File:** `backend/app.py`
- **Endpoints:**
  - `GET /api/restaurants` - List all restaurants
  - `GET /api/menu/<id>` - Get menu for restaurant
  - `POST /api/register` - Register new user
  - `POST /api/orders` - Create new order
  - `GET /api/orders/<user_id>` - Get user's orders
- **Features:**
  - Input validation
  - Error handling with appropriate HTTP status codes
  - JSON responses
  - CORS enabled

### Database Initialization
- **File:** `backend/init_db.py`
- **Purpose:** Automated database setup from SQL files
- **Actions:**
  - Creates SQLite database file
  - Executes schema.sql
  - Executes seed_data.sql
  - Provides confirmation output

### Dependencies
- **File:** `backend/requirements.txt`
- **Content:** Python package dependencies (Flask, Flask-Cors)

---

## 3. Frontend Implementation

### React Application
- **Files:**
  - `frontend/src/App.js` - Main application component
  - `frontend/src/index.js` - React entry point
  - `frontend/public/index.html` - HTML template

### Features Implemented
- Restaurant listing with cards
- Menu viewing per restaurant
- Shopping cart with quantity controls
- Order placement (checkout)
- Success/error notifications
- Responsive layout with sticky cart sidebar

### Configuration
- **File:** `frontend/package.json`
- **Proxy:** Configured to point to `http://localhost:5000` for API calls

---

## 4. Documentation

### User Requirements
- **File:** `docs/User_Requirement_Spec.md`
- **Content:**
  - Functional requirements (FR1-FR6)
  - Non-functional requirements (NFR1-NFR4)
  - Implementation mapping
  - Scope definition

### Project README
- **File:** `README.md`
- **Content:**
  - Project overview
  - Setup instructions (backend & frontend)
  - Sample curl commands for API testing
  - Troubleshooting guide
  - SQLite vs MySQL notes

### This Checklist
- **File:** `docs/Deliverables_Checklist.md`
- **Purpose:** Maps professor's requirements to actual files

---

## 5. Testing & Verification

### API Testing
- **Method:** curl commands in README.md
- **Tests:**
  - User registration
  - Restaurant listing
  - Menu retrieval
  - Order placement
  - Order history

### Manual UI Testing
- **Steps:**
  1. Start backend: `python backend/app.py`
  2. Start frontend: `cd frontend && npm start`
  3. Browse restaurants at `http://localhost:3000`
  4. Add items to cart
  5. Complete checkout
  6. Verify order confirmation

---

## 6. Screenshots (To Be Captured)

For submission, capture the following:

### Database Screenshots
- [ ] SQLite database structure (using DB Browser for SQLite)
- [ ] Sample data in tables (users, restaurants, menu_items)
- [ ] Trigger definition

### API Screenshots
- [ ] Postman or curl output for each endpoint
- [ ] Success responses with 200/201 status codes
- [ ] Error responses with 400/404/409 status codes

### Frontend Screenshots
- [ ] Restaurant listing page
- [ ] Menu view with items
- [ ] Cart with multiple items
- [ ] Order confirmation message
- [ ] Browser DevTools showing API calls

### Trigger Verification
- [ ] Restaurant order_count before placing order
- [ ] Restaurant order_count after placing order (should increment)
- [ ] SQL query: `SELECT id, name, order_count FROM restaurants;`

---

## 7. Additional Deliverables (If Required)

### Presentation Slides
- **Suggested Content:**
  - Project overview (1 slide)
  - Database schema diagram (1 slide)
  - API endpoints list (1 slide)
  - Frontend demo screenshots (2-3 slides)
  - Trigger explanation (1 slide)
  - Challenges & learning (1 slide)

### Video Demo
- **Recording Steps:**
  1. Show project structure
  2. Run `python backend/init_db.py`
  3. Start Flask server
  4. Start React frontend
  5. Browse restaurants
  6. Add items to cart
  7. Complete checkout
  8. Query database to show trigger worked

### Code Comments
- All files include inline comments explaining logic
- Function docstrings in backend/app.py

---

## Quick Verification Checklist

Before submission, verify:

- [ ] All files are present in correct folder structure
- [ ] Backend runs without errors: `python backend/app.py`
- [ ] Database initializes successfully: `python backend/init_db.py`
- [ ] Frontend builds and runs: `npm start` in frontend/
- [ ] All API endpoints return expected responses
- [ ] Trigger increments order_count correctly
- [ ] Frontend can place orders successfully
- [ ] README instructions are accurate and complete
- [ ] Documentation files are properly formatted
- [ ] No hardcoded paths or credentials

---

## File Count Summary

- **Backend:** 3 files (app.py, init_db.py, requirements.txt)
- **Frontend:** 4 files (package.json, index.html, index.js, App.js)
- **SQL:** 2 files (schema.sql, seed_data.sql)
- **Docs:** 3 files (User_Requirement_Spec.md, ER_Diagram.md, Deliverables_Checklist.md)
- **Root:** 1 file (README.md)
- **Total:** 13 files + folder structure
