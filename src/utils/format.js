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







































