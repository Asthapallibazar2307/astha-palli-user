$home = @'
import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { useCollection } from '../hooks/useCollection';
import ProductCard from '../components/ProductCard';
import { doc, onSnapshot } from 'firebase/firestore';
import { db } from '../firebase';
import { formatBDT } from '../utils/format';

export default function Home() {
  const { data: products } = useCollection('products', { orderByField: 'createdAt' });
  const { data: banners } = useCollection('banners', { orderByField: 'createdAt' });
  const { data: categories } = useCollection('categories', { orderByField: 'createdAt' });
  const [settings, setSettings] = useState(null);

  useEffect(() => {
    return onSnapshot(doc(db, 'settings', 'shop'), (snap) => {
      setSettings(snap.exists() ? snap.data() : null);
    });
  }, []);

  const activeBanner = banners.find((b) => b.enabled !== false);
  const todaysOffers = products.filter((p) => p.todaysOffer && p.enabled !== false);
  const featured = products.filter((p) => p.featured && p.enabled !== false).slice(0, 8);
  const popular = products.filter((p) => p.enabled !== false).slice(0, 8);

  return (
    <div className="page-home">
      {activeBanner && (
        <div className="banner">
          <img src={activeBanner.imageUrl} alt="" className="banner-img" />
          <div className="banner-overlay">
            {activeBanner.title && <h2>{activeBanner.title}</h2>}
            {activeBanner.description && <p>{activeBanner.description}</p>}
            {activeBanner.offerText && <span className="banner-offer">{activeBanner.offerText}</span>}
          </div>
        </div>
      )}

      {!activeBanner && (
        <div className="banner banner-welcome">
          <h2>স্বাগতম {settings && settings.shopName ? settings.shopName : 'আস্থা পল্লী বাজার'}এ</h2>
          <p>সেরা মানের পণ্য, ঘরে পৌঁছে দেব</p>
        </div>
      )}

      {todaysOffers.length > 0 && (
        <section className="section">
          <div className="section-head">
            <h2>🔥 আজকের অফার</h2>
            <Link to="/offers" className="see-all">সব দেখুন →</Link>
          </div>
          <div className="h-scroll">
            {todaysOffers.map((p) => <ProductCard key={p.id} product={p} />)}
          </div>
        </section>
      )}

      <section className="section">
        <div className="section-head"><h2>ক্যাটাগরি</h2></div>
        <div className="cat-scroll">
          {categories.length === 0 && <p className="muted">কোনো ক্যাটাগরি নেই</p>}
          {categories.filter((c) => c.enabled !== false).map((c) => (
            <Link key={c.id} to={'/category/' + c.id} className="cat-chip">
              {c.imageUrl ? <img src={c.imageUrl} alt="" className="cat-chip-img" /> : <span className="cat-chip-emoji">🛍️</span>}
              <span className="cat-chip-name">{c.name}</span>
            </Link>
          ))}
        </div>
      </section>

      {featured.length > 0 && (
        <section className="section">
          <div className="section-head"><h2>⭐ ফিচার্ড</h2></div>
          <div className="grid-products">
            {featured.map((p) => <ProductCard key={p.id} product={p} />)}
          </div>
        </section>
      )}

      <section className="section">
        <div className="section-head"><h2>সব পণ্য</h2></div>
        <div className="grid-products">
          {products.length === 0 && <p className="muted">কোনো পণ্য নেই</p>}
          {products.filter((p) => p.enabled !== false).map((p) => <ProductCard key={p.id} product={p} />)}
        </div>
      </section>
    </div>
  );
}
'@

$productDetail = @'
import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { doc, onSnapshot } from 'firebase/firestore';
import { db } from '../firebase';
import { formatBDT } from '../utils/format';
import { useCart } from '../context/CartContext';

