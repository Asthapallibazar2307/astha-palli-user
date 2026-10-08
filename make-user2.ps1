$authContext = @'
import { createContext, useContext, useEffect, useState } from 'react';
import { onAuthStateChanged, createUserWithEmailAndPassword, signInWithEmailAndPassword, signOut, updateProfile } from 'firebase/auth';
import { doc, setDoc, getDoc, serverTimestamp } from 'firebase/firestore';
import { auth, db } from '../firebase';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsub = onAuthStateChanged(auth, async (u) => {
      try {
        if (u) {
          setUser(u);
          const snap = await getDoc(doc(db, 'users', u.uid));
          if (snap.exists()) setProfile(snap.data());
        } else {
          setUser(null);
          setProfile(null);
        }
      } catch (err) {
        setUser(null);
        setProfile(null);
      } finally {
        setLoading(false);
      }
    });
    return () => unsub();
  }, []);

  const register = async (name, phone, email, password) => {
    const cred = await createUserWithEmailAndPassword(auth, email, password);
    await updateProfile(cred.user, { displayName: name });
    await setDoc(doc(db, 'users', cred.user.uid), {
      name: name,
      phone: phone,
      email: email,
      address: '',
      blocked: false,
      createdAt: serverTimestamp()
    });
    return cred.user;
  };

  const login = async (email, password) => {
    const cred = await signInWithEmailAndPassword(auth, email, password);
    const snap = await getDoc(doc(db, 'users', cred.user.uid));
    if (snap.exists() && snap.data().blocked === true) {
      await signOut(auth);
      throw new Error('আপনার অ্যাকাউন্ট ব্লক করা হয়েছে');
    }
    return cred.user;
  };

  const logout = () => signOut(auth);

  const updateProfileData = async (data) => {
    if (!user) return;
    await setDoc(doc(db, 'users', user.uid), data, { merge: true });
    setProfile(Object.assign({}, profile, data));
  };

  return (
    <AuthContext.Provider value={{ user, profile, loading, register, login, logout, updateProfileData }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
'@

$cartContext = @'
import { createContext, useContext, useEffect, useState } from 'react';

const CartContext = createContext(null);

export function CartProvider({ children }) {
  const [items, setItems] = useState([]);

  useEffect(() => {
    const saved = localStorage.getItem('apb_cart');
    if (saved) {
      try { setItems(JSON.parse(saved)); } catch (e) { setItems([]); }
    }
  }, []);

  useEffect(() => {
    localStorage.setItem('apb_cart', JSON.stringify(items));
  }, [items]);

  const addItem = (product, qty) => {
    const q = qty || 1;
    setItems((prev) => {
      const existing = prev.find((x) => x.id === product.id);
      if (existing) {
        return prev.map((x) => x.id === product.id ? Object.assign({}, x, { qty: x.qty + q }) : x);
      }
      return prev.concat([{ id: product.id, name: product.name, price: product.price, discount: product.discount || 0, imageUrl: product.imageUrl, qty: q }]);
    });
  };

  const removeItem = (id) => {
    setItems((prev) => prev.filter((x) => x.id !== id));
  };

  const updateQty = (id, qty) => {
    if (qty <= 0) return removeItem(id);
    setItems((prev) => prev.map((x) => x.id === id ? Object.assign({}, x, { qty: qty }) : x));
  };

  const clearCart = () => setItems([]);

  const subtotal = items.reduce((s, x) => s + Number(x.price) * Number(x.qty), 0);
  const totalItems = items.reduce((s, x) => s + Number(x.qty), 0);

  return (
    <CartContext.Provider value={{ items, addItem, removeItem, updateQty, clearCart, subtotal, totalItems }}>
      {children}
    </CartContext.Provider>
  );
}

export const useCart = () => useContext(CartContext);
'@

$bottombar = @'
import { NavLink } from 'react-router-dom';
import { useCart } from '../context/CartContext';

export default function BottomBar() {
  const { totalItems } = useCart();
  return (
    <nav className="bottombar">
      <NavLink to="/" end>
        <span className="nav-icon">🏠</span>
        <span className="nav-label">Home</span>
      </NavLink>
      <NavLink to="/cart">
        <span className="nav-icon">🛒{totalItems > 0 && <span className="cart-badge">{totalItems}</span>}</span>
        <span className="nav-label">Cart</span>
      </NavLink>
      <NavLink to="/orders">
        <span className="nav-icon">📦</span>
        <span className="nav-label">Orders</span>
      </NavLink>
      <NavLink to="/account">
        <span className="nav-icon">👤</span>
        <span className="nav-label">Account</span>
      </NavLink>
    </nav>
  );
}
'@

$header = @'
import { Link } from 'react-router-dom';

export default function Header({ title, showBack, showSearch }) {
  return (
    <header className="app-header">
      <div className="header-left">
        {showBack ? <button className="icon-btn" onClick={() => window.history.back()}>←</button> : <Link to="/" className="header-logo"><img src="/logo.png" alt="" /></Link>}
      </div>
      <h1 className="header-title">{title}</h1>
      <div className="header-right">
        {showSearch && <Link to="/search" className="icon-btn">🔍</Link>}
      </div>
    </header>
  );
}
'@

$productCard = @'
import { Link } from 'react-router-dom';
import { formatBDT } from '../utils/format';

export default function ProductCard({ product }) {
  const price = Number(product.price) || 0;
  const discount = Number(product.discount) || 0;
  const finalPrice = discount > 0 ? price - (price * discount / 100) : price;
  const outOfStock = Number(product.stock) <= 0;

  return (
    <Link to={'/product/' + product.id} className="product-card">
      <div className="product-img-wrap">
        {product.imageUrl ? <img src={product.imageUrl} alt={product.name} className="product-img" /> : <div className="product-img placeholder">🛍️</div>}
        {discount > 0 && <span className="discount-badge">-{discount}%</span>}
        {outOfStock && <span className="stock-out">Out of Stock</span>}
      </div>
      <div className="product-info">
        <h3 className="product-name">{product.name}</h3>
        <div className="product-price">
          <span className="price-final">{formatBDT(finalPrice)}</span>
          {discount > 0 && <span className="price-old">{formatBDT(price)}</span>}
        </div>
      </div>
    </Link>
  );
}
'@

Set-Content -Path src\context\AuthContext.jsx -Value $authContext -Encoding UTF8
Set-Content -Path src\context\CartContext.jsx -Value $cartContext -Encoding UTF8
Set-Content -Path src\components\BottomBar.jsx -Value $bottombar -Encoding UTF8
Set-Content -Path src\components\Header.jsx -Value $header -Encoding UTF8
Set-Content -Path src\components\ProductCard.jsx -Value $productCard -Encoding UTF8

Write-Host "Done! Context + Components created."