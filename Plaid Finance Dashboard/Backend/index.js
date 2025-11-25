// backend/index.js
const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const { Client } = require('pg');
const { Configuration, PlaidApi, PlaidEnvironments } = require('plaid');

// Load .env
dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// ----- Postgres client -----
const db = new Client({
  connectionString: process.env.DATABASE_URL,
});

db.connect()
  .then(() => console.log('✅ Connected to Postgres'))
  .catch((err) => console.error('❌ Postgres error:', err.message));

// ----- Plaid client -----
const plaidEnv = PlaidEnvironments[process.env.PLAID_ENV || 'sandbox'];

const plaidConfig = new Configuration({
  basePath: plaidEnv,
  baseOptions: {
    headers: {
      'PLAID-CLIENT-ID': process.env.PLAID_CLIENT_ID,
      'PLAID-SECRET': process.env.PLAID_SECRET,
    },
  },
});

const plaidClient = new PlaidApi(plaidConfig);

// For now, just store one access token in memory (single user demo)
let ACCESS_TOKEN = null;

// ---------- Basic test routes ----------

app.get('/', (req, res) => {
  res.send('Backend API is running ✅');
});

app.get('/api/test-db', async (req, res) => {
  try {
    const result = await db.query('SELECT NOW()');
    res.json(result.rows);
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: 'DB error' });
  }
});

// ---------- Plaid routes ----------

app.post('/api/create-link-token', async (req, res) => {
  try {
    const response = await plaidClient.linkTokenCreate({
      user: {
        client_user_id: 'demo-user-123',
      },
      client_name: 'Plaid Fullstack Demo',
      products: ['transactions'],
      language: 'en',
      country_codes: ['US'],
    });

    res.json({ link_token: response.data.link_token });
  } catch (err) {
    console.error('Error creating link token:', err.response?.data || err.message);
    res.status(500).json({ error: 'Unable to create link token' });
  }
});

app.post('/api/exchange-public-token', async (req, res) => {
  const { public_token } = req.body;

  if (!public_token) {
    return res.status(400).json({ error: 'public_token is required' });
  }

  try {
    const response = await plaidClient.itemPublicTokenExchange({
      public_token,
    });

    const accessToken = response.data.access_token;
    const itemId = response.data.item_id;

    // --- Save access_token + item_id to Postgres ---
    // For now, create a hardcoded demo user (id = 1)
    const userResult = await db.query(
      `INSERT INTO users (username)
       VALUES ('demo-user')
       ON CONFLICT (username) DO UPDATE SET username = EXCLUDED.username
       RETURNING id;`
    );

    const userId = userResult.rows[0].id;

    await db.query(
      `INSERT INTO items (user_id, plaid_item_id, access_token)
       VALUES ($1, $2, $3)
       ON CONFLICT (user_id, plaid_item_id)
       DO UPDATE SET access_token = EXCLUDED.access_token;`,
      [userId, itemId, accessToken]
    );

    console.log('💾 Saved access_token + item_id to Postgres');

    res.json({ item_id: itemId, access_token: 'stored_in_db' });
  } catch (err) {
    console.error('Error exchanging public token:', err.response?.data || err.message);
    res.status(500).json({ error: 'Unable to exchange public token' });
  }
});


app.get('/api/accounts', async (req, res) => {
  try {
    const result = await db.query(
      `SELECT access_token FROM items
       JOIN users ON items.user_id = users.id
       WHERE users.username = 'demo-user'
       LIMIT 1;`
    );

    if (result.rowCount === 0) {
      return res.status(400).json({ error: 'No stored access token' });
    }

    const accessToken = result.rows[0].access_token;

    const response = await plaidClient.accountsGet({
      access_token: accessToken,
    });

    res.json(response.data.accounts);
  } catch (err) {
    console.error('Error fetching accounts:', err.response?.data || err.message);
    res.status(500).json({ error: 'Unable to fetch accounts' });
  }
});

app.get('/api/transactions', async (req, res) => {
  try {
    const result = await db.query(
      `SELECT access_token FROM items
       JOIN users ON items.user_id = users.id
       WHERE users.username = 'demo-user'
       LIMIT 1;`
    );

    if (result.rowCount === 0) {
      return res.status(400).json({ error: 'No stored access token' });
    }

    const accessToken = result.rows[0].access_token;

    const endDate = new Date();
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - 365);

    const formatDate = (d) => d.toISOString().slice(0, 10);

    const response = await plaidClient.transactionsGet({
      access_token: accessToken,
      start_date: formatDate(startDate),
      end_date: formatDate(endDate),
      options: {
        count: 100,
        offset: 0,
      },
    });

    res.json(response.data.transactions);
  } catch (err) {
    console.error('Error fetching transactions:', err.response?.data || err.message);
    res.status(500).json({ error: 'Unable to fetch transactions' });
  }
});


// ---------- Start server on port 5001 ----------
const PORT = process.env.PORT || 5001;
app.listen(PORT, () => {
  console.log(`🚀 Server listening on port ${PORT}`);
});
