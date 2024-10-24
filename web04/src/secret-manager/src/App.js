import * as React from "react";
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import "./index.css";

import Home from './components/Home';
import Navbar from './components/Navbar';
import SecretList from './components/SecretList';
import NewSecret from './components/NewSecret';
import Secret from './components/Secret';

function App() {

  const [secrets, setSecrets] = React.useState([]);

  React.useEffect(() => {
    const savedSecrets = localStorage.getItem('secrets');
    console.log(savedSecrets);
    if (savedSecrets) {
      setSecrets(JSON.parse(savedSecrets));
    }
  }, []);

  const addSecret = async (name, content) => {
    const r = await fetch('/api/new', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ name, content })
    });

    if (!r.ok) {
      throw new Error('Failed to add secret');
    }

    const id = (await r.json()).id;

    localStorage.setItem('secrets', JSON.stringify([...secrets, {id, name}]));
    setSecrets([...secrets, {id, name}]);
  };

  return <div className="App">
    <Router basename="/app">
      <Navbar />
      <div className="container text-center">
        <Routes>
          <Route path='/' element={<Home />} />
          <Route path='/my-secrets' element={<SecretList secrets={secrets} />} />
          <Route path='/new' element={<NewSecret addSecret={addSecret} />} />
          <Route path='/secret/:id' element={<Secret secrets={secrets} />} />
          <Route path="/test" element={<h1>Test</h1>} />
        </Routes>
      </div>
    </Router>
  </div>
}

export default App;
