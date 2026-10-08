import { Link, useNavigate } from 'react-router-dom';
import { useCart } from '../context/CartContext';
import { formatBDT } from '../utils/format';

export default function Cart() {
  const { items, updateQty, removeItem, subtotal, clearCart } = useCart();
  const nav = useNavigate();

  if (items.length === 0) {
    return (
      <div className="page-cart empty-cart">
        <div className="empty-icon">ðŸ›’</div>
        <h2>à¦†à¦ªà¦¨à¦¾à¦° à¦•à¦¾à¦°à§à¦Ÿ à¦–à¦¾à¦²à¦¿</h2>
        <p>à¦ªà¦£à§à¦¯ à¦¯à§‹à¦— à¦•à¦°à§‡ à¦•à§‡à¦¨à¦¾à¦•à¦¾à¦Ÿà¦¾ à¦¶à§à¦°à§ à¦•à¦°à§à¦¨</p>
        <Link to="/" className="btn">à¦•à§‡à¦¨à¦¾à¦•à¦¾à¦Ÿà¦¾ à¦¶à§à¦°à§ à¦•à¦°à§à¦¨</Link>
      </div>
    );
  }

  return (
    <div className="page-cart">
      <div className="cart-items">
        {items.map((it) => (
          <div key={it.id} className="cart-item">
            {it.imageUrl ? <img src={it.imageUrl} alt="" className="cart-item-img" /> : <div className="cart-item-img placeholder">ðŸ›ï¸</div>}
            <div className="cart-item-info">
              <h3>{it.name}</h3>
              <p className="cart-item-price">{formatBDT(it.price)}</p>
              <div className="qty-selector-sm">
                <button onClick={() => updateQty(it.id, it.qty - 1)}>âˆ’</button>
                <span>{it.qty}</span>
                <button onClick={() => updateQty(it.id, it.qty + 1)}>+</button>
              </div>
            </div>
            <div className="cart-item-right">
              <p className="cart-item-total">{formatBDT(it.price * it.qty)}</p>
              <button className="remove-btn" onClick={() => removeItem(it.id)}>âœ•</button>
            </div>
          </div>
        ))}
      </div>

      <div className="cart-footer">
        <div className="cart-total-row">
          <span>à¦¸à¦¾à¦¬à¦Ÿà§‹à¦Ÿà¦¾à¦²</span>
          <strong>{formatBDT(subtotal)}</strong>
        </div>
        <button className="btn" style={{ width: '100%' }} onClick={() => nav('/checkout')}>à¦šà§‡à¦•à¦†à¦‰à¦Ÿ à¦•à¦°à§à¦¨</button>
        <button className="clear-cart-btn" onClick={clearCart}>à¦•à¦¾à¦°à§à¦Ÿ à¦–à¦¾à¦²à¦¿ à¦•à¦°à§à¦¨</button>
      </div>
    </div>
  );
}
