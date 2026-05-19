import React from 'react';
import { Home, Layers, BookOpen } from 'lucide-react';

function BottomNav() {
  return (
    <div className="bottom-nav">
      <div className="nav-item">
        <Home size={20} />
        <span>Beranda</span>
      </div>
      <div className="nav-item">
        <Layers size={20} />
        <span>Koleksi Saya</span>
      </div>
      <div className="nav-item active">
        <BookOpen size={20} />
        <span>Buku Harian Aroma</span>
      </div>
    </div>
  );
}

export default BottomNav;
