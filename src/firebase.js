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







































