import React, { useState } from 'react';

function FormCard({ onAdd }) {
  const [formData, setFormData] = useState({
    parfum: 'Santal 33',
    weather: 'Cerah',
    place: 'Kantor',
    description: ''
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!formData.description) return;
    
    onAdd({
      parfum: formData.parfum,
      weather: formData.weather.toUpperCase(),
      place: formData.place.toUpperCase(),
      description: `"${formData.description}"`
    });
    
    setFormData(prev => ({ ...prev, description: '' }));
  };

  return (
    <div className="card">
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label className="form-label">Pilih Parfum</label>
          <div className="select-wrapper">
            <select 
              name="parfum" 
              className="form-control"
              value={formData.parfum}
              onChange={handleChange}
            >
              <option value="Santal 33">Santal 33</option>
              <option value="Baccarat">Baccarat</option>
              <option value="Lacoco">Lacoco</option>
              <option value="Jo Malone">Jo Malone</option>
            </select>
          </div>
        </div>

        <div className="form-row">
          <div className="form-group">
            <label className="form-label">Cuaca</label>
            <div className="select-wrapper">
              <select 
                name="weather" 
                className="form-control"
                value={formData.weather}
                onChange={handleChange}
              >
                <option value="Cerah">Cerah</option>
                <option value="Sejuk">Sejuk</option>
                <option value="Hujan">Hujan</option>
                <option value="Mendung">Mendung</option>
              </select>
            </div>
          </div>
          
          <div className="form-group">
            <label className="form-label">Tempat</label>
            <div className="select-wrapper">
              <select 
                name="place" 
                className="form-control"
                value={formData.place}
                onChange={handleChange}
              >
                <option value="Kantor">Kantor</option>
                <option value="Resto">Resto</option>
                <option value="Pantai">Pantai</option>
                <option value="Rumah">Rumah</option>
              </select>
            </div>
          </div>
        </div>

        <div className="form-group">
          <label className="form-label">Catatan Aroma</label>
          <textarea 
            name="description"
            className="form-control" 
            placeholder='"Aroma kayu cendana yang ikonik memberikan kesan profesional..."'
            value={formData.description}
            onChange={handleChange}
            required
          ></textarea>
        </div>

        <button type="submit" className="btn-submit">Simpan Entri</button>
      </form>
    </div>
  );
}

export default FormCard;
