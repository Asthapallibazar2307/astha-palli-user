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
          <div className="avatar">ðŸ‘¤</div>
          <h2>à¦…à¦¤à¦¿à¦¥à¦¿</h2>
          <p className="muted">à¦²à¦—à¦‡à¦¨ à¦•à¦°à§‡ à¦†à¦°à§‹ à¦¸à§à¦¬à¦¿à¦§à¦¾ à¦ªà¦¾à¦¨</p>
        </div>
        <div className="account-menu">
          <Link to="/login" className="menu-item">ðŸ” à¦²à¦—à¦‡à¦¨</Link>
          <Link to="/register" className="menu-item">ðŸ“ à¦°à§‡à¦œà¦¿à¦¸à§à¦Ÿà¦¾à¦°</Link>
          <Link to="/orders" className="menu-item">ðŸ“¦ à¦†à¦®à¦¾à¦° à¦…à¦°à§à¦¡à¦¾à¦°</Link>
          <Link to="/app-info" className="menu-item">â„¹ï¸ App à¦¤à¦¥à§à¦¯</Link>
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
        <div className="avatar">{profile && profile.name ? profile.name.charAt(0) : 'ðŸ‘¤'}</div>
        <h2>{profile && profile.name ? profile.name : 'à¦¬à§à¦¯à¦¬à¦¹à¦¾à¦°à¦•à¦¾à¦°à§€'}</h2>
        <p className="muted">{user.email}</p>
        <p className="muted">{profile && profile.phone ? profile.phone : ''}</p>
      </div>

      {editing ? (
        <div className="card">
          <h3>à¦ªà§à¦°à§‹à¦«à¦¾à¦‡à¦² à¦¸à¦®à§à¦ªà¦¾à¦¦à¦¨à¦¾</h3>
          <div className="form-group"><label>à¦¨à¦¾à¦®</label>
            <input className="input" value={form.name} onChange={(e) => set('name', e.target.value)} /></div>
          <div className="form-group"><label>à¦®à§‹à¦¬à¦¾à¦‡à¦²</label>
            <input className="input" value={form.phone} onChange={(e) => set('phone', e.target.value)} /></div>
          <div className="form-group"><label>à¦ à¦¿à¦•à¦¾à¦¨à¦¾</label>
            <textarea className="textarea" value={form.address} onChange={(e) => set('address', e.target.value)} /></div>
          <div className="flex">
            <button className="btn" onClick={saveEdit}>à¦¸à§‡à¦­</button>
            <button className="btn btn-outline" onClick={() => setEditing(false)}>à¦¬à¦¾à¦¤à¦¿à¦²</button>
          </div>
        </div>
      ) : (
        <div className="account-menu">
          <Link to="/orders" className="menu-item">ðŸ“¦ à¦†à¦®à¦¾à¦° à¦…à¦°à§à¦¡à¦¾à¦°</Link>
          <Link to="/app-info" className="menu-item">â„¹ï¸ App à¦¤à¦¥à§à¦¯</Link>
          <button className="menu-item" onClick={startEdit}>âœï¸ à¦ªà§à¦°à§‹à¦«à¦¾à¦‡à¦² à¦¸à¦®à§à¦ªà¦¾à¦¦à¦¨à¦¾</button>
          <button className="menu-item danger" onClick={logout}>ðŸšª à¦²à¦—à¦†à¦‰à¦Ÿ</button>
        </div>
      )}
    </div>
  );
}
