/**
 * Email Service
 * Handles sending notification and confirmation emails
 */

const nodemailer = require('nodemailer');
const { logger } = require('../utils/logger');

// Create transporter
const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST || 'smtp.gmail.com',
  port: parseInt(process.env.SMTP_PORT) || 587,
  secure: false,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS
  }
});

// Practice area display names
const practiceAreaNames = {
  'personal-injury': 'Personal Injury',
  'premises-liability': 'Premises Liability',
  'property-damage': 'Property Damage',
  'insurance-bad-faith': 'Insurance Bad Faith',
  'lemon-law': 'Lemon Law',
  'family-law': 'Family Law',
  'criminal-defense': 'Criminal Defense',
  'estate-planning': 'Estate Planning',
  'employment-law': 'Employment Law',
  'immigration': 'Immigration',
  'bankruptcy': 'Bankruptcy',
  'business-law': 'Business Law',
  'real-estate-law': 'Real Estate Law',
  'medical-malpractice': 'Medical Malpractice',
  'workers-comp': 'Workers\' Compensation'
};

// Send notification to firm about new lead
const sendNewLeadNotification = async (lead) => {
  const {
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
  } = lead;

  const practiceAreaName = practiceAreaNames[practiceArea] || practiceArea;
  const urgencyLabel = {
    urgent: '🔴 URGENT',
    normal: '🟡 Normal',
    informational: '🟢 Informational'
  }[urgency] || urgency;

  const mailOptions = {
    from: process.env.SMTP_FROM || 'leads@kitsinianlaw.com',
    to: process.env.LEAD_NOTIFICATION_EMAIL || 'intake@kitsinianlaw.com',
    subject: `${urgencyLabel} New Lead: ${practiceAreaName} - ${firstName} ${lastName}`,
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <div style="background-color: #05172f; color: white; padding: 20px; text-align: center;">
          <h1 style="margin: 0;">New Lead Received</h1>
        </div>

        <div style="padding: 20px; background-color: #f5f5f5;">
          <div style="background-color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
            <h2 style="color: #05172f; margin-top: 0;">Contact Information</h2>
            <table style="width: 100%; border-collapse: collapse;">
              <tr>
                <td style="padding: 8px 0; color: #666;">Name:</td>
                <td style="padding: 8px 0;"><strong>${firstName} ${lastName}</strong></td>
              </tr>
              <tr>
                <td style="padding: 8px 0; color: #666;">Email:</td>
                <td style="padding: 8px 0;"><a href="mailto:${email}">${email}</a></td>
              </tr>
              <tr>
                <td style="padding: 8px 0; color: #666;">Phone:</td>
                <td style="padding: 8px 0;"><a href="tel:${phone}">${phone}</a></td>
              </tr>
              <tr>
                <td style="padding: 8px 0; color: #666;">Preferred Contact:</td>
                <td style="padding: 8px 0;">${preferredContact}</td>
              </tr>
            </table>
          </div>

          <div style="background-color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
            <h2 style="color: #05172f; margin-top: 0;">Case Information</h2>
            <table style="width: 100%; border-collapse: collapse;">
              <tr>
                <td style="padding: 8px 0; color: #666;">Practice Area:</td>
                <td style="padding: 8px 0;"><strong>${practiceAreaName}</strong></td>
              </tr>
              <tr>
                <td style="padding: 8px 0; color: #666;">Urgency:</td>
                <td style="padding: 8px 0;">${urgencyLabel}</td>
              </tr>
              <tr>
                <td style="padding: 8px 0; color: #666;">Submitted:</td>
                <td style="padding: 8px 0;">${new Date(createdAt).toLocaleString()}</td>
              </tr>
            </table>

            ${description ? `
              <h3 style="color: #05172f;">Description</h3>
              <p style="background-color: #f5f5f5; padding: 15px; border-radius: 4px;">${description}</p>
            ` : ''}
          </div>

          <div style="text-align: center; padding: 20px;">
            <p style="color: #666; margin: 0;">Lead ID: ${id}</p>
            <p style="color: #666; margin: 5px 0;">Source: iOS App</p>
          </div>
        </div>
      </div>
    `
  };

  try {
    await transporter.sendMail(mailOptions);
    logger.info('Lead notification email sent', { leadId: id });
  } catch (error) {
    logger.error('Failed to send lead notification:', error);
    throw error;
  }
};

// Send confirmation to lead
const sendLeadConfirmation = async ({ email, firstName, practiceArea }) => {
  const practiceAreaName = practiceAreaNames[practiceArea] || practiceArea;

  const mailOptions = {
    from: process.env.SMTP_FROM || 'noreply@kitsinianlaw.com',
    to: email,
    subject: 'We Received Your Request - Kitsinian Law Firm',
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <div style="background-color: #05172f; color: white; padding: 20px; text-align: center;">
          <h1 style="margin: 0;">Kitsinian Law Firm, APC</h1>
        </div>

        <div style="padding: 30px; background-color: #f5f5f5;">
          <div style="background-color: white; padding: 30px; border-radius: 8px;">
            <h2 style="color: #05172f; margin-top: 0;">Thank You, ${firstName}!</h2>

            <p>We have received your request regarding <strong>${practiceAreaName || 'your legal matter'}</strong>.</p>

            <p>A member of our team will review your information and contact you within <strong>24 hours</strong> (or sooner for urgent matters).</p>

            <h3 style="color: #05172f;">What Happens Next?</h3>
            <ol style="color: #333; line-height: 1.8;">
              <li>Our team reviews your submission</li>
              <li>We'll contact you using your preferred method</li>
              <li>We'll discuss your situation and explain your options</li>
              <li>If we can help, we'll outline next steps</li>
            </ol>

            <p style="background-color: #e8f4e8; padding: 15px; border-radius: 4px; border-left: 4px solid #4CAF50;">
              <strong>Note:</strong> This communication does not create an attorney-client relationship. Your information is kept confidential.
            </p>

            <hr style="border: none; border-top: 1px solid #eee; margin: 30px 0;">

            <p style="color: #666;">
              Need immediate assistance?<br>
              <strong>Call us: (XXX) XXX-XXXX</strong>
            </p>
          </div>
        </div>

        <div style="text-align: center; padding: 20px; color: #666; font-size: 12px;">
          <p>Kitsinian Law Firm, APC<br>Los Angeles, California</p>
          <p>This email was sent because you submitted a request through our app.</p>
        </div>
      </div>
    `
  };

  try {
    await transporter.sendMail(mailOptions);
    logger.info('Lead confirmation email sent', { email });
  } catch (error) {
    logger.error('Failed to send confirmation email:', error);
    throw error;
  }
};

module.exports = {
  sendNewLeadNotification,
  sendLeadConfirmation
};
