/**
 * Encryption Utilities
 * AES-256-GCM encryption for sensitive data (HIPAA/attorney-client compliant)
 */

const crypto = require('crypto');

// AES-256-GCM provides authenticated encryption
const ALGORITHM = 'aes-256-gcm';
const IV_LENGTH = 16; // 128 bits
const AUTH_TAG_LENGTH = 16; // 128 bits
const SALT_LENGTH = 32;

/**
 * Get encryption key from environment or generate warning
 */
function getEncryptionKey() {
    const key = process.env.ENCRYPTION_KEY;

    if (!key) {
        console.warn('WARNING: ENCRYPTION_KEY not set. Using fallback (NOT FOR PRODUCTION)');
        // Fallback for development only - NEVER use in production
        return crypto.scryptSync('development-key-not-secure', 'salt', 32);
    }

    // Key should be 64 hex characters (32 bytes)
    if (key.length === 64) {
        return Buffer.from(key, 'hex');
    }

    // If key is a passphrase, derive a proper key
    return crypto.scryptSync(key, 'claimit-salt-2025', 32);
}

/**
 * Encrypt sensitive data
 * @param {string} plaintext - Data to encrypt
 * @returns {string} - Encrypted data as base64 string (iv:authTag:ciphertext)
 */
function encrypt(plaintext) {
    if (!plaintext || typeof plaintext !== 'string') {
        return plaintext;
    }

    try {
        const key = getEncryptionKey();
        const iv = crypto.randomBytes(IV_LENGTH);

        const cipher = crypto.createCipheriv(ALGORITHM, key, iv);

        let encrypted = cipher.update(plaintext, 'utf8', 'base64');
        encrypted += cipher.final('base64');

        const authTag = cipher.getAuthTag();

        // Format: iv:authTag:ciphertext (all base64)
        return `${iv.toString('base64')}:${authTag.toString('base64')}:${encrypted}`;
    } catch (error) {
        console.error('Encryption error:', error.message);
        throw new Error('Failed to encrypt data');
    }
}

/**
 * Decrypt sensitive data
 * @param {string} encryptedData - Encrypted string (iv:authTag:ciphertext)
 * @returns {string} - Decrypted plaintext
 */
function decrypt(encryptedData) {
    if (!encryptedData || typeof encryptedData !== 'string') {
        return encryptedData;
    }

    // Check if data is actually encrypted (has our format)
    if (!encryptedData.includes(':')) {
        // Data is not encrypted (legacy or plaintext)
        return encryptedData;
    }

    try {
        const key = getEncryptionKey();
        const parts = encryptedData.split(':');

        if (parts.length !== 3) {
            // Not our encrypted format, return as-is
            return encryptedData;
        }

        const iv = Buffer.from(parts[0], 'base64');
        const authTag = Buffer.from(parts[1], 'base64');
        const ciphertext = parts[2];

        const decipher = crypto.createDecipheriv(ALGORITHM, key, iv);
        decipher.setAuthTag(authTag);

        let decrypted = decipher.update(ciphertext, 'base64', 'utf8');
        decrypted += decipher.final('utf8');

        return decrypted;
    } catch (error) {
        console.error('Decryption error:', error.message);
        // Return original if decryption fails (might be unencrypted legacy data)
        return encryptedData;
    }
}

/**
 * Hash sensitive data (one-way, for searching)
 * @param {string} data - Data to hash
 * @returns {string} - SHA-256 hash
 */
function hash(data) {
    if (!data) return null;
    return crypto.createHash('sha256').update(data.toLowerCase().trim()).digest('hex');
}

/**
 * Generate a secure encryption key
 * Run this once to generate your ENCRYPTION_KEY
 */
function generateKey() {
    return crypto.randomBytes(32).toString('hex');
}

/**
 * Encrypt an object's sensitive fields
 * @param {object} obj - Object with sensitive data
 * @param {string[]} fields - Fields to encrypt
 * @returns {object} - Object with encrypted fields
 */
function encryptFields(obj, fields) {
    const encrypted = { ...obj };
    for (const field of fields) {
        if (encrypted[field]) {
            encrypted[field] = encrypt(encrypted[field]);
        }
    }
    return encrypted;
}

/**
 * Decrypt an object's sensitive fields
 * @param {object} obj - Object with encrypted data
 * @param {string[]} fields - Fields to decrypt
 * @returns {object} - Object with decrypted fields
 */
function decryptFields(obj, fields) {
    const decrypted = { ...obj };
    for (const field of fields) {
        if (decrypted[field]) {
            decrypted[field] = decrypt(decrypted[field]);
        }
    }
    return decrypted;
}

module.exports = {
    encrypt,
    decrypt,
    hash,
    generateKey,
    encryptFields,
    decryptFields,
    ALGORITHM
};
