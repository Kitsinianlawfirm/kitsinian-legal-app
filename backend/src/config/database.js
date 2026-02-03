/**
 * Database Configuration
 * PostgreSQL connection pool
 */

const { Pool } = require('pg');
const { logger } = require('../utils/logger');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// Log connection events
pool.on('connect', () => {
  logger.info('Database connected');
});

pool.on('error', (err) => {
  logger.error('Database error:', err);
});

// Auto-migrate: create tables if they don't exist
const runMigrations = async () => {
  try {
    logger.info('Running database migrations...');

    await pool.query(`
      CREATE TABLE IF NOT EXISTS leads (
        id UUID PRIMARY KEY,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        email VARCHAR(255) NOT NULL,
        phone VARCHAR(20) NOT NULL,
        preferred_contact VARCHAR(20) DEFAULT 'phone',
        practice_area VARCHAR(100),
        practice_area_category VARCHAR(50),
        urgency VARCHAR(20) DEFAULT 'normal',
        description TEXT,
        quiz_answers JSONB DEFAULT '{}',
        source VARCHAR(50) DEFAULT 'ios_app',
        status VARCHAR(50) DEFAULT 'new',
        notes TEXT,
        assigned_to VARCHAR(100),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );
    `);

    await pool.query(`CREATE INDEX IF NOT EXISTS idx_leads_status ON leads(status);`);
    await pool.query(`CREATE INDEX IF NOT EXISTS idx_leads_practice_area ON leads(practice_area);`);
    await pool.query(`CREATE INDEX IF NOT EXISTS idx_leads_created_at ON leads(created_at DESC);`);
    await pool.query(`CREATE INDEX IF NOT EXISTS idx_leads_urgency ON leads(urgency);`);

    logger.info('Database migrations completed successfully');
    return true;
  } catch (error) {
    logger.error('Migration error:', error);
    return false;
  }
};

// Export migration promise for server to await
const migrationPromise = runMigrations();

module.exports = {
  query: (text, params) => pool.query(text, params),
  pool,
  migrationPromise
};
