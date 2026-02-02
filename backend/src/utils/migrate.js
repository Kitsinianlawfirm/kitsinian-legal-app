/**
 * Database Migration Script
 * Creates the leads table
 */

require('dotenv').config();
const { pool } = require('../config/database');
const { logger } = require('./logger');

const migrate = async () => {
  try {
    console.log('Running migrations...');

    // Create leads table
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

    // Create indexes
    await pool.query(`
      CREATE INDEX IF NOT EXISTS idx_leads_status ON leads(status);
    `);

    await pool.query(`
      CREATE INDEX IF NOT EXISTS idx_leads_practice_area ON leads(practice_area);
    `);

    await pool.query(`
      CREATE INDEX IF NOT EXISTS idx_leads_created_at ON leads(created_at DESC);
    `);

    await pool.query(`
      CREATE INDEX IF NOT EXISTS idx_leads_urgency ON leads(urgency);
    `);

    console.log('✅ Migrations completed successfully');
    logger.info('Database migrations completed');

    process.exit(0);
  } catch (error) {
    console.error('❌ Migration failed:', error);
    logger.error('Migration failed:', error);
    process.exit(1);
  }
};

migrate();
