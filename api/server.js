const express = require('express');
const cors = require('cors');
const { connectDB, Item } = require('./db');

const app = express();
const PORT = process.env.PORT || 5000;

// Connect to MongoDB
connectDB();

let visits = 0;

// Middleware
app.use(cors());
app.use(express.json());

// Basic routes
app.get('/', (req, res) => {
  visits++;
  res.send(
    `Visits: ${visits}\n\n` +
    'Hey there! Try /health, /api/hello, /api/echo, /api/items (GET/POST). MongoDB is wired in for practice.'
  );
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', uptime: process.uptime() });
});

// API-style health endpoint for use via nginx proxy (/api/health)
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', uptime: process.uptime(), path: '/api/health' });
});

app.get('/api/hello', (req, res) => {
  res.json({ message: 'Hello from the Node.js backend 👋' });
});

// Example POST route (no DB, just echoes data back)
app.post('/api/echo', (req, res) => {
  res.json({
    received: req.body,
    info: 'This is just an echo endpoint. No database attached.',
  });
});

// --- MongoDB practice routes ---

// Get all items
app.get('/api/items', async (req, res) => {
  try {
    const items = await Item.find().sort({ createdAt: -1 });
    res.json(items);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch items' });
  }
});

// Create a new item
app.post('/api/items', async (req, res) => {
  try {
    const { name } = req.body;

    if (!name || !name.trim()) {
      return res.status(400).json({ error: 'name is required' });
    }

    const item = await Item.create({ name: name.trim() });
    res.status(201).json(item);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to create item' });
  }
});

app.listen(PORT, () => {
  console.log(`API server listening on port ${PORT}`);
});

