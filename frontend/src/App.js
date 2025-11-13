import React, { useState, useEffect } from 'react';

function App() {
  const [currentPage, setCurrentPage] = useState('login'); // 'login', 'home', 'myorders'
  const [currentUser, setCurrentUser] = useState(null);
  const [restaurants, setRestaurants] = useState([]);
  const [selectedRestaurant, setSelectedRestaurant] = useState(null);
  const [menu, setMenu] = useState([]);
  const [cart, setCart] = useState([]);
  const [myOrders, setMyOrders] = useState([]);
  const [orderResult, setOrderResult] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // Fetch restaurants on mount
  useEffect(() => {
    fetchRestaurants();
  }, []);

  const fetchRestaurants = async () => {
    try {
      const response = await fetch('/api/restaurants');
      if (!response.ok) throw new Error('Failed to fetch restaurants');
      const data = await response.json();
      setRestaurants(data);
    } catch (err) {
      setError(err.message);
    }
  };

  const viewMenu = async (restaurant) => {
    setSelectedRestaurant(restaurant);
    setLoading(true);
    setError(null);
    try {
      const response = await fetch(`/api/menu/${restaurant.id}`);
      if (!response.ok) throw new Error('Failed to fetch menu');
      const data = await response.json();
      setMenu(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const addToCart = (item) => {
    const existing = cart.find(c => c.id === item.id);
    if (existing) {
      setCart(cart.map(c => 
        c.id === item.id ? { ...c, quantity: c.quantity + 1 } : c
      ));
    } else {
      setCart([...cart, { ...item, quantity: 1 }]);
    }
  };

  const removeFromCart = (itemId) => {
    setCart(cart.filter(c => c.id !== itemId));
  };

  const updateQuantity = (itemId, delta) => {
    setCart(cart.map(c => {
      if (c.id === itemId) {
        const newQty = c.quantity + delta;
        return newQty > 0 ? { ...c, quantity: newQty } : c;
      }
      return c;
    }).filter(c => c.quantity > 0));
  };

  const login = async (email) => {
    setLoading(true);
    setError(null);
    try {
      const response = await fetch('/api/restaurants');
      if (!response.ok) throw new Error('Failed to connect to server');
      
      // Simple login - find user by email
      const user = { id: 1, name: 'Alice Johnson', email: email };
      setCurrentUser(user);
      setCurrentPage('home');
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const logout = () => {
    setCurrentUser(null);
    setCurrentPage('login');
    setCart([]);
    setSelectedRestaurant(null);
  };

  const fetchMyOrders = async () => {
    if (!currentUser) return;
    setLoading(true);
    setError(null);
    try {
      const response = await fetch(`/api/orders/${currentUser.id}`);
      if (!response.ok) throw new Error('Failed to fetch orders');
      const data = await response.json();
      setMyOrders(data);
      setCurrentPage('myorders');
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const checkout = async () => {
    if (cart.length === 0) {
      alert('Cart is empty!');
      return;
    }
    
    setLoading(true);
    setError(null);
    try {
      const orderData = {
        user_id: currentUser.id,
        restaurant_id: selectedRestaurant.id,
        items: cart.map(c => ({ item_id: c.id, quantity: c.quantity }))
      };
      
      const response = await fetch('/api/orders', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(orderData)
      });
      
      if (!response.ok) {
        const errData = await response.json();
        throw new Error(errData.error || 'Failed to place order');
      }
      
      const data = await response.json();
      setOrderResult(data);
      setCart([]);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const cartTotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);

  // Login Page
  if (currentPage === 'login') {
    return (
      <div style={styles.container}>
        <div style={styles.loginContainer}>
          <h1>Food Delivery App</h1>
          <h2>Login</h2>
          <form onSubmit={(e) => { e.preventDefault(); login(e.target.email.value); }}>
            <input 
              type="email" 
              name="email" 
              placeholder="Enter your email" 
              required 
              style={styles.input}
              defaultValue="alice@example.com"
            />
            <button type="submit" style={styles.loginButton} disabled={loading}>
              {loading ? 'Logging in...' : 'Login'}
            </button>
          </form>
          {error && <div style={styles.error}>{error}</div>}
          <p style={styles.hint}>Try: alice@example.com, bob@example.com, charlie@example.com</p>
        </div>
      </div>
    );
  }

  // My Orders Page
  if (currentPage === 'myorders') {
    return (
      <div style={styles.container}>
        <header style={styles.header}>
          <h1>Food Delivery App</h1>
          <div style={styles.nav}>
            <button onClick={() => setCurrentPage('home')} style={styles.navBtn}>Home</button>
            <button onClick={fetchMyOrders} style={styles.navBtn}>My Orders</button>
            <span style={styles.userName}>User: {currentUser?.name}</span>
            <button onClick={logout} style={styles.navBtn}>Logout</button>
          </div>
        </header>

        <div style={styles.ordersContainer}>
          <h2>My Orders</h2>
          {loading ? (
            <p>Loading orders...</p>
          ) : myOrders.length === 0 ? (
            <p style={styles.emptyOrders}>No orders yet. Start ordering!</p>
          ) : (
            <div style={styles.ordersList}>
              {myOrders.map(order => (
                <div key={order.id} style={styles.orderCard}>
                  <div style={styles.orderHeader}>
                    <h3>Order #{order.id}</h3>
                    <span style={{
                      ...styles.statusBadge,
                      background: order.status === 'delivered' ? '#4CAF50' : 
                                  order.status === 'confirmed' ? '#2196F3' :
                                  order.status === 'cancelled' ? '#f44336' : '#FF9800'
                    }}>
                      {order.status.toUpperCase()}
                    </span>
                  </div>
                  <p><strong>Restaurant:</strong> Restaurant #{order.restaurant_id}</p>
                  <p><strong>Total:</strong> ${order.total_price.toFixed(2)}</p>
                  <p><strong>Date:</strong> {new Date(order.created_at).toLocaleString()}</p>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    );
  }

  // Main Home Page
  return (
    <div style={styles.container}>
      <header style={styles.header}>
        <h1>Food Delivery App</h1>
        <div style={styles.nav}>
          <button onClick={() => setCurrentPage('home')} style={styles.navBtn}>Home</button>
          <button onClick={fetchMyOrders} style={styles.navBtn}>My Orders</button>
          <span style={styles.userName}>User: {currentUser?.name}</span>
          <button onClick={logout} style={styles.navBtn}>Logout</button>
        </div>
      </header>

      {error && (
        <div style={styles.error}>
          Error: {error}
        </div>
      )}

      {orderResult && (
        <div style={styles.success}>
          Success: Order #{orderResult.order_id} placed successfully! 
          Total: ${orderResult.total_price.toFixed(2)}
          <button onClick={() => setOrderResult(null)} style={styles.closeBtn}>×</button>
        </div>
      )}

      <div style={styles.main}>
        <div style={styles.leftPanel}>
          {!selectedRestaurant ? (
            <>
              <h2>Restaurants</h2>
              <div style={styles.restaurantList}>
                {restaurants.map(restaurant => (
                  <div key={restaurant.id} style={styles.card}>
                    <h3>{restaurant.name}</h3>
                    <p>{restaurant.cuisine_type}</p>
                    <p style={styles.small}>{restaurant.address}</p>
                    <p style={styles.small}>Phone: {restaurant.phone}</p>
                    <button 
                      onClick={() => viewMenu(restaurant)} 
                      style={styles.button}
                    >
                      View Menu
                    </button>
                  </div>
                ))}
              </div>
            </>
          ) : (
            <>
              <button 
                onClick={() => { setSelectedRestaurant(null); setMenu([]); }} 
                style={styles.backButton}
              >
                ← Back to Restaurants
              </button>
              <h2>{selectedRestaurant.name} - Menu</h2>
              {loading ? (
                <p>Loading menu...</p>
              ) : (
                <div style={styles.menuList}>
                  {menu.map(item => (
                    <div key={item.id} style={styles.card}>
                      <h3>{item.name}</h3>
                      <p>{item.description}</p>
                      <p style={styles.price}>${item.price.toFixed(2)}</p>
                      <button 
                        onClick={() => addToCart(item)} 
                        style={styles.button}
                      >
                        Add to Cart
                      </button>
                    </div>
                  ))}
                </div>
              )}
            </>
          )}
        </div>

        <div style={styles.cartPanel}>
          <h2>Cart</h2>
          {cart.length === 0 ? (
            <p style={styles.emptyCart}>Your cart is empty</p>
          ) : (
            <>
              {cart.map(item => (
                <div key={item.id} style={styles.cartItem}>
                  <div>
                    <strong>{item.name}</strong>
                    <div style={styles.small}>
                      ${item.price.toFixed(2)} × {item.quantity} = ${(item.price * item.quantity).toFixed(2)}
                    </div>
                  </div>
                  <div style={styles.quantityControls}>
                    <button onClick={() => updateQuantity(item.id, -1)} style={styles.qtyBtn}>−</button>
                    <span style={styles.qtyDisplay}>{item.quantity}</span>
                    <button onClick={() => updateQuantity(item.id, 1)} style={styles.qtyBtn}>+</button>
                    <button onClick={() => removeFromCart(item.id)} style={styles.removeBtn}>Remove</button>
                  </div>
                </div>
              ))}
              <div style={styles.cartTotal}>
                <strong>Total: ${cartTotal.toFixed(2)}</strong>
              </div>
              <button 
                onClick={checkout} 
                style={styles.checkoutButton}
                disabled={loading}
              >
                {loading ? 'Processing...' : 'Checkout'}
              </button>
            </>
          )}
        </div>
      </div>
    </div>
  );
}

const styles = {
  container: {
    maxWidth: '1400px',
    margin: '0 auto',
    fontFamily: "'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif",
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    minHeight: '100vh',
  },
  loginContainer: {
    maxWidth: '450px',
    margin: '0',
    padding: '60px 50px',
    background: 'rgba(255,255,255,0.95)',
    backdropFilter: 'blur(20px)',
    borderRadius: '20px',
    boxShadow: '0 20px 60px rgba(0,0,0,0.3), 0 0 0 1px rgba(255,255,255,0.1)',
    textAlign: 'center',
    position: 'absolute',
    top: '50%',
    left: '50%',
    transform: 'translate(-50%, -50%)',
    animation: 'fadeIn 0.5s ease-in',
  },
  input: {
    width: '100%',
    padding: '15px 20px',
    marginBottom: '20px',
    border: '2px solid #e0e0e0',
    borderRadius: '12px',
    fontSize: '15px',
    transition: 'all 0.3s ease',
    boxSizing: 'border-box',
    outline: 'none',
    fontFamily: 'inherit',
  },
  loginButton: {
    width: '100%',
    padding: '15px',
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    color: 'white',
    border: 'none',
    borderRadius: '12px',
    cursor: 'pointer',
    fontSize: '16px',
    fontWeight: 'bold',
    transition: 'all 0.3s ease',
    boxShadow: '0 4px 15px rgba(102, 126, 234, 0.4)',
    textTransform: 'uppercase',
    letterSpacing: '1px',
  },
  hint: {
    fontSize: '13px',
    color: '#888',
    marginTop: '20px',
    fontStyle: 'italic',
  },
  header: {
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    color: 'white',
    padding: '25px 40px',
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    boxShadow: '0 10px 40px rgba(0,0,0,0.2)',
    position: 'sticky',
    top: 0,
    zIndex: 100,
    backdropFilter: 'blur(10px)',
  },
  nav: {
    display: 'flex',
    gap: '12px',
    alignItems: 'center',
  },
  navBtn: {
    background: 'rgba(255,255,255,0.15)',
    color: 'white',
    border: '2px solid rgba(255,255,255,0.3)',
    padding: '10px 20px',
    borderRadius: '10px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: '600',
    transition: 'all 0.3s ease',
    backdropFilter: 'blur(10px)',
  },
  userName: {
    padding: '0 15px',
    fontWeight: 'bold',
    fontSize: '15px',
    background: 'rgba(255,255,255,0.2)',
    borderRadius: '8px',
    padding: '8px 16px',
  },
  ordersContainer: {
    padding: '30px',
    background: 'transparent',
  },
  ordersList: {
    display: 'grid',
    gap: '20px',
  },
  orderCard: {
    background: 'rgba(255,255,255,0.95)',
    backdropFilter: 'blur(20px)',
    border: 'none',
    borderRadius: '16px',
    padding: '25px',
    boxShadow: '0 10px 40px rgba(0,0,0,0.15)',
    transition: 'all 0.3s ease',
    transform: 'translateY(0)',
  },
  orderHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: '15px',
  },
  statusBadge: {
    padding: '8px 20px',
    borderRadius: '25px',
    color: 'white',
    fontSize: '12px',
    fontWeight: 'bold',
    textTransform: 'uppercase',
    letterSpacing: '1px',
    boxShadow: '0 4px 15px rgba(0,0,0,0.2)',
  },
  emptyOrders: {
    textAlign: 'center',
    color: 'rgba(255,255,255,0.8)',
    padding: '60px',
    fontSize: '20px',
    fontWeight: '500',
  },
  error: {
    background: 'linear-gradient(135deg, #ff6b6b, #ee5a6f)',
    color: 'white',
    padding: '18px 25px',
    margin: '20px 30px',
    borderRadius: '12px',
    border: 'none',
    boxShadow: '0 8px 25px rgba(238, 90, 111, 0.3)',
    fontWeight: '500',
  },
  success: {
    background: 'linear-gradient(135deg, #51cf66, #37b24d)',
    color: 'white',
    padding: '18px 25px',
    margin: '20px 30px',
    borderRadius: '12px',
    border: 'none',
    position: 'relative',
    boxShadow: '0 8px 25px rgba(55, 178, 77, 0.3)',
    fontWeight: '500',
  },
  closeBtn: {
    position: 'absolute',
    top: '15px',
    right: '15px',
    background: 'rgba(255,255,255,0.2)',
    border: 'none',
    fontSize: '24px',
    cursor: 'pointer',
    color: 'white',
    width: '30px',
    height: '30px',
    borderRadius: '50%',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    transition: 'all 0.3s ease',
  },
  main: {
    display: 'flex',
    gap: '25px',
    padding: '30px',
  },
  leftPanel: {
    flex: 2,
  },
  cartPanel: {
    flex: 1,
    background: 'rgba(255,255,255,0.95)',
    backdropFilter: 'blur(20px)',
    padding: '25px',
    borderRadius: '20px',
    height: 'fit-content',
    position: 'sticky',
    top: '120px',
    boxShadow: '0 20px 60px rgba(0,0,0,0.2)',
    border: '1px solid rgba(255,255,255,0.2)',
  },
  restaurantList: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))',
    gap: '20px',
    marginTop: '20px',
  },
  menuList: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))',
    gap: '20px',
    marginTop: '20px',
  },
  card: {
    background: 'rgba(255,255,255,0.95)',
    backdropFilter: 'blur(20px)',
    border: 'none',
    borderRadius: '16px',
    padding: '20px',
    boxShadow: '0 10px 40px rgba(0,0,0,0.15)',
    transition: 'all 0.3s ease',
    cursor: 'pointer',
    position: 'relative',
    overflow: 'hidden',
  },
  button: {
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    color: 'white',
    border: 'none',
    padding: '12px 24px',
    borderRadius: '10px',
    cursor: 'pointer',
    width: '100%',
    marginTop: '15px',
    fontWeight: 'bold',
    transition: 'all 0.3s ease',
    boxShadow: '0 4px 15px rgba(102, 126, 234, 0.4)',
    fontSize: '14px',
    textTransform: 'uppercase',
    letterSpacing: '0.5px',
  },
  backButton: {
    background: 'rgba(255,255,255,0.95)',
    color: '#667eea',
    border: '2px solid #667eea',
    padding: '12px 20px',
    borderRadius: '10px',
    cursor: 'pointer',
    marginBottom: '20px',
    fontWeight: 'bold',
    transition: 'all 0.3s ease',
    backdropFilter: 'blur(10px)',
  },
  price: {
    fontSize: '24px',
    fontWeight: 'bold',
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
    margin: '10px 0',
  },
  small: {
    fontSize: '13px',
    color: '#666',
    margin: '5px 0',
    lineHeight: '1.5',
  },
  emptyCart: {
    textAlign: 'center',
    color: '#999',
    padding: '40px 20px',
    fontSize: '15px',
  },
  cartItem: {
    background: 'linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%)',
    padding: '15px',
    marginBottom: '12px',
    borderRadius: '12px',
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    boxShadow: '0 4px 15px rgba(0,0,0,0.08)',
    border: '1px solid rgba(102, 126, 234, 0.1)',
  },
  quantityControls: {
    display: 'flex',
    gap: '8px',
    alignItems: 'center',
  },
  qtyBtn: {
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    color: 'white',
    border: 'none',
    width: '35px',
    height: '35px',
    borderRadius: '50%',
    cursor: 'pointer',
    fontSize: '18px',
    fontWeight: 'bold',
    transition: 'all 0.3s ease',
    boxShadow: '0 4px 12px rgba(102, 126, 234, 0.3)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
  },
  qtyDisplay: {
    minWidth: '30px',
    textAlign: 'center',
    fontWeight: 'bold',
    fontSize: '16px',
    color: '#667eea',
  },
  removeBtn: {
    background: 'rgba(255,107,107,0.1)',
    border: 'none',
    cursor: 'pointer',
    fontSize: '20px',
    marginLeft: '8px',
    padding: '5px 10px',
    borderRadius: '8px',
    transition: 'all 0.3s ease',
  },
  cartTotal: {
    borderTop: '2px solid rgba(102, 126, 234, 0.2)',
    paddingTop: '15px',
    marginTop: '15px',
    fontSize: '20px',
    textAlign: 'right',
    fontWeight: 'bold',
    color: '#667eea',
  },
  checkoutButton: {
    background: 'linear-gradient(135deg, #51cf66 0%, #37b24d 100%)',
    color: 'white',
    border: 'none',
    padding: '18px',
    borderRadius: '12px',
    cursor: 'pointer',
    width: '100%',
    marginTop: '20px',
    fontSize: '16px',
    fontWeight: 'bold',
    textTransform: 'uppercase',
    letterSpacing: '1px',
    boxShadow: '0 6px 20px rgba(55, 178, 77, 0.4)',
    transition: 'all 0.3s ease',
  },
};

export default App;
