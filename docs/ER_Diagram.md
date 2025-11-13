# Entity-Relationship Diagram

## Entities and Relationships

### **users** (1) ──< (M) **orders**
A user can place multiple orders.

### **restaurants** (1) ──< (M) **menu_items**
A restaurant has multiple menu items.

### **restaurants** (1) ──< (M) **orders**
A restaurant receives multiple orders.

### **orders** (1) ──< (M) **order_items**
An order contains multiple order items.

### **menu_items** (1) ──< (M) **order_items**
A menu item can appear in multiple orders.

---

## Entity Details

### **users**
- **PK:** id (INTEGER, AUTO_INCREMENT)
- name (TEXT, NOT NULL)
- email (TEXT, UNIQUE, NOT NULL)
- phone (TEXT, NOT NULL)
- created_at (TIMESTAMP, DEFAULT NOW)

### **restaurants**
- **PK:** id (INTEGER, AUTO_INCREMENT)
- name (TEXT, NOT NULL)
- address (TEXT, NOT NULL)
- phone (TEXT, NOT NULL)
- cuisine_type (TEXT)
- order_count (INTEGER, DEFAULT 0)
- created_at (TIMESTAMP, DEFAULT NOW)

### **menu_items**
- **PK:** id (INTEGER, AUTO_INCREMENT)
- **FK:** restaurant_id → restaurants(id)
- name (TEXT, NOT NULL)
- description (TEXT)
- price (REAL, NOT NULL, > 0)
- category (TEXT)
- available (BOOLEAN, DEFAULT TRUE)

### **orders**
- **PK:** id (INTEGER, AUTO_INCREMENT)
- **FK:** user_id → users(id)
- **FK:** restaurant_id → restaurants(id)
- total_price (REAL, NOT NULL, > 0)
- status (TEXT, DEFAULT 'pending', CHECK IN ('pending','confirmed','delivered','cancelled'))
- created_at (TIMESTAMP, DEFAULT NOW)

### **order_items**
- **PK:** id (INTEGER, AUTO_INCREMENT)
- **FK:** order_id → orders(id)
- **FK:** item_id → menu_items(id)
- quantity (INTEGER, NOT NULL, > 0)
- price (REAL, NOT NULL, > 0)  *(snapshot of menu_item price at order time)*

---

## Trigger

**increment_order_count**
- Executes AFTER INSERT on orders
- Updates restaurants.order_count += 1 for the restaurant in the new order

---

## ASCII Diagram

```
┌──────────┐          ┌──────────────┐          ┌──────────────┐
│  users   │          │ restaurants  │          │  menu_items  │
├──────────┤          ├──────────────┤          ├──────────────┤
│ id (PK)  │          │ id (PK)      │          │ id (PK)      │
│ name     │          │ name         │          │ restaurant_id│
│ email    │          │ address      │          │   (FK)       │
│ phone    │          │ phone        │          │ name         │
│created_at│          │ cuisine_type │          │ description  │
└────┬─────┘          │ order_count  │          │ price        │
     │                │ created_at   │          │ category     │
     │                └──────┬───────┘          │ available    │
     │                       │                  └──────┬───────┘
     │                       │                         │
     │ 1:M                   │ 1:M                     │ 1:M
     │                       │                         │
     └───────┐       ┌───────┘                         │
             │       │                                 │
             ▼       ▼                                 │
        ┌────────────┐                                │
        │   orders   │                                │
        ├────────────┤                                │
        │ id (PK)    │                                │
        │ user_id(FK)│                                │
        │restaurant  │                                │
        │  _id (FK)  │                                │
        │total_price │                                │
        │ status     │                                │
        │created_at  │                                │
        └──────┬─────┘                                │
               │                                      │
               │ 1:M                                  │
               │                                      │
               ▼                                      │
        ┌─────────────┐                               │
        │ order_items │◄──────────────────────────────┘
        ├─────────────┤                        1:M
        │ id (PK)     │
        │ order_id(FK)│
        │ item_id (FK)│
        │ quantity    │
        │ price       │
        └─────────────┘
```
