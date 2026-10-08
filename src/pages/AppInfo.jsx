import { useEffect, useState } from 'react';
import { doc, onSnapshot } from 'firebase/firestore';
import { db } from '../firebase';
import { telLink, waLink } from '../utils/format';

export default function AppInfo() {
  const [settings, setSettings] = useState(null);

  useEffect(() => {
    return onSnapshot(doc(db, 'settings', 'shop'), (snap) => {
      setSettings(snap.exists() ? snap.data() : null);
    });
  }, []);

  const s = settings || {
    shopName: 'à¦†à¦¸à§à¦¥à¦¾ à¦ªà¦²à§à¦²à§€ à¦¬à¦¾à¦œà¦¾à¦°',
    shopNameEn: 'ASTHA PALLI BAZAR SUPER SHOP',
    phone: '01717978511',
    whatsapp: '01717978511',
    email: 'asthapallibazar2307@gmail.com',
    address: 'à¦®à¦¹à¦¾à¦°à¦¾à¦œà¦ªà§à¦° à¦¬à¦¾à¦œà¦¾à¦°, à¦¨à¦¬à¦¾à¦¬à¦—à¦žà§à¦œ, à¦¦à¦¿à¦¨à¦¾à¦œà¦ªà§à¦°',
    ceo: 'Shafiqul Islam',
    openingHours: '08:00',
    closingHours: '22:00',
    description: 'à¦†à¦¸à§à¦¥à¦¾ à¦ªà¦²à§à¦²à§€ à¦¬à¦¾à¦œà¦¾à¦° - Your trusted super shop.'
  };

  return (
    <div className="page-info">
      <div className="info-header">
        <img src={s.logoUrl || '/logo.png'} alt="" className="info-logo" />
        <h1>{s.shopName}</h1>
        <p className="muted">{s.shopNameEn}</p>
      </div>

      <div className="card">
        <h3>à¦¦à§‹à¦•à¦¾à¦¨ à¦¤à¦¥à§à¦¯</h3>
        <div className="info-row"><span>CEO / MD</span><strong>{s.ceo}</strong></div>
        <div className="info-row"><span>à¦ à¦¿à¦•à¦¾à¦¨à¦¾</span><strong>{s.address}</strong></div>
        <div className="info-row"><span>à¦–à§‹à¦²à¦¾</span><strong>{s.openingHours} - {s.closingHours}</strong></div>
      </div>

      <div className="card">
        <h3>à¦¯à§‹à¦—à¦¾à¦¯à§‹à¦—</h3>
        <div className="info-row"><span>à¦«à§‹à¦¨</span><strong>{s.phone}</strong></div>
        <div className="info-row"><span>WhatsApp</span><strong>{s.whatsapp}</strong></div>
        <div className="info-row"><span>à¦‡à¦®à§‡à¦‡à¦²</span><strong>{s.email}</strong></div>
      </div>

      <div className="contact-shop-btns">
        <a className="btn btn-outline" href={telLink(s.phone)}>ðŸ“ž à¦•à¦² à¦•à¦°à§à¦¨</a>
        <a className="btn btn-success" target="_blank" rel="noreferrer" href={waLink(s.whatsapp)}>ðŸ’¬ WhatsApp</a>
      </div>

      <div className="card description-card">
        <h3>à¦¬à¦¿à¦¬à¦°à¦£</h3>
        <p>{s.description}</p>
      </div>

      <p className="muted" style={{ textAlign: 'center', marginTop: 20 }}>
        Version 1.0.0
      </p>
    </div>
  );
}







































