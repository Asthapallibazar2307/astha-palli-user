import { useCollection } from '../hooks/useCollection';
import ProductCard from '../components/ProductCard';

export default function Offers() {
  const { data: products, loading } = useCollection('products', { orderByField: 'createdAt' });
  const offers = products.filter((p) => p.todaysOffer && p.enabled !== false);

  return (
    <div className="page-offers">
      <h1 className="page-title">ðŸ”¥ à¦†à¦œà¦•à§‡à¦° à¦…à¦«à¦¾à¦°</h1>
      {loading && <p className="muted">Loading...</p>}
      {!loading && offers.length === 0 && <p className="muted" style={{ textAlign: 'center', padding: 40 }}>à¦à¦–à¦¨à§‹ à¦•à§‹à¦¨à§‹ à¦…à¦«à¦¾à¦° à¦¨à§‡à¦‡</p>}
      <div className="grid-products">
        {offers.map((p) => <ProductCard key={p.id} product={p} />)}
      </div>
    </div>
  );
}
