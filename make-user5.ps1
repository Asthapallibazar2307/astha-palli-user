$appJsx = @'
import { Routes, Route, Navigate } from 'react-router-dom';
import Header from './components/Header';
import BottomBar from './components/BottomBar';
import Home from './pages/Home';
import ProductDetail from './pages/ProductDetail';
import Cart from './pages/Cart';
import Checkout from './pages/Checkout';
import Orders from './pages/Orders';
import OrderDetail from './pages/OrderDetail';
import Account from './pages/Account';
import Login from './pages/Login';
import Register from './pages/Register';
import AppInfo from './pages/AppInfo';
import Search from './pages/Search';
import CategoryPage from './pages/CategoryPage';
import Offers from './pages/Offers';

function AppShell({ title, showBack, showSearch, children }) {
  return (
    <>
      <Header title={title} showBack={showBack} showSearch={showSearch} />
      <main className="app-content">{children}</main>
      <BottomBar />
    </>
  );
}

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<AppShell title="আস্থা পল্লী বাজার" showSearch={true}><Home /></AppShell>} />
      <Route path="/product/:id" element={<AppShell title="পণ্য" showBack={true}><ProductDetail /></AppShell>} />
      <Route path="/cart" element={<AppShell title="কার্ট"><Cart /></AppShell>} />
      <Route path="/checkout" element={<AppShell title="চেকআউট" showBack={true}><Checkout /></AppShell>} />
      <Route path="/orders" element={<AppShell title="আমার অর্ডার"><Orders /></AppShell>} />
      <Route path="/order/:id" element={<AppShell title="অর্ডার" showBack={true}><OrderDetail /></AppShell>} />
      <Route path="/account" element={<AppShell title="একাউন্ট"><Account /></AppShell>} />
      <Route path="/login" element={<AppShell title="লগইন" showBack={true}><Login /></AppShell>} />
      <Route path="/register" element={<AppShell title="রেজিস্টার" showBack={true}><Register /></AppShell>} />
      <Route path="/app-info" element={<AppShell title="App তথ্য" showBack={true}><AppInfo /></AppShell>} />
      <Route path="/search" element={<AppShell title="সার্চ" showBack={true}><Search /></AppShell>} />
      <Route path="/category/:id" element={<AppShell title="ক্যাটাগরি" showBack={true}><CategoryPage /></AppShell>} />
      <Route path="/offers" element={<AppShell title="আজকের অফার" showBack={true}><Offers /></AppShell>} />
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}
'@

$mainJsx = @'
import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import App from './App.jsx';
import { AuthProvider } from './context/AuthContext.jsx';
import { CartProvider } from './context/CartContext.jsx';
import './index.css';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <BrowserRouter>
      <AuthProvider>
        <CartProvider>
          <App />
        </CartProvider>
      </AuthProvider>
    </BrowserRouter>
  </React.StrictMode>
);
'@

$indexCss = @'
:root {
  --primary: #0f766e;
  --primary-dark: #0d5d57;
  --primary-light: #14b8a6;
  --bg: #f8fafc;
  --card: #ffffff;
  --text: #0f172a;
  --muted: #64748b;
  --border: #e2e8f0;
  --danger: #dc2626;
  --success: #16a34a;
  --warning: #f59e0b;
  --radius: 12px;
}
* { box-sizing: border-box; }
html, body, #root { height: 100%; margin: 0; }
body { font-family: 'Segoe UI', 'Noto Sans Bengali', system-ui, sans-serif; background: var(--bg); color: var(--text); }
a { color: inherit; text-decoration: none; }
button { font-family: inherit; cursor: pointer; border: none; }
input, textarea, select { font-family: inherit; }

