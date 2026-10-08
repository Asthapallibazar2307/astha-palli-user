import { useState } from 'react';
import { useCollection } from '../hooks/useCollection';
import ProductCard from '../components/ProductCard';

export default function Search() {
  const { data: products, loading } = useCollection('products', { orderByField: 'createdAt' });
  const [q, setQ] = useState('');

  const filtered = q.trim() ? products.filter((p) =>
    p.name.toLowerCase().includes(q.toLowerCase()) && p.enabled !== false
  ) : [];

  return (
    <div className="page-search">
      <div className="search-box">
        <input className="input" placeholder="à¦ªà¦£à§à¦¯ à¦–à§à¦à¦œà§à¦¨..." autoFocus
          value={q} onChange={(e) => setQ(e.target.value)} />
      </div>

      {loading && <p className="muted">Loading...</p>}
      {!loading && q && filtered.length === 0 && (
        <p className="muted" style={{ textAlign: 'center', padding: 40 }}>à¦•à§‹à¦¨à§‹ à¦ªà¦£à§à¦¯ à¦ªà¦¾à¦“à¦¯à¦¼à¦¾ à¦¯à¦¾à¦¯à¦¼à¦¨à¦¿</p>
      )}
      {!q && <p className="muted" style={{ textAlign: 'center', padding: 40 }}>à¦•à¦¿à¦›à§ à¦²à¦¿à¦–à§à¦¨ à¦–à§à¦à¦œà¦¤à§‡</p>}

      <div className="grid-products">
        {filtered.map((p) => <ProductCard key={p.id} product={p} />)}
      </div>
    </div>
  );
}







































