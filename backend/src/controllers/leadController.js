/**
 * Lead Controller
 * Business logic for lead management
 */

const { v4: uuidv4 } = require('uuid');
const db = require('../config/database');
const emailService = require('../services/emailService');
const leadDocketService = require('../services/leadDocketService');
const { logger } = require('../utils/logger');
const { encrypt, decrypt, encryptFields, decryptFields } = require('../utils/encryption');

// Fields that contain PII and should be encrypted
const SENSITIVE_FIELDS = ['email', 'phone', 'description'];

// Simple auth middleware - replace with proper auth in production
const authMiddleware = (req, res, next) => {
  const apiKey = req.headers['x-api-key'];

  if (!apiKey || apiKey !== process.env.ADMIN_API_KEY) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  next();
};

// Create a new lead
const createLead = async (req, res) => {
  try {
    const {
      firstName,
      lastName,
      email,
      phone,
      preferredContact = 'phone',
      practiceArea = '',
      practiceAreaCategory = '',
      urgency = 'normal',
      description = '',
      quizAnswers = {},
      source = 'ios_app'
    } = req.body;

    const id = uuidv4();
    const createdAt = new Date();

    // Encrypt sensitive PII before storing (AES-256-GCM)
    const encryptedEmail = encrypt(email);
    const encryptedPhone = encrypt(phone);
    const encryptedDescription = encrypt(description);

    logger.info('Encrypting sensitive lead data', { id });

    // Insert into database with encrypted fields
    const query = `
      INSERT INTO leads (
        id, first_name, last_name, email, phone,
        preferred_contact, practice_area, practice_area_category,
        urgency, description, quiz_answers, source, created_at, status
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
      RETURNING *
    `;

    const values = [
      id, firstName, lastName, encryptedEmail, encryptedPhone,
      preferredContact, practiceArea, practiceAreaCategory,
      urgency, encryptedDescription, JSON.stringify(quizAnswers), source, createdAt, 'new'
    ];

    const result = await db.query(query, values);

    // Send notification email to firm
    try {
      await emailService.sendNewLeadNotification({
        id,
        firstName,
        lastName,
        email,
        phone,
        preferredContact,
        practiceArea,
        urgency,
        description,
        createdAt
      });
    } catch (emailError) {
      logger.error('Failed to send lead notification email:', emailError);
      // Don't fail the request if email fails
    }

    // Send confirmation email to lead
    try {
      await emailService.sendLeadConfirmation({
        email,
        firstName,
        practiceArea
      });
    } catch (emailError) {
      logger.error('Failed to send lead confirmation email:', emailError);
    }

    // Sync to Lead Docket CRM (fire-and-forget - don't block response)
    // Lead is already saved to database, so we can respond immediately
    leadDocketService.sendToLeadDocket({
      id,
      firstName,
      lastName,
      email,
      phone,
      preferredContact,
      practiceArea,
      practiceAreaCategory,
      urgency,
      description,
      quizAnswers,
      source,
      createdAt
    }).then(result => {
      logger.info('Lead Docket sync completed', { id, success: result?.success });
    }).catch(ldError => {
      logger.error('Failed to sync lead to Lead Docket:', ldError);
    });

    logger.info('New lead created', { id, practiceArea, urgency });

    res.status(201).json({
      success: true,
      leadId: id,
      message: 'Your request has been submitted successfully.',
      estimatedResponse: urgency === 'urgent' ? 'within 2 hours' : 'within 24 hours'
    });

  } catch (error) {
    logger.error('Error creating lead:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to submit your request. Please try again.'
    });
  }
};

// Get all leads (admin only)
const getLeads = async (req, res) => {
  try {
    const { status, practiceArea, limit = 50, offset = 0 } = req.query;

    let query = 'SELECT * FROM leads WHERE 1=1';
    const values = [];
    let paramCount = 0;

    if (status) {
      paramCount++;
      query += ` AND status = $${paramCount}`;
      values.push(status);
    }

    if (practiceArea) {
      paramCount++;
      query += ` AND practice_area = $${paramCount}`;
      values.push(practiceArea);
    }

    query += ' ORDER BY created_at DESC';

    paramCount++;
    query += ` LIMIT $${paramCount}`;
    values.push(parseInt(limit));

    paramCount++;
    query += ` OFFSET $${paramCount}`;
    values.push(parseInt(offset));

    const result = await db.query(query, values);

    // Decrypt sensitive fields before returning
    const decryptedLeads = result.rows.map(lead =>
      decryptFields(lead, SENSITIVE_FIELDS)
    );

    res.json({
      success: true,
      count: decryptedLeads.length,
      leads: decryptedLeads
    });

  } catch (error) {
    logger.error('Error fetching leads:', error);
    res.status(500).json({ error: 'Failed to fetch leads' });
  }
};

// Get a specific lead
const getLeadById = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await db.query('SELECT * FROM leads WHERE id = $1', [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Lead not found' });
    }

    // Decrypt sensitive fields before returning
    const decryptedLead = decryptFields(result.rows[0], SENSITIVE_FIELDS);

    res.json({
      success: true,
      lead: decryptedLead
    });

  } catch (error) {
    logger.error('Error fetching lead:', error);
    res.status(500).json({ error: 'Failed to fetch lead' });
  }
};

// Update a lead
const updateLead = async (req, res) => {
  try {
    const { id } = req.params;
    const { status, notes, assignedTo } = req.body;

    const query = `
      UPDATE leads
      SET status = COALESCE($1, status),
          notes = COALESCE($2, notes),
          assigned_to = COALESCE($3, assigned_to),
          updated_at = NOW()
      WHERE id = $4
      RETURNING *
    `;

    const result = await db.query(query, [status, notes, assignedTo, id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Lead not found' });
    }

    logger.info('Lead updated', { id, status });

    res.json({
      success: true,
      lead: result.rows[0]
    });

  } catch (error) {
    logger.error('Error updating lead:', error);
    res.status(500).json({ error: 'Failed to update lead' });
  }
};

// Delete a lead
const deleteLead = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await db.query('DELETE FROM leads WHERE id = $1 RETURNING id', [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Lead not found' });
    }

    logger.info('Lead deleted', { id });

    res.json({
      success: true,
      message: 'Lead deleted successfully'
    });

  } catch (error) {
    logger.error('Error deleting lead:', error);
    res.status(500).json({ error: 'Failed to delete lead' });
  }
};

module.exports = {
  authMiddleware,
  createLead,
  getLeads,
  getLeadById,
  updateLead,
  deleteLead
};
