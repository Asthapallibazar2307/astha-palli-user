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







































