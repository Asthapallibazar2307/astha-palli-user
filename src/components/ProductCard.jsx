import { Link } from 'react-router-dom';
import { formatBDT } from '../utils/format';

export default function ProductCard({ product }) {
  const price = Number(product.price) || 0;
  const discount = Number(product.discount) || 0;
  const finalPrice = discount > 0 ? price - (price * discount / 100) : price;
  const outOfStock = Number(product.stock) <= 0;

  return (
    <Link to={'/product/' + product.id} className="product-card">
      <div className="product-img-wrap">
        {product.imageUrl ? <img src={product.imageUrl} alt={product.name} className="product-img" /> : <div className="product-img placeholder">ðŸ›ï¸</div>}
        {discount > 0 && <span className="discount-badge">-{discount}%</span>}
        {outOfStock && <span className="stock-out">Out of Stock</span>}
      </div>
      <div className="product-info">
        <h3 className="product-name">{product.name}</h3>
        <div className="product-price">
          <span className="price-final">{formatBDT(finalPrice)}</span>
          {discount > 0 && <span className="price-old">{formatBDT(price)}</span>}
        </div>
      </div>
    </Link>
  );
}
