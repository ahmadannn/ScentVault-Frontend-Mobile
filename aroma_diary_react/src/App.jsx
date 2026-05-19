import React, { useState } from 'react';
import Header from './components/Header';
import FormCard from './components/FormCard';
import EntryList from './components/EntryList';
import BottomNav from './components/BottomNav';

function App() {
  const [entries, setEntries] = useState([
    {
      id: 1,
      parfum: 'Baccarat',
      date: '10/01/2025',
      weather: 'SEJUK',
      place: 'RESTO',
      description: '"Perpaduan mawar dan oud yang sangat megah. Memberikan rasa percaya diri ekstra saat berjalan di karpet merah malam ini."',
    },
    {
      id: 2,
      parfum: 'Lacoco',
      date: '08/11/2024',
      weather: 'CERAH',
      place: 'PANTAI',
      description: '"Kesegaran sitrus yang sempurna untuk udara siang yang cerah. Sangat ringan dan tidak mengganggu saat menikmati kopi di teras."',
    }
  ]);

  const handleAddEntry = (newEntry) => {
    const today = new Date();
    const formattedDate = `${String(today.getDate()).padStart(2, '0')}/${String(today.getMonth() + 1).padStart(2, '0')}/${today.getFullYear()}`;
    
    setEntries([
      {
        ...newEntry,
        id: Date.now(),
        date: formattedDate,
      },
      ...entries
    ]);
  };

  const handleDelete = (id) => {
    setEntries(entries.filter(entry => entry.id !== id));
  };

  return (
    <div className="app-container">
      <div className="content-scroll">
        <Header />
        
        <div className="section-title">Catatan Baru</div>
        <FormCard onAdd={handleAddEntry} />
        
        <div className="section-title">List Catatan</div>
        <EntryList entries={entries} onDelete={handleDelete} />
      </div>
      
      <BottomNav />
    </div>
  );
}

export default App;
