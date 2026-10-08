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
      setErr('à¦‡à¦®à§‡à¦‡à¦² à¦¬à¦¾ à¦ªà¦¾à¦¸à¦“à¦¯à¦¼à¦¾à¦°à§à¦¡ à¦­à§à¦²');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="page-login">
      <div className="login-logo">
        <img src="/logo.png" alt="" />
        <h1>à¦†à¦¸à§à¦¥à¦¾ à¦ªà¦²à§à¦²à§€ à¦¬à¦¾à¦œà¦¾à¦°</h1>
      </div>
      <form onSubmit={onSubmit}>
        {err && <div className="error-msg">{err}</div>}
        <div className="form-group">
          <label>à¦‡à¦®à§‡à¦‡à¦²</label>
          <input className="input" type="email" required value={email} onChange={(e) => setEmail(e.target.value)} />
        </div>
        <div className="form-group">
          <label>à¦ªà¦¾à¦¸à¦“à¦¯à¦¼à¦¾à¦°à§à¦¡</label>
          <input className="input" type="password" required value={password} onChange={(e) => setPassword(e.target.value)} />
        </div>
        <button className="btn" style={{ width: '100%' }} disabled={loading}>
          {loading ? 'à¦²à¦—à¦‡à¦¨ à¦¹à¦šà§à¦›à§‡...' : 'à¦²à¦—à¦‡à¦¨'}
        </button>
      </form>
      <p className="auth-switch">à¦¨à¦¤à§à¦¨ à¦¬à§à¦¯à¦¬à¦¹à¦¾à¦°à¦•à¦¾à¦°à§€? <Link to="/register">à¦°à§‡à¦œà¦¿à¦¸à§à¦Ÿà¦¾à¦° à¦•à¦°à§à¦¨</Link></p>
    </div>
  );
}
