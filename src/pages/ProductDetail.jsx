import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { doc, onSnapshot } from 'firebase/firestore';
import { db } from '../firebase';
import { formatBDT } from '../utils/format';
import { useCart } from '../context/CartContext';

export default function ProductDetail() {
  const { id } = useParams();
  const nav = useNavigate();
  const { addItem } = useCart();
  const [product, setProduct] = useState(null);
  const [qty, setQty] = useState(1);
  const [added, setAdded] = useState(false);

  useEffect(() => {
    return onSnapshot(doc(db, 'products', id), (snap) => {
      setProduct(snap.exists() ? Object.assign({ id: snap.id }, snap.data()) : null);
    });
  }, [id]);

  if (!product) return <div className="page-loading">Loading...</div>;

  const price = Number(product.price) || 0;
  const discount = Number(product.discount) || 0;
  const finalPrice = discount > 0 ? price - (price * discount / 100) : price;
  const outOfStock = Number(product.stock) <= 0;

  const addToCart = () => {
    if (outOfStock) return;
    addItem(product, qty);
    setAdded(true);
    setTimeout(() => setAdded(false), 2000);
  };

  const buyNow = () => {
    if (outOfStock) return;
    addItem(product, qty);
    nav('/cart');
  };

  return (
    <div className="page-product">
      <div className="product-hero">
        {product.imageUrl ? <img src={product.imageUrl} alt={product.name} /> : <div className="product-img placeholder">ðŸ›ï¸</div>}
        {discount > 0 && <span className="discount-badge-lg">-{discount}%</span>}
      </div>

      <div className="product-body">
        <h1>{product.name}</h1>
        {product.category && <p className="product-cat">{product.category}</p>}

        <div className="product-price-row">
          <span className="price-final-lg">{formatBDT(finalPrice)}</span>
          {discount > 0 && <span className="price-old-lg">{formatBDT(price)}</span>}
        </div>

        <p className={'stock-status ' + (outOfStock ? 'out' : 'in')}>
          {outOfStock ? 'âŒ à¦¸à§à¦Ÿà¦• à¦¨à§‡à¦‡' : 'âœ… à¦¸à§à¦Ÿà¦•à§‡ à¦†à¦›à§‡ (' + product.stock + 'à¦Ÿà¦¿)'}
        </p>

        {product.description && (
          <div className="product-desc">
            <h3>à¦¬à¦¿à¦¬à¦°à¦£</h3>
            <p>{product.description}</p>
          </div>
        )}

        {!outOfStock && (
          <div className="qty-selector">
            <button onClick={() => setQty(Math.max(1, qty - 1))}>âˆ’</button>
            <span>{qty}</span>
            <button onClick={() => setQty(Math.min(Number(product.stock), qty + 1))}>+</button>
          </div>
        )}

        {!outOfStock && (
          <div className="product-actions">
            <button className="btn btn-outline" onClick={addToCart}>
              {added ? 'âœ“ à¦¯à§à¦•à§à¦¤ à¦¹à¦¯à¦¼à§‡à¦›à§‡' : 'ðŸ›’ à¦•à¦¾à¦°à§à¦Ÿà§‡ à¦¯à§‹à¦— à¦•à¦°à§à¦¨'}
            </button>
            <button className="btn" onClick={buyNow}>à¦à¦–à¦¨à¦‡ à¦•à¦¿à¦¨à§à¦¨</button>
          </div>
        )}
      </div>
    </div>
  );
}
