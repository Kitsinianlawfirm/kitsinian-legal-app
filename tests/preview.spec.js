// ClaimIt Preview - Playwright Tests
// Run with: npx playwright test tests/preview.spec.js

const { test, expect } = require('@playwright/test');

const PREVIEW_URL = 'file:///Users/hkitsinian/kitsinian-legal-app/preview/index.html';

test.describe('ClaimIt Preview Tests', () => {

  test.beforeEach(async ({ page }) => {
    await page.goto(PREVIEW_URL);
    // Wait for page to load
    await page.waitForSelector('.device-frame');
  });

  test.describe('Navigation', () => {

    test('all tabs should be clickable and show correct screens', async ({ page }) => {
      const tabs = ['home', 'claim', 'learn', 'account'];

      for (const tab of tabs) {
        await page.click(`#tab-${tab}`);
        await expect(page.locator(`#screen-${tab}`)).toHaveClass(/active/);
      }
    });

    test('device toggle should switch between iPhone and iPad', async ({ page }) => {
      // Check default is iPhone
      await expect(page.locator('.device-frame')).not.toHaveClass(/tablet/);

      // Switch to iPad
      await page.click('#toggle-ipad');
      await expect(page.locator('.device-frame')).toHaveClass(/tablet/);

      // Switch back to iPhone
      await page.click('#toggle-iphone');
      await expect(page.locator('.device-frame')).not.toHaveClass(/tablet/);
    });
  });

  test.describe('Quiz Flow', () => {

    test('should complete quiz flow end-to-end', async ({ page }) => {
      // Go to Claim tab
      await page.click('#tab-claim');

      // Start quiz
      await page.click('text=Start Free Evaluation');

      // Step 1: Select case type
      await page.click('text=Car or vehicle accident');

      // Step 2: Answer follow-up (should show car-specific question)
      await page.waitForSelector('text=Were you the driver');
      await page.click('text=Driver');

      // Step 3: Injury question
      await page.click('text=Yes, I was injured');

      // Step 4: Timeline
      await page.click('text=Within the last week');

      // Should show contact form
      await expect(page.locator('.contact-form-container')).toBeVisible();
    });
  });

  test.describe('Modals', () => {

    test('sign-in modal should open and close', async ({ page }) => {
      // Click sign-in button
      await page.click('#signin-btn');

      // Modal should be visible
      await expect(page.locator('#signin-modal')).toHaveClass(/active/);

      // Close modal
      await page.click('#signin-modal .modal-close');

      // Modal should be hidden
      await expect(page.locator('#signin-modal')).not.toHaveClass(/active/);
    });

    test('privacy policy modal should open from footer', async ({ page }) => {
      // Click privacy link
      await page.click('text=Privacy Policy');

      // Modal should be visible
      await expect(page.locator('#privacy-modal')).toHaveClass(/active/);
    });

    test('modals should stay inside device frame', async ({ page }) => {
      await page.click('#signin-btn');

      const modal = page.locator('#signin-modal');
      const frame = page.locator('.device-frame');

      const modalBox = await modal.boundingBox();
      const frameBox = await frame.boundingBox();

      // Modal should be within frame bounds
      expect(modalBox.x).toBeGreaterThanOrEqual(frameBox.x);
      expect(modalBox.y).toBeGreaterThanOrEqual(frameBox.y);
    });
  });

  test.describe('Forms', () => {

    test('contact form should validate required fields', async ({ page }) => {
      // Navigate to a form (via quiz)
      await page.click('#tab-claim');
      await page.click('text=Start Free Evaluation');
      await page.click('text=Car or vehicle accident');
      await page.click('text=Driver');
      await page.click('text=Yes, I was injured');
      await page.click('text=Within the last week');

      // Try to submit empty form
      await page.click('text=Submit My Case');

      // Form should show validation (HTML5 validation)
      const nameInput = page.locator('input[name="name"]');
      await expect(nameInput).toHaveAttribute('required', '');
    });

    test('form inputs should have proper attributes', async ({ page }) => {
      await page.click('#tab-claim');
      await page.click('text=Start Free Evaluation');
      await page.click('text=Car or vehicle accident');
      await page.click('text=Driver');
      await page.click('text=Yes, I was injured');
      await page.click('text=Within the last week');

      // Check autocomplete attributes
      await expect(page.locator('input[name="name"]')).toHaveAttribute('autocomplete', 'name');
      await expect(page.locator('input[name="phone"]')).toHaveAttribute('autocomplete', 'tel');
      await expect(page.locator('input[name="email"]')).toHaveAttribute('autocomplete', 'email');

      // Check maxlength attributes
      await expect(page.locator('input[name="name"]')).toHaveAttribute('maxlength', '100');
      await expect(page.locator('input[name="phone"]')).toHaveAttribute('maxlength', '14');
    });
  });

  test.describe('Accessibility', () => {

    test('interactive elements should be keyboard accessible', async ({ page }) => {
      // Tab through elements
      await page.keyboard.press('Tab');

      // Should focus skip link first
      const focused = page.locator(':focus');
      await expect(focused).toHaveAttribute('href', '#main-content');
    });

    test('tabs should have correct ARIA attributes', async ({ page }) => {
      const homeTab = page.locator('#tab-home');
      await expect(homeTab).toHaveAttribute('role', 'button');
      await expect(homeTab).toHaveAttribute('aria-selected', 'true');
    });
  });

  test.describe('Practice Areas', () => {

    test('should show all practice areas on Learn screen', async ({ page }) => {
      await page.click('#tab-learn');

      // Check in-house areas visible
      await expect(page.locator('text=Personal Injury')).toBeVisible();
      await expect(page.locator('text=Premises Liability')).toBeVisible();
      await expect(page.locator('text=Property Damage')).toBeVisible();
      await expect(page.locator('text=Insurance Bad Faith')).toBeVisible();
      await expect(page.locator('text=Lemon Law')).toBeVisible();
    });

    test('clicking practice area should show detail view', async ({ page }) => {
      await page.click('#tab-learn');
      await page.click('text=Personal Injury');

      // Should show article detail
      await expect(page.locator('#article-pa-personal-injury')).toHaveClass(/active/);
    });
  });

  test.describe('Tablet View', () => {

    test('iPad view should show sidebar navigation', async ({ page }) => {
      await page.click('#toggle-ipad');

      // Tab bar should be styled as sidebar (check CSS)
      const tabBar = page.locator('.tab-bar');
      await expect(tabBar).toBeVisible();
    });

    test('all functionality should work in tablet view', async ({ page }) => {
      await page.click('#toggle-ipad');

      // Test navigation
      await page.click('#tab-claim');
      await expect(page.locator('#screen-claim')).toHaveClass(/active/);

      // Test modal
      await page.click('#signin-btn');
      await expect(page.locator('#signin-modal')).toHaveClass(/active/);
    });
  });
});
