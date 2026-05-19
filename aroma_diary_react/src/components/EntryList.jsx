import React from 'react';
import { Trash2 } from 'lucide-react';

function EntryList({ entries, onDelete }) {
  return (
    <div className="entry-list">
      {entries.map((entry) => (
        <div key={entry.id} className="entry-card">
          <div className="entry-header">
            <h3 className="entry-title">{entry.parfum}</h3>
            <span className="entry-date">{entry.date}</span>
          </div>
          
          <button 
            className="btn-delete"
            onClick={() => onDelete(entry.id)}
            aria-label="Delete entry"
          >
            <Trash2 size={16} />
          </button>
          
          <div className="entry-tags">
            {entry.place && <span className="tag">{entry.place}</span>}
            {entry.weather && <span className="tag">{entry.weather}</span>}
          </div>
          
          <p className="entry-desc">{entry.description}</p>
        </div>
      ))}
    </div>
  );
}

export default EntryList;
