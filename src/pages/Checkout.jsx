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
    return <div className="page-loading">à¦•à¦¾à¦°à§à¦Ÿ à¦–à¦¾à¦²à¦¿</div>;
  }

  const placeOrder = async () => {
    if (!name.trim() || !phone.trim() || !address.trim()) {
      setErr('à¦¸à¦¬ à¦¤à¦¥à§à¦¯ à¦ªà§‚à¦°à¦£ à¦•à¦°à§à¦¨');
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
      setErr('Order à¦¦à¦¿à¦¤à§‡ à¦¸à¦®à¦¸à§à¦¯à¦¾ à¦¹à¦¯à¦¼à§‡à¦›à§‡: ' + e.message);
    } finally {
      setPlacing(false);
    }
  };

  return (
    <div className="page-checkout">
      <div className="card">
        <h2>à¦¡à§‡à¦²à¦¿à¦­à¦¾à¦°à¦¿ à¦¤à¦¥à§à¦¯</h2>
        {err && <div className="error-msg">{err}</div>}
        <div className="form-group">
          <label>à¦¨à¦¾à¦® *</label>
          <input className="input" value={name} onChange={(e) => setName(e.target.value)} />
        </div>
        <div className="form-group">
          <label>à¦®à§‹à¦¬à¦¾à¦‡à¦² *</label>
          <input className="input" value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="01XXXXXXXXX" />
        </div>
        <div className="form-group">
          <label>à¦ à¦¿à¦•à¦¾à¦¨à¦¾ *</label>
          <textarea className="textarea" value={address} onChange={(e) => setAddress(e.target.value)} />
        </div>
        <div className="form-group">
          <label>à¦¨à§‹à¦Ÿ (à¦…à¦ªà¦¶à¦¨à¦¾à¦²)</label>
          <input className="input" value={notes} onChange={(e) => setNotes(e.target.value)} />
        </div>
      </div>

      <div className="card">
        <h2>à¦…à¦°à§à¦¡à¦¾à¦° à¦¸à¦¾à¦°à¦¸à¦‚à¦•à§à¦·à§‡à¦ª</h2>
        {items.map((it) => (
          <div key={it.id} className="summary-row">
            <span>{it.name} Ã— {it.qty}</span>
            <span>{formatBDT(it.price * it.qty)}</span>
          </div>
        ))}
        <div className="summary-row" style={{ borderTop: '1px solid #e2e8f0', paddingTop: 8, marginTop: 8 }}>
          <strong>à¦¸à¦¾à¦¬à¦Ÿà§‹à¦Ÿà¦¾à¦²</strong>
          <strong>{formatBDT(subtotal)}</strong>
        </div>
        <p className="muted" style={{ fontSize: 12 }}>à¦¡à§‡à¦²à¦¿à¦­à¦¾à¦°à¦¿ à¦šà¦¾à¦°à§à¦œ à¦šà§‡à¦•à¦†à¦‰à¦Ÿà§‡ à¦¯à§‹à¦— à¦¹à¦¬à§‡</p>
      </div>

      <div className="card payment-card">
        <h2>à¦ªà§‡à¦®à§‡à¦¨à§à¦Ÿ</h2>
        <div className="payment-option active">
          <span className="radio-on">â—</span>
          <span>à¦•à§à¦¯à¦¾à¦¶ à¦…à¦¨ à¦¡à§‡à¦²à¦¿à¦­à¦¾à¦°à¦¿</span>
        </div>
      </div>

      <button className="btn place-order-btn" disabled={placing} onClick={placeOrder}>
        {placing ? 'à¦…à¦°à§à¦¡à¦¾à¦° à¦¹à¦šà§à¦›à§‡...' : 'à¦…à¦°à§à¦¡à¦¾à¦° à¦•à¦°à§à¦¨'}
      </button>
    </div>
  );
}







































