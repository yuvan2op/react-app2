const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Basic routes
app.get('/', (req, res) => {
  res.send('Hey there try health , /api/hello , /api/echo/ this is the endpoint');
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', uptime: process.uptime() });
});

app.get('/api/hello', (req, res) => {
  res.json({ message: 'Hello from the Node.js backend 👋' });
});

// Example POST route (no DB, just echoes data back)
app.post('/api/echo', (req, res) => {
  res.json({
    received: req.body,
    info: 'This is just an echo endpoint. No database attached.'
  });
});

app.listen(PORT, () => {
  console.log(`API server listening on port ${PORT}`);
});


