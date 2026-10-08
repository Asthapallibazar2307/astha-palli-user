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
          <h2>à¦…à¦°à§à¦¡à¦¾à¦° #{order.id.slice(-6)}</h2>
          <span className={'badge ' + statusClass(order.status)}>{order.status}</span>
        </div>
        <p className="muted">{formatDate(order.createdAt)}</p>
      </div>

      {!isCancelled && (
        <div className="card">
          <h3>à¦Ÿà§à¦°à§à¦¯à¦¾à¦•à¦¿à¦‚</h3>
          <div className="timeline">
            {TIMELINE.map((step, i) => (
              <div key={step} className={'timeline-step ' + (i <= currentStep ? 'active' : '')}>
                <div className="timeline-dot">{i <= currentStep ? 'âœ“' : (i + 1)}</div>
                <div className="timeline-label">{step}</div>
              </div>
            ))}
          </div>
        </div>
      )}

      {isCancelled && (
        <div className="card cancelled-card">
          <h3>âŒ à¦à¦‡ à¦…à¦°à§à¦¡à¦¾à¦° à¦¬à¦¾à¦¤à¦¿à¦² à¦•à¦°à¦¾ à¦¹à¦¯à¦¼à§‡à¦›à§‡</h3>
        </div>
      )}

      <div className="card">
        <h3>à¦ªà¦£à§à¦¯</h3>
        {items.map((it, idx) => (
          <div key={idx} className="summary-row">
            <span>{it.name} Ã— {it.qty}</span>
            <span>{formatBDT(it.price * it.qty)}</span>
          </div>
        ))}
      </div>

      <div className="card">
        <h3>à¦¸à¦¾à¦°à¦¸à¦‚à¦•à§à¦·à§‡à¦ª</h3>
        <div className="summary-row"><span>à¦¸à¦¾à¦¬à¦Ÿà§‹à¦Ÿà¦¾à¦²</span><span>{formatBDT(order.subtotal)}</span></div>
        <div className="summary-row"><span>à¦¡à§‡à¦²à¦¿à¦­à¦¾à¦°à¦¿ à¦šà¦¾à¦°à§à¦œ</span><span>{formatBDT(order.deliveryCharge)}</span></div>
        <div className="summary-row total-row"><strong>à¦®à§‹à¦Ÿ</strong><strong>{formatBDT(order.total)}</strong></div>
      </div>

      <div className="card">
        <h3>à¦¡à§‡à¦²à¦¿à¦­à¦¾à¦°à¦¿ à¦¤à¦¥à§à¦¯</h3>
        <p><strong>{order.customerName}</strong></p>
        <p>{order.phone}</p>
        <p>{order.address}</p>
        <p className="muted">à¦ªà§‡à¦®à§‡à¦¨à§à¦Ÿ: {order.paymentMethod}</p>
      </div>

      {settings && (
        <div className="contact-shop-btns">
          <a className="btn btn-outline" href={telLink(settings.phone)}>ðŸ“ž à¦¦à§‹à¦•à¦¾à¦¨à§‡ à¦•à¦²</a>
          <a className="btn btn-success" target="_blank" rel="noreferrer"
            href={waLink(settings.whatsapp, 'à¦†à¦®à¦¾à¦° à¦…à¦°à§à¦¡à¦¾à¦° #' + order.id.slice(-6))}>ðŸ’¬ WhatsApp</a>
        </div>
      )}
    </div>
  );
}
