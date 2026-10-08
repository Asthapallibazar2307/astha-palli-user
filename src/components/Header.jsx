import { Link } from 'react-router-dom';

export default function Header({ title, showBack, showSearch }) {
  return (
    <header className="app-header">
      <div className="header-left">
        {showBack ? <button className="icon-btn" onClick={() => window.history.back()}>â†</button> : <Link to="/" className="header-logo"><img src="/logo.png" alt="" /></Link>}
      </div>
      <h1 className="header-title">{title}</h1>
      <div className="header-right">
        {showSearch && <Link to="/search" className="icon-btn">ðŸ”</Link>}
      </div>
    </header>
  );
}







































