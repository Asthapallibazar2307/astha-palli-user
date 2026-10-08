$firebase = @'
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyAZ28B0SWN5Oi0f-BpM6-a1QC2E8e5tAPQ",
  authDomain: "astha-palli-bazar.firebaseapp.com",
  projectId: "astha-palli-bazar",
  storageBucket: "astha-palli-bazar.firebasestorage.app",
  messagingSenderId: "1090381974673",
  appId: "1:1090381974673:web:2a8389d2617559a85cc330"
};

export const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
'@

$format = @'
export const formatBDT = (n) => '\u09F3 ' + Number(n || 0).toLocaleString('en-BD');

export const formatDate = (ts) => {
  if (!ts) return '-';
  const d = ts && ts.toDate ? ts.toDate() : new Date(ts);
  return d.toLocaleString('en-BD', {
    day: '2-digit', month: 'short', year: 'numeric',
    hour: '2-digit', minute: '2-digit'
  });
};

export const waLink = (phone, text) => {
  const clean = String(phone || '').replace(/\D/g, '');
  const intl = clean.indexOf('880') === 0 ? clean : '88' + clean;
  return 'https://wa.me/' + intl + (text ? '?text=' + encodeURIComponent(text) : '');
};

export const telLink = (phone) => 'tel:' + phone;
'@

$constants = @'
export const ORDER_STATUSES = ['Pending', 'Confirmed', 'Processing', 'Out for Delivery', 'Delivered', 'Cancelled'];

export const DEFAULT_CATEGORIES = [
  'Essential Groceries', 'Clothing', 'Electronics', 'Personal Care',
  'Household', 'Baby Products', 'Snacks & Beverages'
];

export const statusClass = (s) => {
  const map = {
    Pending: 'badge-pending',
    Confirmed: 'badge-confirmed',
    Processing: 'badge-processing',
    'Out for Delivery': 'badge-out-for-delivery',
    Delivered: 'badge-delivered',
    Cancelled: 'badge-cancelled'
  };
  return map[s] || 'badge-pending';
};
'@

$imgbb = @'
const IMGBB_KEY = import.meta.env.VITE_IMGBB_API_KEY;

export async function uploadToImgBB(file) {
  if (!file) return '';
  const formData = new FormData();
  formData.append('image', file);
  const url = 'https://api.imgbb.com/1/upload?key=' + IMGBB_KEY;
  const res = await fetch(url, { method: 'POST', body: formData });
  const data = await res.json();
  if (!data.success) throw new Error('Upload failed');
  return data.data.url;
}
'@

$useCollection = @'
import { useEffect, useState } from 'react';
import { collection, onSnapshot, orderBy, query, where } from 'firebase/firestore';
import { db } from '../firebase';

export function useCollection(path, options) {
  const opts = options || {};
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const ref = collection(db, path);
    let q = ref;
    if (opts.orderByField) {
      q = query(ref, orderBy(opts.orderByField, opts.orderDir || 'desc'));
    }
    const unsub = onSnapshot(q, (snap) => {
      setData(snap.docs.map((d) => Object.assign({ id: d.id }, d.data())));
      setLoading(false);
    });
    return () => unsub();
  }, [path, opts.orderByField, opts.orderDir]);

  return { data, loading };
}
'@

Set-Content -Path src\firebase.js -Value $firebase -Encoding UTF8
Set-Content -Path src\utils\format.js -Value $format -Encoding UTF8
Set-Content -Path src\utils\constants.js -Value $constants -Encoding UTF8
Set-Content -Path src\utils\imgbb.js -Value $imgbb -Encoding UTF8
Set-Content -Path src\hooks\useCollection.js -Value $useCollection -Encoding UTF8

Write-Host "Done! Base files created."