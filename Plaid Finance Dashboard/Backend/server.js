const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 5001;

// Middleware
app.use(cors());
app.use(express.json());

// Root sanity check
app.get('/', (req, res) => {
  res.send('Backend API is running ✅');
});

// Fake DB test route for now
app.get('/api/test-db', (req, res) => {
  res.json({
    ok: true,
    message: 'DB test route hit',
    now: new Date().toISOString(),
  });
});

app.listen(PORT, () => {
  console.log(`Server listening on http://localhost:${PORT}`);
});
