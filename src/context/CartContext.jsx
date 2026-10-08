import { createContext, useContext, useEffect, useState } from 'react';

const CartContext = createContext(null);

export function CartProvider({ children }) {
  const [items, setItems] = useState([]);

  useEffect(() => {
    const saved = localStorage.getItem('apb_cart');
    if (saved) {
      try { setItems(JSON.parse(saved)); } catch (e) { setItems([]); }
    }
  }, []);

  useEffect(() => {
    localStorage.setItem('apb_cart', JSON.stringify(items));
  }, [items]);

  const addItem = (product, qty) => {
    const q = qty || 1;
    setItems((prev) => {
      const existing = prev.find((x) => x.id === product.id);
      if (existing) {
        return prev.map((x) => x.id === product.id ? Object.assign({}, x, { qty: x.qty + q }) : x);
      }
      return prev.concat([{ id: product.id, name: product.name, price: product.price, discount: product.discount || 0, imageUrl: product.imageUrl, qty: q }]);
    });
  };

  const removeItem = (id) => {
    setItems((prev) => prev.filter((x) => x.id !== id));
  };

  const updateQty = (id, qty) => {
    if (qty <= 0) return removeItem(id);
    setItems((prev) => prev.map((x) => x.id === id ? Object.assign({}, x, { qty: qty }) : x));
  };

  const clearCart = () => setItems([]);

  const subtotal = items.reduce((s, x) => s + Number(x.price) * Number(x.qty), 0);
  const totalItems = items.reduce((s, x) => s + Number(x.qty), 0);

  return (
    <CartContext.Provider value={{ items, addItem, removeItem, updateQty, clearCart, subtotal, totalItems }}>
      {children}
    </CartContext.Provider>
  );
}

export const useCart = () => useContext(CartContext);







































