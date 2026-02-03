/**
 * Lead Docket Integration Service
 *
 * Sends leads to Lead Docket (Filevine) CRM automatically
 * when new leads are submitted through ClaimIt.
 *
 * Lead Docket API Documentation:
 * https://support.leaddocket.com/hc/en-us/articles/360045902691-Integrating-Third-Party-Sources-With-Lead-Docket
 */

const { logger } = require('../utils/logger');

/**
 * Maps ClaimIt lead data to Lead Docket field format
 *
 * Field mapping matches Kitsinian Law's Lead Docket integration:
 * - First → First Name
 * - Last → Last Name
 * - Phone → Mobile Phone
 * - Email → Email
 * - Summary → Summary (contains case details)
 */
function mapLeadToLeadDocket(lead) {
  // Build a comprehensive summary with all case details
  const summaryParts = [];

  if (lead.practiceArea) {
    summaryParts.push(`Practice Area: ${lead.practiceArea}`);
  }
  if (lead.practiceAreaCategory) {
    summaryParts.push(`Category: ${lead.practiceAreaCategory}`);
  }
  if (lead.urgency) {
    summaryParts.push(`Urgency: ${lead.urgency}`);
  }
  if (lead.preferredContact) {
    summaryParts.push(`Preferred Contact: ${lead.preferredContact}`);
  }
  if (lead.description) {
    summaryParts.push(`\nDescription: ${lead.description}`);
  }
  if (lead.quizAnswers && Object.keys(lead.quizAnswers).length > 0) {
    summaryParts.push(`\nQuiz Answers: ${JSON.stringify(lead.quizAnswers)}`);
  }
  summaryParts.push(`\nSource: ClaimIt App (${lead.source || 'ios_app'})`);
  summaryParts.push(`ClaimIt Lead ID: ${lead.id}`);

  return {
    First: lead.firstName,
    Last: lead.lastName,
    Phone: lead.phone,
    Email: lead.email,
    Summary: summaryParts.join('\n')
  };
}

/**
 * Sends a lead to Lead Docket
 *
 * @param {Object} lead - The lead data from ClaimIt
 * @returns {Promise<Object>} - Lead Docket response with opportunityId
 */
async function sendToLeadDocket(lead) {
  const endpointUrl = process.env.LEAD_DOCKET_ENDPOINT_URL;

  if (!endpointUrl) {
    logger.warn('Lead Docket integration not configured - LEAD_DOCKET_ENDPOINT_URL not set');
    return { success: false, message: 'Lead Docket not configured' };
  }

  try {
    const mappedData = mapLeadToLeadDocket(lead);

    // Build form data (application/x-www-form-urlencoded)
    const formBody = Object.entries(mappedData)
      .filter(([_, value]) => value !== undefined && value !== null && value !== '')
      .map(([key, value]) => `${encodeURIComponent(key)}=${encodeURIComponent(value)}`)
      .join('&');

    logger.info('Sending lead to Lead Docket', {
      leadId: lead.id,
      practiceArea: lead.practiceArea
    });

    // Add timeout to prevent hanging (10 seconds)
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 10000);

    const response = await fetch(endpointUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: formBody,
      signal: controller.signal
    });

    clearTimeout(timeoutId);

    const result = await response.json();

    if (result.success) {
      logger.info('Lead successfully sent to Lead Docket', {
        leadId: lead.id,
        opportunityId: result.opportunityId
      });
      return {
        success: true,
        opportunityId: result.opportunityId,
        message: 'Lead synced to Lead Docket'
      };
    } else {
      logger.error('Lead Docket rejected lead', {
        leadId: lead.id,
        error: result.message
      });
      return {
        success: false,
        message: result.message || 'Lead Docket rejected the submission'
      };
    }

  } catch (error) {
    logger.error('Failed to send lead to Lead Docket', {
      leadId: lead.id,
      error: error.message
    });
    return {
      success: false,
      message: `Lead Docket sync failed: ${error.message}`
    };
  }
}

/**
 * Batch sync multiple leads to Lead Docket
 * Useful for syncing historical leads
 *
 * @param {Array} leads - Array of lead objects
 * @returns {Promise<Object>} - Summary of sync results
 */
async function batchSyncToLeadDocket(leads) {
  const results = {
    total: leads.length,
    successful: 0,
    failed: 0,
    errors: []
  };

  for (const lead of leads) {
    const result = await sendToLeadDocket(lead);
    if (result.success) {
      results.successful++;
    } else {
      results.failed++;
      results.errors.push({ leadId: lead.id, error: result.message });
    }

    // Rate limiting - wait 100ms between requests
    await new Promise(resolve => setTimeout(resolve, 100));
  }

  logger.info('Batch Lead Docket sync complete', results);
  return results;
}

module.exports = {
  sendToLeadDocket,
  batchSyncToLeadDocket,
  mapLeadToLeadDocket
};
