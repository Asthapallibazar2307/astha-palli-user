import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { useCollection } from '../hooks/useCollection';
import ProductCard from '../components/ProductCard';
import { doc, onSnapshot } from 'firebase/firestore';
import { db } from '../firebase';

export default function Home() {
  const { data: products } = useCollection('products', { orderByField: 'createdAt' });
  const { data: banners } = useCollection('banners', { orderByField: 'createdAt' });
  const { data: categories } = useCollection('categories', { orderByField: 'createdAt' });
  const [settings, setSettings] = useState(null);

  useEffect(() => {
    return onSnapshot(doc(db, 'settings', 'shop'), (snap) => {
      setSettings(snap.exists() ? snap.data() : null);
    });
  }, []);

  const activeBanner = banners.find((b) => b.enabled !== false);
  const todaysOffers = products.filter((p) => p.todaysOffer && p.enabled !== false);
  const featured = products.filter((p) => p.featured && p.enabled !== false).slice(0, 8);

  return (
    <div className="page-home">
      {activeBanner ? (
        <div className="banner">
          <img src={activeBanner.imageUrl} alt="" className="banner-img" />
          <div className="banner-overlay">
            {activeBanner.title && <h2>{activeBanner.title}</h2>}
            {activeBanner.description && <p>{activeBanner.description}</p>}
            {activeBanner.offerText && <span className="banner-offer">{activeBanner.offerText}</span>}
          </div>
        </div>
      ) : (
        <div className="banner banner-welcome">
          <h2>{'স্বাগতম ' + (settings && settings.shopName ? settings.shopName : 'আস্থা পল্লী বাজার') + 'ে'}</h2>
          <p>সেরা মানের পণ্য, ঘরে পৌঁছে দেব</p>
        </div>
      )}

      {todaysOffers.length > 0 && (
        <section className="section">
          <div className="section-head">
            <h2>🔥 আজকের অফার</h2>
          </div>
          <div className="h-scroll">
            {todaysOffers.map((p) => <ProductCard key={p.id} product={p} />)}
          </div>
        </section>
      )}

      <section className="section">
        <div className="section-head"><h2>ক্যাটাগরি</h2></div>
        <div className="cat-scroll">
          {categories.length === 0 && <p className="muted">কোনো ক্যাটাগরি নেই</p>}
          {categories.filter((c) => c.enabled !== false).map((c) => (
            <Link key={c.id} to={'/category/' + c.id} className="cat-chip">
              {c.imageUrl ? <img src={c.imageUrl} alt="" className="cat-chip-img" /> : <span className="cat-chip-emoji">🛍️</span>}
              <span className="cat-chip-name">{c.name}</span>
            </Link>
          ))}
        </div>
      </section>

      {featured.length > 0 && (
        <section className="section">
          <div className="section-head"><h2>⭐ ফিচার্ড</h2></div>
          <div className="grid-products">
            {featured.map((p) => <ProductCard key={p.id} product={p} />)}
          </div>
        </section>
      )}

      <section className="section">
        <div className="section-head"><h2>সব পণ্য</h2></div>
        <div className="grid-products">
          {products.length === 0 && <p className="muted">কোনো পণ্য নেই</p>}
          {products.filter((p) => p.enabled !== false).map((p) => <ProductCard key={p.id} product={p} />)}
        </div>
      </section>
    </div>
  );
}