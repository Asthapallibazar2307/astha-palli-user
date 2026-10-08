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