export default function ProductDetail() {
  const { id } = useParams();
  const nav = useNavigate();
  const { addItem } = useCart();
  const [product, setProduct] = useState(null);
  const [qty, setQty] = useState(1);
  const [added, setAdded] = useState(false);

  useEffect(() => {
    return onSnapshot(doc(db, 'products', id), (snap) => {
      setProduct(snap.exists() ? Object.assign({ id: snap.id }, snap.data()) : null);
    });
  }, [id]);

  if (!product) return <div className="page-loading">Loading...</div>;

  const price = Number(product.price) || 0;
  const discount = Number(product.discount) || 0;
  const finalPrice = discount > 0 ? price - (price * discount / 100) : price;
  const outOfStock = Number(product.stock) <= 0;

  const addToCart = () => {
    if (outOfStock) return;
    addItem(product, qty);
    setAdded(true);
    setTimeout(() => setAdded(false), 2000);
  };

  const buyNow = () => {
    if (outOfStock) return;
    addItem(product, qty);
    nav('/cart');
  };

  return (
    <div className="page-product">
      <div className="product-hero">
        {product.imageUrl ? <img src={product.imageUrl} alt={product.name} /> : <div className="product-img placeholder">🛍️</div>}
        {discount > 0 && <span className="discount-badge-lg">-{discount}%</span>}
      </div>

      <div className="product-body">
        <h1>{product.name}</h1>
        {product.category && <p className="product-cat">{product.category}</p>}

        <div className="product-price-row">
          <span className="price-final-lg">{formatBDT(finalPrice)}</span>
          {discount > 0 && <span className="price-old-lg">{formatBDT(price)}</span>}
        </div>

        <p className={'stock-status ' + (outOfStock ? 'out' : 'in')}>
          {outOfStock ? '❌ স্টক নেই' : '✅ স্টকে আছে (' + product.stock + 'টি)'}
        </p>

        {product.description && (
          <div className="product-desc">
            <h3>বিবরণ</h3>
            <p>{product.description}</p>
          </div>
        )}

        {!outOfStock && (
          <div className="qty-selector">
            <button onClick={() => setQty(Math.max(1, qty - 1))}>−</button>
            <span>{qty}</span>
            <button onClick={() => setQty(Math.min(Number(product.stock), qty + 1))}>+</button>
          </div>
        )}

        {!outOfStock && (
          <div className="product-actions">
            <button className="btn btn-outline" onClick={addToCart}>
              {added ? '✓ যুক্ত হয়েছে' : '🛒 কার্টে যোগ করুন'}
            </button>
            <button className="btn" onClick={buyNow}>এখনই কিনুন</button>
          </div>
        )}
      </div>
    </div>
  );
}
'@

$cart = @'
import { Link, useNavigate } from 'react-router-dom';
import { useCart } from '../context/CartContext';
import { formatBDT } from '../utils/format';

export default function Cart() {
  const { items, updateQty, removeItem, subtotal, clearCart } = useCart();
  const nav = useNavigate();

  if (items.length === 0) {
    return (
      <div className="page-cart empty-cart">
        <div className="empty-icon">🛒</div>
        <h2>আপনার কার্ট খালি</h2>
        <p>পণ্য যোগ করে কেনাকাটা শুরু করুন</p>
        <Link to="/" className="btn">কেনাকাটা শুরু করুন</Link>
      </div>
    );
  }

  return (
    <div className="page-cart">
      <div className="cart-items">
        {items.map((it) => (
          <div key={it.id} className="cart-item">
            {it.imageUrl ? <img src={it.imageUrl} alt="" className="cart-item-img" /> : <div className="cart-item-img placeholder">🛍️</div>}
            <div className="cart-item-info">
              <h3>{it.name}</h3>
              <p className="cart-item-price">{formatBDT(it.price)}</p>
              <div className="qty-selector-sm">
                <button onClick={() => updateQty(it.id, it.qty - 1)}>−</button>
                <span>{it.qty}</span>
                <button onClick={() => updateQty(it.id, it.qty + 1)}>+</button>
              </div>
            </div>
            <div className="cart-item-right">
              <p className="cart-item-total">{formatBDT(it.price * it.qty)}</p>
              <button className="remove-btn" onClick={() => removeItem(it.id)}>✕</button>
            </div>
          </div>
        ))}
      </div>

      <div className="cart-footer">
        <div className="cart-total-row">
          <span>সাবটোটাল</span>
          <strong>{formatBDT(subtotal)}</strong>
        </div>
        <button className="btn" style={{ width: '100%' }} onClick={() => nav('/checkout')}>চেকআউট করুন</button>
        <button className="clear-cart-btn" onClick={clearCart}>কার্ট খালি করুন</button>
      </div>
    </div>
  );
}
'@

$checkout = @'
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { addDoc, collection, serverTimestamp, doc, getDoc } from 'firebase/firestore';
import { db } from '../firebase';
import { useCart } from '../context/CartContext';
import { useAuth } from '../context/AuthContext';
import { formatBDT } from '../utils/format';

