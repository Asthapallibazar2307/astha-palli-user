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
      setErr(e.message || 'à¦°à§‡à¦œà¦¿à¦¸à§à¦Ÿà§à¦°à§‡à¦¶à¦¨ à¦¬à§à¦¯à¦°à§à¦¥');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="page-login">
      <div className="login-logo">
        <h1>à¦¨à¦¤à§à¦¨ à¦…à§à¦¯à¦¾à¦•à¦¾à¦‰à¦¨à§à¦Ÿ</h1>
        <p className="muted">à¦°à§‡à¦œà¦¿à¦¸à§à¦Ÿà§à¦°à§‡à¦¶à¦¨ à¦•à¦°à§à¦¨</p>
      </div>
      <form onSubmit={onSubmit}>
        {err && <div className="error-msg">{err}</div>}
        <div className="form-group">
          <label>à¦¨à¦¾à¦® *</label>
          <input className="input" required value={form.name} onChange={(e) => set('name', e.target.value)} />
        </div>
        <div className="form-group">
          <label>à¦®à§‹à¦¬à¦¾à¦‡à¦² *</label>
          <input className="input" required value={form.phone} onChange={(e) => set('phone', e.target.value)} />
        </div>
        <div className="form-group">
          <label>à¦‡à¦®à§‡à¦‡à¦² *</label>
          <input className="input" type="email" required value={form.email} onChange={(e) => set('email', e.target.value)} />
        </div>
        <div className="form-group">
          <label>à¦ªà¦¾à¦¸à¦“à¦¯à¦¼à¦¾à¦°à§à¦¡ * (à¦•à¦®à¦ªà¦•à§à¦·à§‡ à§¬ à¦…à¦•à§à¦·à¦°)</label>
          <input className="input" type="password" required minLength={6} value={form.password} onChange={(e) => set('password', e.target.value)} />
        </div>
        <button className="btn" style={{ width: '100%' }} disabled={loading}>
          {loading ? 'à¦°à§‡à¦œà¦¿à¦¸à§à¦Ÿà§à¦°à§‡à¦¶à¦¨ à¦¹à¦šà§à¦›à§‡...' : 'à¦°à§‡à¦œà¦¿à¦¸à§à¦Ÿà¦¾à¦° à¦•à¦°à§à¦¨'}
        </button>
      </form>
      <p className="auth-switch">à¦†à¦—à§‡ à¦¥à§‡à¦•à§‡à¦‡ à¦…à§à¦¯à¦¾à¦•à¦¾à¦‰à¦¨à§à¦Ÿ à¦†à¦›à§‡? <Link to="/login">à¦²à¦—à¦‡à¦¨ à¦•à¦°à§à¦¨</Link></p>
    </div>
  );
}







































