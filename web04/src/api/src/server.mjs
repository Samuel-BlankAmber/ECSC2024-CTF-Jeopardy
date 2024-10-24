import express from 'express';
import Database from 'better-sqlite3';
import { createHash } from 'crypto';

// Initialize Express app
const app = express();
app.use(express.json());

// Initialize SQLite database
const db = new Database('/data/secrets.db');

// Create table if not exists
db.prepare('CREATE TABLE IF NOT EXISTS secrets (id VARCHAR(40) PRIMARY KEY, name TEXT, content TEXT)').run();

// Endpoint to save a new secret
app.post('/api/new', (req, res) => {
  const { name, content } = req.body;
  const id = createHash('md5').update(content).digest('hex');
  const stmt = db.prepare('INSERT INTO secrets (id, name, content) VALUES (?, ?, ?)');

  try {
    stmt.run(id, name, content);
  } catch (err) {
    if (err.message.includes('UNIQUE constraint failed')) {
      return res.json({ id });
    } else {
      console.error(err.message);
      return res.status(500).json({ error: 'Failed to save secret' });
    }
  }
  res.json({ id });
    
});

// Endpoint to retrieve a secret by id
app.get('/api/secret/:id', (req, res) => {
  const { id } = req.params;
  const stmt = db.prepare('SELECT name, content FROM secrets WHERE id = ?');
  const secret = stmt.get(id);
  if (secret) {
    res.json(secret);
  } else {
    res.status(404).json({ error: 'Secret not found' });
  }
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});