import { NavLink } from 'react-router-dom';
import { useCart } from '../context/CartContext';

export default function BottomBar() {
  const { totalItems } = useCart();
  return (
    <nav className="bottombar">
      <NavLink to="/" end>
        <span className="nav-icon">ðŸ </span>
        <span className="nav-label">Home</span>
      </NavLink>
      <NavLink to="/cart">
        <span className="nav-icon">ðŸ›’{totalItems > 0 && <span className="cart-badge">{totalItems}</span>}</span>
        <span className="nav-label">Cart</span>
      </NavLink>
      <NavLink to="/orders">
        <span className="nav-icon">ðŸ“¦</span>
        <span className="nav-label">Orders</span>
      </NavLink>
      <NavLink to="/account">
        <span className="nav-icon">ðŸ‘¤</span>
        <span className="nav-label">Account</span>
      </NavLink>
    </nav>
  );
}







































