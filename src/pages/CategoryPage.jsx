import { useParams } from 'react-router-dom';
import { useCollection } from '../hooks/useCollection';
import ProductCard from '../components/ProductCard';

export default function CategoryPage() {
  const { id } = useParams();
  const { data: products, loading } = useCollection('products', { orderByField: 'createdAt' });
  const { data: categories } = useCollection('categories');
  const cat = categories.find((c) => c.id === id);
  const filtered = products.filter((p) => p.category === (cat ? cat.name : '') && p.enabled !== false);

  return (
    <div className="page-category">
      <h1 className="page-title">{cat ? cat.name : 'à¦•à§à¦¯à¦¾à¦Ÿà¦¾à¦—à¦°à¦¿'}</h1>
      {loading && <p className="muted">Loading...</p>}
      {!loading && filtered.length === 0 && <p className="muted" style={{ textAlign: 'center', padding: 40 }}>à¦à¦‡ à¦•à§à¦¯à¦¾à¦Ÿà¦¾à¦—à¦°à¦¿à¦¤à§‡ à¦•à§‹à¦¨à§‹ à¦ªà¦£à§à¦¯ à¦¨à§‡à¦‡</p>}
      <div className="grid-products">
        {filtered.map((p) => <ProductCard key={p.id} product={p} />)}
      </div>
    </div>
  );
}
