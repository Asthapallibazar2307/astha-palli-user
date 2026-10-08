$login = @'
import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

export default function Login() {
  const { login } = useAuth();
  const nav = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [err, setErr] = useState('');
  const [loading, setLoading] = useState(false);

  const onSubmit = async (e) => {
    e.preventDefault();
    setErr('');
    setLoading(true);
    try {
      await login(email.trim(), password);
      nav('/account');
    } catch (e) {
      setErr('ইমেইল বা পাসওয়ার্ড ভুল');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="page-login">
      <div className="login-logo">
        <img src="/logo.png" alt="" />
        <h1>আস্থা পল্লী বাজার</h1>
      </div>
      <form onSubmit={onSubmit}>
        {err && <div className="error-msg">{err}</div>}
        <div className="form-group">
          <label>ইমেইল</label>
          <input className="input" type="email" required value={email} onChange={(e) => setEmail(e.target.value)} />
        </div>
        <div className="form-group">
          <label>পাসওয়ার্ড</label>
          <input className="input" type="password" required value={password} onChange={(e) => setPassword(e.target.value)} />
        </div>
        <button className="btn" style={{ width: '100%' }} disabled={loading}>
          {loading ? 'লগইন হচ্ছে...' : 'লগইন'}
        </button>
      </form>
      <p className="auth-switch">নতুন ব্যবহারকারী? <Link to="/register">রেজিস্টার করুন</Link></p>
    </div>
  );
}
'@

$register = @'
import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

export default function Register() {
  const { register } = useAuth();
  const nav = useNavigate();
  const [form, setForm] = useState({ name: '', phone: '', email: '', password: '' });
  const [err, setErr] = useState('');
  const [loading, setLoading] = useState(false);

  const set = (k, v) => setForm((f) => Object.assign({}, f, { [k]: v }));

  const onSubmit = async (e) => {
    e.preventDefault();
    setErr('');
    setLoading(true);
    try {
      await register(form.name.trim(), form.phone.trim(), form.email.trim(), form.password);
      nav('/account');
    } catch (e) {
      setErr(e.message || 'রেজিস্ট্রেশন ব্যর্থ');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="page-login">
      <div className="login-logo">
        <h1>নতুন অ্যাকাউন্ট</h1>
        <p className="muted">রেজিস্ট্রেশন করুন</p>
      </div>
      <form onSubmit={onSubmit}>
        {err && <div className="error-msg">{err}</div>}
        <div className="form-group">
          <label>নাম *</label>
          <input className="input" required value={form.name} onChange={(e) => set('name', e.target.value)} />
        </div>
        <div className="form-group">
          <label>মোবাইল *</label>
          <input className="input" required value={form.phone} onChange={(e) => set('phone', e.target.value)} />
        </div>
        <div className="form-group">
          <label>ইমেইল *</label>
          <input className="input" type="email" required value={form.email} onChange={(e) => set('email', e.target.value)} />
        </div>
        <div className="form-group">
          <label>পাসওয়ার্ড * (কমপক্ষে ৬ অক্ষর)</label>
          <input className="input" type="password" required minLength={6} value={form.password} onChange={(e) => set('password', e.target.value)} />
        </div>
        <button className="btn" style={{ width: '100%' }} disabled={loading}>
          {loading ? 'রেজিস্ট্রেশন হচ্ছে...' : 'রেজিস্টার করুন'}
        </button>
      </form>
      <p className="auth-switch">আগে থেকেই অ্যাকাউন্ট আছে? <Link to="/login">লগইন করুন</Link></p>
    </div>
  );
}
'@

$account = @'
import { useState } from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

export default function Account() {
  const { user, profile, logout, updateProfileData } = useAuth();
  const [editing, setEditing] = useState(false);
  const [form, setForm] = useState({ name: '', phone: '', address: '' });

  if (!user) {
    return (
      <div className="page-account">
        <div className="account-header">
          <div className="avatar">👤</div>
          <h2>অতিথি</h2>
          <p className="muted">লগইন করে আরো সুবিধা পান</p>
        </div>
        <div className="account-menu">
          <Link to="/login" className="menu-item">🔐 লগইন</Link>
          <Link to="/register" className="menu-item">📝 রেজিস্টার</Link>
          <Link to="/orders" className="menu-item">📦 আমার অর্ডার</Link>
          <Link to="/app-info" className="menu-item">ℹ️ App তথ্য</Link>
        </div>
      </div>
    );
  }

  const startEdit = () => {
    setForm({
      name: profile && profile.name ? profile.name : '',
      phone: profile && profile.phone ? profile.phone : '',
      address: profile && profile.address ? profile.address : ''
    });
    setEditing(true);
  };

  const saveEdit = async () => {
    await updateProfileData(form);
    setEditing(false);
  };

  const set = (k, v) => setForm((f) => Object.assign({}, f, { [k]: v }));

  return (
    <div className="page-account">
      <div className="account-header">
        <div className="avatar">{profile && profile.name ? profile.name.charAt(0) : '👤'}</div>
        <h2>{profile && profile.name ? profile.name : 'ব্যবহারকারী'}</h2>
        <p className="muted">{user.email}</p>
        <p className="muted">{profile && profile.phone ? profile.phone : ''}</p>
      </div>

      {editing ? (
        <div className="card">
          <h3>প্রোফাইল সম্পাদনা</h3>
          <div className="form-group"><label>নাম</label>
            <input className="input" value={form.name} onChange={(e) => set('name', e.target.value)} /></div>
          <div className="form-group"><label>মোবাইল</label>
            <input className="input" value={form.phone} onChange={(e) => set('phone', e.target.value)} /></div>
          <div className="form-group"><label>ঠিকানা</label>
            <textarea className="textarea" value={form.address} onChange={(e) => set('address', e.target.value)} /></div>
          <div className="flex">
            <button className="btn" onClick={saveEdit}>সেভ</button>
            <button className="btn btn-outline" onClick={() => setEditing(false)}>বাতিল</button>
          </div>
        </div>
      ) : (
        <div className="account-menu">
          <Link to="/orders" className="menu-item">📦 আমার অর্ডার</Link>
          <Link to="/app-info" className="menu-item">ℹ️ App তথ্য</Link>
          <button className="menu-item" onClick={startEdit}>✏️ প্রোফাইল সম্পাদনা</button>
          <button className="menu-item danger" onClick={logout}>🚪 লগআউট</button>
        </div>
      )}
    </div>
  );
}
'@

$appInfo = @'
import { useEffect, useState } from 'react';
import { doc, onSnapshot } from 'firebase/firestore';
import { db } from '../firebase';
import { telLink, waLink } from '../utils/format';

export default function AppInfo() {
  const [settings, setSettings] = useState(null);

  useEffect(() => {
    return onSnapshot(doc(db, 'settings', 'shop'), (snap) => {
      setSettings(snap.exists() ? snap.data() : null);
    });
  }, []);

  const s = settings || {
    shopName: 'আস্থা পল্লী বাজার',
    shopNameEn: 'ASTHA PALLI BAZAR SUPER SHOP',
    phone: '01717978511',
    whatsapp: '01717978511',
    email: 'asthapallibazar2307@gmail.com',
    address: 'মহারাজপুর বাজার, নবাবগঞ্জ, দিনাজপুর',
    ceo: 'Shafiqul Islam',
    openingHours: '08:00',
    closingHours: '22:00',
    description: 'আস্থা পল্লী বাজার - Your trusted super shop.'
  };

  return (
    <div className="page-info">
      <div className="info-header">
        <img src={s.logoUrl || '/logo.png'} alt="" className="info-logo" />
        <h1>{s.shopName}</h1>
        <p className="muted">{s.shopNameEn}</p>
      </div>

      <div className="card">
        <h3>দোকান তথ্য</h3>
        <div className="info-row"><span>CEO / MD</span><strong>{s.ceo}</strong></div>
        <div className="info-row"><span>ঠিকানা</span><strong>{s.address}</strong></div>
        <div className="info-row"><span>খোলা</span><strong>{s.openingHours} - {s.closingHours}</strong></div>
      </div>

      <div className="card">
        <h3>যোগাযোগ</h3>
        <div className="info-row"><span>ফোন</span><strong>{s.phone}</strong></div>
        <div className="info-row"><span>WhatsApp</span><strong>{s.whatsapp}</strong></div>
        <div className="info-row"><span>ইমেইল</span><strong>{s.email}</strong></div>
      </div>

      <div className="contact-shop-btns">
        <a className="btn btn-outline" href={telLink(s.phone)}>📞 কল করুন</a>
        <a className="btn btn-success" target="_blank" rel="noreferrer" href={waLink(s.whatsapp)}>💬 WhatsApp</a>
      </div>

      <div className="card description-card">
        <h3>বিবরণ</h3>
        <p>{s.description}</p>
      </div>

      <p className="muted" style={{ textAlign: 'center', marginTop: 20 }}>
        Version 1.0.0
      </p>
    </div>
  );
}
'@

$search = @'
import { useState } from 'react';
import { useCollection } from '../hooks/useCollection';
import ProductCard from '../components/ProductCard';

export default function Search() {
  const { data: products, loading } = useCollection('products', { orderByField: 'createdAt' });
  const [q, setQ] = useState('');

  const filtered = q.trim() ? products.filter((p) =>
    p.name.toLowerCase().includes(q.toLowerCase()) && p.enabled !== false
  ) : [];

  return (
    <div className="page-search">
      <div className="search-box">
        <input className="input" placeholder="পণ্য খুঁজুন..." autoFocus
          value={q} onChange={(e) => setQ(e.target.value)} />
      </div>

      {loading && <p className="muted">Loading...</p>}
      {!loading && q && filtered.length === 0 && (
        <p className="muted" style={{ textAlign: 'center', padding: 40 }}>কোনো পণ্য পাওয়া যায়নি</p>
      )}
      {!q && <p className="muted" style={{ textAlign: 'center', padding: 40 }}>কিছু লিখুন খুঁজতে</p>}

      <div className="grid-products">
        {filtered.map((p) => <ProductCard key={p.id} product={p} />)}
      </div>
    </div>
  );
}
'@

$categoryPage = @'
import { useParams } from 'react-router-dom';
import { useCollection } from '../hooks/useCollection';
import ProductCard from '../components/ProductCard';

export default function CategoryPage() {
  const { id } = useParams();
  const { data: products, loading } = useCollection('products', { orderByField: 'createdAt' });
  const { data: categories } = useCollection('categories');
  const cat = categories.find((c) => c.id === id);
  const filtered = products.filter((p) => p.category === (cat ? cat.name : '') && p.enabled !== false);

  return (
    <div className="page-category">
      <h1 className="page-title">{cat ? cat.name : 'ক্যাটাগরি'}</h1>
      {loading && <p className="muted">Loading...</p>}
      {!loading && filtered.length === 0 && <p className="muted" style={{ textAlign: 'center', padding: 40 }}>এই ক্যাটাগরিতে কোনো পণ্য নেই</p>}
      <div className="grid-products">
        {filtered.map((p) => <ProductCard key={p.id} product={p} />)}
      </div>
    </div>
  );
}
'@

$offers = @'
import { useCollection } from '../hooks/useCollection';
import ProductCard from '../components/ProductCard';

export default function Offers() {
  const { data: products, loading } = useCollection('products', { orderByField: 'createdAt' });
  const offers = products.filter((p) => p.todaysOffer && p.enabled !== false);

  return (
    <div className="page-offers">
      <h1 className="page-title">🔥 আজকের অফার</h1>
      {loading && <p className="muted">Loading...</p>}
      {!loading && offers.length === 0 && <p className="muted" style={{ textAlign: 'center', padding: 40 }}>এখনো কোনো অফার নেই</p>}
      <div className="grid-products">
        {offers.map((p) => <ProductCard key={p.id} product={p} />)}
      </div>
    </div>
  );
}
'@

Set-Content -Path src\pages\Login.jsx -Value $login -Encoding UTF8
Set-Content -Path src\pages\Register.jsx -Value $register -Encoding UTF8
Set-Content -Path src\pages\Account.jsx -Value $account -Encoding UTF8
Set-Content -Path src\pages\AppInfo.jsx -Value $appInfo -Encoding UTF8
Set-Content -Path src\pages\Search.jsx -Value $search -Encoding UTF8
Set-Content -Path src\pages\CategoryPage.jsx -Value $categoryPage -Encoding UTF8
Set-Content -Path src\pages\Offers.jsx -Value $offers -Encoding UTF8

Write-Host "Done! 7 pages created."
Get-ChildItem src\pages -Name