export default function Checkout() {
  const { items, subtotal, clearCart } = useCart();
  const { user, profile } = useAuth();
  const nav = useNavigate();
  const [name, setName] = useState(profile && profile.name ? profile.name : '');
  const [phone, setPhone] = useState(profile && profile.phone ? profile.phone : '');
  const [address, setAddress] = useState(profile && profile.address ? profile.address : '');
  const [notes, setNotes] = useState('');
  const [placing, setPlacing] = useState(false);
  const [err, setErr] = useState('');

  if (items.length === 0) {
    return <div className="page-loading">কার্ট খালি</div>;
  }

  const placeOrder = async () => {
    if (!name.trim() || !phone.trim() || !address.trim()) {
      setErr('সব তথ্য পূরণ করুন');
      return;
    }
    setPlacing(true);
    setErr('');
    try {
      const settingsSnap = await getDoc(doc(db, 'settings', 'shop'));
      const deliveryCharge = settingsSnap.exists() ? Number(settingsSnap.data().deliveryCharge || 0) : 0;

      const orderData = {
        userId: user ? user.uid : null,
        customerName: name.trim(),
        phone: phone.trim(),
        address: address.trim(),
        notes: notes.trim(),
        items: items.map((it) => ({ id: it.id, name: it.name, price: Number(it.price), qty: Number(it.qty) })),
        subtotal: subtotal,
        discount: 0,
        deliveryCharge: deliveryCharge,
        total: subtotal + deliveryCharge,
        paymentMethod: 'Cash on Delivery',
        status: 'Pending',
        createdAt: serverTimestamp()
      };

      const ref = await addDoc(collection(db, 'orders'), orderData);
      clearCart();
      nav('/order/' + ref.id);
    } catch (e) {
      setErr('Order দিতে সমস্যা হয়েছে: ' + e.message);
    } finally {
      setPlacing(false);
    }
  };

  return (
    <div className="page-checkout">
      <div className="card">
        <h2>ডেলিভারি তথ্য</h2>
        {err && <div className="error-msg">{err}</div>}
        <div className="form-group">
          <label>নাম *</label>
          <input className="input" value={name} onChange={(e) => setName(e.target.value)} />
        </div>
        <div className="form-group">
          <label>মোবাইল *</label>
          <input className="input" value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="01XXXXXXXXX" />
        </div>
        <div className="form-group">
          <label>ঠিকানা *</label>
          <textarea className="textarea" value={address} onChange={(e) => setAddress(e.target.value)} />
        </div>
        <div className="form-group">
          <label>নোট (অপশনাল)</label>
          <input className="input" value={notes} onChange={(e) => setNotes(e.target.value)} />
        </div>
      </div>

      <div className="card">
        <h2>অর্ডার সারসংক্ষেপ</h2>
        {items.map((it) => (
          <div key={it.id} className="summary-row">
            <span>{it.name} × {it.qty}</span>
            <span>{formatBDT(it.price * it.qty)}</span>
          </div>
        ))}
        <div className="summary-row" style={{ borderTop: '1px solid #e2e8f0', paddingTop: 8, marginTop: 8 }}>
          <strong>সাবটোটাল</strong>
          <strong>{formatBDT(subtotal)}</strong>
        </div>
        <p className="muted" style={{ fontSize: 12 }}>ডেলিভারি চার্জ চেকআউটে যোগ হবে</p>
      </div>

      <div className="card payment-card">
        <h2>পেমেন্ট</h2>
        <div className="payment-option active">
          <span className="radio-on">●</span>
          <span>ক্যাশ অন ডেলিভারি</span>
        </div>
      </div>

      <button className="btn place-order-btn" disabled={placing} onClick={placeOrder}>
        {placing ? 'অর্ডার হচ্ছে...' : 'অর্ডার করুন'}
      </button>
    </div>
  );
}
'@

$orders = @'
import { Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useCollection } from '../hooks/useCollection';
import { formatBDT, formatDate } from '../utils/format';
import { statusClass } from '../utils/constants';

export default function Orders() {
  const { user } = useAuth();
  const { data: allOrders, loading } = useCollection('orders', { orderByField: 'createdAt' });
  const orders = user ? allOrders.filter((o) => o.userId === user.uid) : [];

  if (!user) {
    return (
      <div className="page-orders empty-cart">
        <div className="empty-icon">📦</div>
        <h2>লগইন করুন</h2>
        <p>অর্ডার দেখতে লগইন করুন</p>
        <Link to="/login" className="btn">লগইন</Link>
      </div>
    );
  }

  return (
    <div className="page-orders">
      {loading && <p className="muted">Loading...</p>}
      {!loading && orders.length === 0 && (
        <div className="empty-cart">
          <div className="empty-icon">📦</div>
          <h2>এখনো কোনো অর্ডার নেই</h2>
          <Link to="/" className="btn">কেনাকাটা শুরু করুন</Link>
        </div>
      )}
      {orders.map((o) => (
        <Link key={o.id} to={'/order/' + o.id} className="order-card">
          <div className="order-head">
            <span className="order-id">#{o.id.slice(-6)}</span>
            <span className={'badge ' + statusClass(o.status)}>{o.status}</span>
          </div>
          <p className="order-date">{formatDate(o.createdAt)}</p>
          <div className="order-foot">
            <span>{o.items ? o.items.length : 0}টি পণ্য</span>
            <strong>{formatBDT(o.total)}</strong>
          </div>
        </Link>
      ))}
    </div>
  );
}
'@

