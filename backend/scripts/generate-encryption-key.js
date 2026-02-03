#!/usr/bin/env node
/**
 * Generate a secure 256-bit encryption key for ClaimIt
 *
 * Run this once, then add the key to your environment variables:
 * - Locally: Add to .env file
 * - Render: Add in the dashboard under Environment Variables
 *
 * Usage: node scripts/generate-encryption-key.js
 */

const crypto = require('crypto');

console.log('\n🔐 ClaimIt Encryption Key Generator\n');
console.log('━'.repeat(50));

// Generate a cryptographically secure 256-bit key
const key = crypto.randomBytes(32).toString('hex');

console.log('\n✅ Your new encryption key (AES-256):\n');
console.log(`ENCRYPTION_KEY=${key}`);
console.log('\n━'.repeat(50));
console.log('\n📋 Instructions:\n');
console.log('1. Copy the line above');
console.log('2. Add it to your .env file (for local development)');
console.log('3. Add it to Render dashboard → Environment Variables (for production)');
console.log('\n⚠️  IMPORTANT:');
console.log('   - Keep this key SECRET');
console.log('   - Never commit it to git');
console.log('   - If you lose it, encrypted data cannot be recovered');
console.log('   - Generate a DIFFERENT key for production vs development\n');
