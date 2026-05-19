import React from 'react';

function Header() {
  return (
    <header className="header">
      <h1>Buku Harian Aroma</h1>
      {/* Fallback avatar image */}
      <img 
        src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-4.0.3&auto=format&fit=crop&w=100&q=80" 
        alt="User Avatar" 
        className="avatar" 
      />
    </header>
  );
}

export default Header;
