// backend/migrate.js
const dotenv = require('dotenv');
const { Client } = require('pg');

dotenv.config(); // load DATABASE_URL from .env

async function runMigrations() {
  const client = new Client({
    connectionString: process.env.DATABASE_URL,
  });

  try {
    await client.connect();
    console.log('✅ Connected to Postgres for migrations');

    // 1) users table
    await client.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        username TEXT UNIQUE NOT NULL,
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
      );
    `);
    console.log('✅ Ensured "users" table exists');

    // 2) items table (Plaid items / access tokens)
    await client.query(`
      CREATE TABLE IF NOT EXISTS items (
        id SERIAL PRIMARY KEY,
        user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        plaid_item_id TEXT NOT NULL,
        access_token TEXT NOT NULL,
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        UNIQUE (user_id, plaid_item_id)
      );
    `);
    console.log('✅ Ensured "items" table exists');

    console.log('🎉 Migrations complete');
  } catch (err) {
    console.error('❌ Migration error:', err);
  } finally {
    await client.end();
    console.log('🔚 Closed DB connection');
  }
}

runMigrations();