$orderDetail = @'
import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { doc, onSnapshot } from 'firebase/firestore';
import { db } from '../firebase';
import { formatBDT, formatDate, telLink, waLink } from '../utils/format';
import { statusClass } from '../utils/constants';

const TIMELINE = ['Pending', 'Confirmed', 'Processing', 'Out for Delivery', 'Delivered'];

export default function OrderDetail() {
  const { id } = useParams();
  const [order, setOrder] = useState(null);
  const [settings, setSettings] = useState(null);

  useEffect(() => {
    const unsub1 = onSnapshot(doc(db, 'orders', id), (snap) => {
      setOrder(snap.exists() ? Object.assign({ id: snap.id }, snap.data()) : null);
    });
    const unsub2 = onSnapshot(doc(db, 'settings', 'shop'), (snap) => {
      setSettings(snap.exists() ? snap.data() : null);
    });
    return () => { unsub1(); unsub2(); };
  }, [id]);

  if (!order) return <div className="page-loading">Loading...</div>;

  const items = order.items || [];
  const currentStep = TIMELINE.indexOf(order.status);
  const isCancelled = order.status === 'Cancelled';

  return (
    <div className="page-order-detail">
      <div className="order-status-card">
        <div className="order-status-head">
          <h2>অর্ডার #{order.id.slice(-6)}</h2>
          <span className={'badge ' + statusClass(order.status)}>{order.status}</span>
        </div>
        <p className="muted">{formatDate(order.createdAt)}</p>
      </div>

      {!isCancelled && (
        <div className="card">
          <h3>ট্র্যাকিং</h3>
          <div className="timeline">
            {TIMELINE.map((step, i) => (
              <div key={step} className={'timeline-step ' + (i <= currentStep ? 'active' : '')}>
                <div className="timeline-dot">{i <= currentStep ? '✓' : (i + 1)}</div>
                <div className="timeline-label">{step}</div>
              </div>
            ))}
          </div>
        </div>
      )}

      {isCancelled && (
        <div className="card cancelled-card">
          <h3>❌ এই অর্ডার বাতিল করা হয়েছে</h3>
        </div>
      )}

      <div className="card">
        <h3>পণ্য</h3>
        {items.map((it, idx) => (
          <div key={idx} className="summary-row">
            <span>{it.name} × {it.qty}</span>
            <span>{formatBDT(it.price * it.qty)}</span>
          </div>
        ))}
      </div>

      <div className="card">
        <h3>সারসংক্ষেপ</h3>
        <div className="summary-row"><span>সাবটোটাল</span><span>{formatBDT(order.subtotal)}</span></div>
        <div className="summary-row"><span>ডেলিভারি চার্জ</span><span>{formatBDT(order.deliveryCharge)}</span></div>
        <div className="summary-row total-row"><strong>মোট</strong><strong>{formatBDT(order.total)}</strong></div>
      </div>

      <div className="card">
        <h3>ডেলিভারি তথ্য</h3>
        <p><strong>{order.customerName}</strong></p>
        <p>{order.phone}</p>
        <p>{order.address}</p>
        <p className="muted">পেমেন্ট: {order.paymentMethod}</p>
      </div>

      {settings && (
        <div className="contact-shop-btns">
          <a className="btn btn-outline" href={telLink(settings.phone)}>📞 দোকানে কল</a>
          <a className="btn btn-success" target="_blank" rel="noreferrer"
            href={waLink(settings.whatsapp, 'আমার অর্ডার #' + order.id.slice(-6))}>💬 WhatsApp</a>
        </div>
      )}
    </div>
  );
}
'@

Set-Content -Path src\pages\Home.jsx -Value $home -Encoding UTF8
Set-Content -Path src\pages\ProductDetail.jsx -Value $productDetail -Encoding UTF8
Set-Content -Path src\pages\Cart.jsx -Value $cart -Encoding UTF8
Set-Content -Path src\pages\Checkout.jsx -Value $checkout -Encoding UTF8
Set-Content -Path src\pages\Orders.jsx -Value $orders -Encoding UTF8
Set-Content -Path src\pages\OrderDetail.jsx -Value $orderDetail -Encoding UTF8

Write-Host "Done! 6 pages created."