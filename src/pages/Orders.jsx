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
        <div className="empty-icon">ðŸ“¦</div>
        <h2>à¦²à¦—à¦‡à¦¨ à¦•à¦°à§à¦¨</h2>
        <p>à¦…à¦°à§à¦¡à¦¾à¦° à¦¦à§‡à¦–à¦¤à§‡ à¦²à¦—à¦‡à¦¨ à¦•à¦°à§à¦¨</p>
        <Link to="/login" className="btn">à¦²à¦—à¦‡à¦¨</Link>
      </div>
    );
  }

  return (
    <div className="page-orders">
      {loading && <p className="muted">Loading...</p>}
      {!loading && orders.length === 0 && (
        <div className="empty-cart">
          <div className="empty-icon">ðŸ“¦</div>
          <h2>à¦à¦–à¦¨à§‹ à¦•à§‹à¦¨à§‹ à¦…à¦°à§à¦¡à¦¾à¦° à¦¨à§‡à¦‡</h2>
          <Link to="/" className="btn">à¦•à§‡à¦¨à¦¾à¦•à¦¾à¦Ÿà¦¾ à¦¶à§à¦°à§ à¦•à¦°à§à¦¨</Link>
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
            <span>{o.items ? o.items.length : 0}à¦Ÿà¦¿ à¦ªà¦£à§à¦¯</span>
            <strong>{formatBDT(o.total)}</strong>
          </div>
        </Link>
      ))}
    </div>
  );
}