.btn { display: inline-flex; align-items: center; justify-content: center; gap: 6px; padding: 12px 20px; border-radius: 10px; font-weight: 600; font-size: 15px; background: var(--primary); color: #fff; }
.btn:hover { background: var(--primary-dark); }
.btn-outline { background: #fff; color: var(--text); border: 1px solid var(--border); }
.btn-outline:hover { background: #f1f5f9; }
.btn-success { background: var(--success); color: #fff; }
.btn:disabled { opacity: .6; cursor: not-allowed; }

.form-group { margin-bottom: 14px; }
.form-group label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 6px; }
.input, .textarea { width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 10px; font-size: 15px; background: #fff; }
.input:focus, .textarea:focus { outline: none; border-color: var(--primary); }
.textarea { min-height: 90px; resize: vertical; }

.card { background: var(--card); border-radius: var(--radius); padding: 16px; margin-bottom: 12px; box-shadow: 0 1px 3px rgba(0,0,0,.05); }
.card h2, .card h3 { margin-top: 0; }

.badge { display: inline-block; padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 600; }
.badge-pending { background: #fef3c7; color: #92400e; }
.badge-confirmed { background: #dbeafe; color: #1e40af; }
.badge-processing { background: #ede9fe; color: #5b21b6; }
.badge-out-for-delivery { background: #cffafe; color: #155e75; }
.badge-delivered { background: #dcfce7; color: #166534; }
.badge-cancelled { background: #fee2e2; color: #991b1b; }

.app-header { position: sticky; top: 0; z-index: 50; background: #fff; border-bottom: 1px solid var(--border); padding: 10px 14px; display: flex; align-items: center; gap: 10px; }
.header-left, .header-right { width: 40px; display: flex; align-items: center; }
.header-right { justify-content: flex-end; }
.header-logo img { width: 34px; height: 34px; object-fit: contain; border-radius: 6px; }
.header-title { flex: 1; text-align: center; font-size: 16px; font-weight: 700; margin: 0; }
.icon-btn { background: none; font-size: 20px; padding: 6px; border-radius: 8px; width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; }

.app-content { padding: 12px; padding-bottom: 80px; }

.bottombar { position: fixed; bottom: 0; left: 0; right: 0; z-index: 60; background: #fff; border-top: 1px solid var(--border); display: flex; padding: 6px 0; padding-bottom: max(6px, env(safe-area-inset-bottom)); }
.bottombar a { flex: 1; display: flex; flex-direction: column; align-items: center; gap: 2px; padding: 6px; font-size: 11px; color: var(--muted); position: relative; }
.bottombar a.active { color: var(--primary); }
.nav-icon { font-size: 20px; position: relative; }
.nav-label { font-size: 11px; font-weight: 600; }
.cart-badge { position: absolute; top: -4px; right: -8px; background: var(--danger); color: #fff; font-size: 10px; border-radius: 999px; padding: 1px 5px; font-weight: 700; }

.banner { position: relative; border-radius: var(--radius); overflow: hidden; margin-bottom: 14px; min-height: 160px; background: linear-gradient(135deg, #0f766e, #14b8a6); color: #fff; }
.banner-img { width: 100%; height: 200px; object-fit: cover; display: block; }
.banner-overlay { position: absolute; left: 0; right: 0; bottom: 0; padding: 16px; background: linear-gradient(transparent, rgba(0,0,0,.7)); }
.banner-overlay h2 { margin: 0 0 4px; font-size: 20px; }
.banner-overlay p { margin: 0; font-size: 13px; opacity: .95; }
.banner-offer { display: inline-block; margin-top: 6px; background: #f59e0b; color: #fff; padding: 3px 10px; border-radius: 999px; font-size: 12px; font-weight: 700; }
.banner-welcome { padding: 30px 20px; text-align: center; display: flex; flex-direction: column; justify-content: center; }
.banner-welcome h2 { margin: 0 0 8px; }

.section { margin-bottom: 20px; }
.section-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; }
.section-head h2 { margin: 0; font-size: 17px; }
.see-all { font-size: 13px; color: var(--primary); font-weight: 600; }

.h-scroll { display: flex; gap: 12px; overflow-x: auto; padding-bottom: 4px; scrollbar-width: none; }
.h-scroll::-webkit-scrollbar { display: none; }
.h-scroll .product-card { min-width: 150px; max-width: 150px; }

.cat-scroll { display: flex; gap: 10px; overflow-x: auto; padding-bottom: 4px; }
.cat-scroll::-webkit-scrollbar { display: none; }
.cat-chip { display: flex; flex-direction: column; align-items: center; gap: 6px; min-width: 80px; padding: 10px 8px; background: #fff; border-radius: 10px; }
.cat-chip-img { width: 50px; height: 50px; object-fit: cover; border-radius: 50%; }
.cat-chip-emoji { width: 50px; height: 50px; display: flex; align-items: center; justify-content: center; font-size: 26px; background: #e2e8f0; border-radius: 50%; }
.cat-chip-name { font-size: 11px; text-align: center; font-weight: 600; }

.grid-products { display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px; }
@media (min-width: 640px) { .grid-products { grid-template-columns: repeat(3, 1fr); } }
@media (min-width: 900px) { .grid-products { grid-template-columns: repeat(4, 1fr); } }

.product-card { background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,.05); display: flex; flex-direction: column; }
.product-img-wrap { position: relative; width: 100%; aspect-ratio: 1; background: #f1f5f9; }
.product-img { width: 100%; height: 100%; object-fit: cover; }
.product-img.placeholder { display: flex; align-items: center; justify-content: center; font-size: 40px; }
.discount-badge { position: absolute; top: 6px; left: 6px; background: var(--danger); color: #fff; padding: 2px 8px; border-radius: 999px; font-size: 11px; font-weight: 700; }
.discount-badge-lg { position: absolute; top: 14px; left: 14px; background: var(--danger); color: #fff; padding: 6px 14px; border-radius: 999px; font-size: 14px; font-weight: 700; }
.stock-out { position: absolute; inset: 0; background: rgba(0,0,0,.55); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 13px; }
.product-info { padding: 10px; }
.product-name { margin: 0 0 6px; font-size: 13px; font-weight: 600; line-height: 1.3; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; min-height: 34px; }
.product-price { display: flex; gap: 6px; align-items: baseline; flex-wrap: wrap; }
.price-final { font-size: 15px; font-weight: 700; color: var(--primary); }
.price-old { font-size: 12px; color: var(--muted); text-decoration: line-through; }
.price-final-lg { font-size: 26px; font-weight: 800; color: var(--primary); }
.price-old-lg { font-size: 16px; color: var(--muted); text-decoration: line-through; }

.product-hero { width: 100%; aspect-ratio: 1; background: #f1f5f9; position: relative; }
.product-hero img { width: 100%; height: 100%; object-fit: cover; }
.product-hero .placeholder { display: flex; align-items: center; justify-content: center; font-size: 80px; }
.product-body { padding: 16px; }
.product-body h1 { font-size: 20px; margin: 0 0 6px; }
.product-cat { color: var(--muted); font-size: 13px; margin: 0 0 10px; }
.product-price-row { display: flex; gap: 10px; align-items: baseline; margin-bottom: 10px; }
.stock-status { padding: 8px 12px; border-radius: 8px; font-size: 13px; font-weight: 600; margin-bottom: 12px; }
.stock-status.in { background: #dcfce7; color: #166534; }
.stock-status.out { background: #fee2e2; color: #991b1b; }
.product-desc { margin-bottom: 16px; }
.product-desc h3 { font-size: 14px; margin: 0 0 6px; color: var(--muted); }

.qty-selector { display: inline-flex; align-items: center; border: 1px solid var(--border); border-radius: 10px; margin-bottom: 14px; }
.qty-selector button { background: #fff; width: 44px; height: 44px; font-size: 22px; font-weight: 600; color: var(--primary); }
.qty-selector span { width: 50px; text-align: center; font-weight: 700; font-size: 16px; }

.qty-selector-sm { display: inline-flex; align-items: center; border: 1px solid var(--border); border-radius: 8px; margin-top: 6px; }
.qty-selector-sm button { background: #fff; width: 32px; height: 32px; font-size: 18px; color: var(--primary); }
.qty-selector-sm span { width: 36px; text-align: center; font-weight: 700; font-size: 14px; }

.product-actions { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }

.cart-items { display: flex; flex-direction: column; gap: 10px; margin-bottom: 130px; }
.cart-item { display: flex; gap: 12px; background: #fff; padding: 10px; border-radius: 10px; }
.cart-item-img { width: 80px; height: 80px; object-fit: cover; border-radius: 8px; background: #f1f5f9; }
.cart-item-img.placeholder { display: flex; align-items: center; justify-content: center; font-size: 30px; }
.cart-item-info { flex: 1; min-width: 0; }
.cart-item-info h3 { margin: 0 0 4px; font-size: 14px; line-height: 1.3; }
.cart-item-price { margin: 0; font-size: 13px; color: var(--primary); font-weight: 600; }
.cart-item-right { display: flex; flex-direction: column; align-items: flex-end; justify-content: space-between; }
.cart-item-total { margin: 0; font-weight: 700; font-size: 14px; }
.remove-btn { background: none; color: var(--danger); font-size: 18px; padding: 4px; }

.cart-footer { position: fixed; bottom: 60px; left: 0; right: 0; background: #fff; padding: 12px; border-top: 1px solid var(--border); box-shadow: 0 -2px 8px rgba(0,0,0,.05); }
.cart-total-row { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 15px; }
.clear-cart-btn { width: 100%; margin-top: 8px; background: none; color: var(--danger); font-weight: 600; padding: 8px; font-size: 13px; }

.empty-cart { text-align: center; padding: 60px 20px; }
.empty-icon { font-size: 64px; margin-bottom: 16px; }
.empty-cart h2 { margin: 0 0 8px; font-size: 18px; }
.empty-cart p { color: var(--muted); margin: 0 0 20px; }

.summary-row { display: flex; justify-content: space-between; padding: 6px 0; font-size: 14px; }
.summary-row.total-row { border-top: 1px solid var(--border); margin-top: 6px; padding-top: 10px; font-size: 16px; }

.payment-card .payment-option { display: flex; align-items: center; gap: 10px; padding: 12px; background: #f1f5f9; border-radius: 10px; font-weight: 600; }
.payment-option .radio-on { color: var(--primary); font-size: 18px; }

.place-order-btn { width: 100%; margin-bottom: 20px; padding: 16px; font-size: 16px; }

.page-orders { display: flex; flex-direction: column; gap: 10px; }
.order-card { display: block; background: #fff; padding: 12px; border-radius: 10px; }
.order-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px; }
.order-id { font-weight: 700; font-size: 15px; }
.order-date { margin: 0 0 8px; font-size: 12px; color: var(--muted); }
.order-foot { display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--border); padding-top: 8px; }

.order-status-card { background: linear-gradient(135deg, #0f766e, #14b8a6); color: #fff; border-radius: var(--radius); padding: 16px; margin-bottom: 12px; }
.order-status-card .muted { color: rgba(255,255,255,.85); }
.order-status-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px; }
.order-status-head h2 { margin: 0; font-size: 18px; }
.order-status-card .badge { background: rgba(255,255,255,.25); color: #fff; }

.cancelled-card { background: #fee2e2; border: 1px solid #fecaca; }
.cancelled-card h3 { color: #991b1b; margin: 0; }

.timeline { position: relative; }
.timeline-step { display: flex; align-items: center; gap: 12px; padding: 8px 0; opacity: .45; }
.timeline-step.active { opacity: 1; }
.timeline-dot { width: 28px; height: 28px; border-radius: 50%; background: #e2e8f0; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 700; color: var(--muted); flex-shrink: 0; }
.timeline-step.active .timeline-dot { background: var(--primary); color: #fff; }
.timeline-label { font-size: 14px; font-weight: 600; }
.timeline-step:not(:last-child) { position: relative; }
.timeline-step:not(:last-child)::before { content: ''; position: absolute; left: 14px; top: 36px; bottom: -8px; width: 2px; background: #e2e8f0; }
.timeline-step.active:not(:last-child)::before { background: var(--primary); }

.contact-shop-btns { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 20px; }

.page-login { padding: 20px; max-width: 400px; margin: 0 auto; }
.login-logo { text-align: center; margin-bottom: 24px; }
.login-logo img { width: 80px; height: 80px; object-fit: contain; margin-bottom: 10px; }
.login-logo h1 { font-size: 22px; margin: 0 0 4px; }
.auth-switch { text-align: center; margin-top: 20px; font-size: 14px; color: var(--muted); }
.auth-switch a { color: var(--primary); font-weight: 600; }

.page-account { padding: 12px; }
.account-header { text-align: center; margin-bottom: 20px; padding: 20px; background: #fff; border-radius: var(--radius); }
.avatar { width: 80px; height: 80px; border-radius: 50%; background: var(--primary); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 36px; font-weight: 700; margin: 0 auto 12px; }
.account-header h2 { margin: 0 0 4px; font-size: 20px; }
.account-menu { display: flex; flex-direction: column; gap: 1px; background: #fff; border-radius: var(--radius); overflow: hidden; }
.menu-item { display: flex; align-items: center; gap: 12px; padding: 16px; font-size: 15px; font-weight: 500; text-align: left; background: #fff; border: none; width: 100%; }
.menu-item:hover { background: #f8fafc; }
.menu-item.danger { color: var(--danger); }

.page-info { padding: 12px; }
.info-header { text-align: center; margin-bottom: 20px; padding: 20px; background: linear-gradient(135deg, #0f766e, #14b8a6); color: #fff; border-radius: var(--radius); }
.info-logo { width: 80px; height: 80px; object-fit: contain; background: #fff; border-radius: 50%; padding: 8px; margin-bottom: 12px; }
.info-header h1 { margin: 0 0 4px; font-size: 22px; }
.info-header .muted { color: rgba(255,255,255,.85); margin: 0; }
.info-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid var(--border); font-size: 14px; }
.info-row:last-child { border-bottom: none; }
.info-row span { color: var(--muted); }

.page-search { padding: 12px; }
.search-box { margin-bottom: 16px; }
.page-title { font-size: 20px; margin: 0 0 16px; }

.page-loading { padding: 40px; text-align: center; color: var(--muted); }

.muted { color: var(--muted); font-size: 13px; }
.error-msg { background: #fee2e2; color: #991b1b; padding: 10px; border-radius: 8px; font-size: 13px; margin-bottom: 12px; }
.flex { display: flex; gap: 8px; align-items: center; }
'@

Set-Content -Path src\App.jsx -Value $appJsx -Encoding UTF8
Set-Content -Path src\main.jsx -Value $mainJsx -Encoding UTF8
Set-Content -Path src\index.css -Value $indexCss -Encoding UTF8

if (Test-Path src\App.css) { Remove-Item src\App.css -Force }

Write-Host "Done! App.jsx, main.jsx, index.css created."