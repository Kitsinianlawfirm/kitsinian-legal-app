/**
 * Lead Routes
 * Handles lead submission and management
 */

const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const leadController = require('../controllers/leadController');

// Validation middleware
const validateLead = [
  body('firstName')
    .trim()
    .notEmpty().withMessage('First name is required')
    .isLength({ max: 100 }).withMessage('First name too long'),

  body('lastName')
    .trim()
    .notEmpty().withMessage('Last name is required')
    .isLength({ max: 100 }).withMessage('Last name too long'),

  body('email')
    .trim()
    .isEmail().withMessage('Valid email is required')
    .normalizeEmail(),

  body('phone')
    .trim()
    .notEmpty().withMessage('Phone number is required')
    .isLength({ min: 10, max: 20 }).withMessage('Invalid phone number'),

  body('preferredContact')
    .optional()
    .isIn(['phone', 'email', 'text']).withMessage('Invalid contact preference'),

  body('practiceArea')
    .optional()
    .trim()
    .isLength({ max: 100 }),

  body('urgency')
    .optional()
    .isIn(['urgent', 'normal', 'informational']),

  body('description')
    .optional()
    .trim()
    .isLength({ max: 5000 }).withMessage('Description too long'),

  // Validation result handler
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        errors: errors.array()
      });
    }
    next();
  }
];

// POST /api/leads - Submit a new lead
router.post('/', validateLead, leadController.createLead);

// GET /api/leads - Get all leads (protected - for admin)
router.get('/', leadController.authMiddleware, leadController.getLeads);

// GET /api/leads/:id - Get a specific lead (protected)
router.get('/:id', leadController.authMiddleware, leadController.getLeadById);

// PUT /api/leads/:id - Update a lead (protected)
router.put('/:id', leadController.authMiddleware, leadController.updateLead);

// DELETE /api/leads/:id - Delete a lead (protected)
router.delete('/:id', leadController.authMiddleware, leadController.deleteLead);

module.exports = router;
