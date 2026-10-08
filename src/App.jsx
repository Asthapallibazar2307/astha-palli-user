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
      <Route path="/" element={<AppShell title="Astha Palli Bazar" showSearch={true}><Home /></AppShell>} />
      <Route path="/product/:id" element={<AppShell title="Product" showBack={true}><ProductDetail /></AppShell>} />
      <Route path="/cart" element={<AppShell title="Cart"><Cart /></AppShell>} />
      <Route path="/checkout" element={<AppShell title="Checkout" showBack={true}><Checkout /></AppShell>} />
      <Route path="/orders" element={<AppShell title="My Orders"><Orders /></AppShell>} />
      <Route path="/order/:id" element={<AppShell title="Order" showBack={true}><OrderDetail /></AppShell>} />
      <Route path="/account" element={<AppShell title="Account"><Account /></AppShell>} />
      <Route path="/login" element={<AppShell title="Login" showBack={true}><Login /></AppShell>} />
      <Route path="/register" element={<AppShell title="Register" showBack={true}><Register /></AppShell>} />
      <Route path="/app-info" element={<AppShell title="App Info" showBack={true}><AppInfo /></AppShell>} />
      <Route path="/search" element={<AppShell title="Search" showBack={true}><Search /></AppShell>} />
      <Route path="/category/:id" element={<AppShell title="Category" showBack={true}><CategoryPage /></AppShell>} />
      <Route path="/offers" element={<AppShell title="Today Offers" showBack={true}><Offers /></AppShell>} />
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}