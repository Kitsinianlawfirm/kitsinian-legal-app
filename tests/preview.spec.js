// ClaimIt Preview - Playwright Tests
// Run with: npx playwright test tests/preview.spec.js

const { test, expect } = require('@playwright/test');

const PREVIEW_URL = 'file:///Users/hkitsinian/kitsinian-legal-app/preview/index.html';

test.describe('ClaimIt Preview Tests', () => {

  test.beforeEach(async ({ page }) => {
    await page.goto(PREVIEW_URL);
    // Wait for page to load
    await page.waitForSelector('.device-frame');

    // Skip onboarding by calling the function directly
    await page.evaluate(() => {
      const onboarding = document.getElementById('onboarding');
      if (onboarding) {
        onboarding.classList.add('hidden');
      }
    });
    await page.waitForTimeout(300);
  });

  test.describe('Navigation', () => {

    test('all tabs should be clickable and show correct screens', async ({ page }) => {
      // Test each tab
      await page.click('#tab-claim');
      await expect(page.locator('#screen-claim')).toHaveClass(/active/);

      await page.click('#tab-learn');
      await expect(page.locator('#screen-learn')).toHaveClass(/active/);

      await page.click('#tab-account');
      await expect(page.locator('#screen-account')).toHaveClass(/active/);

      await page.click('#tab-home');
      await expect(page.locator('#screen-home')).toHaveClass(/active/);
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

    test('should show quiz options on claim tab', async ({ page }) => {
      await page.click('#tab-claim');
      await page.waitForTimeout(300);

      // Quiz step 1 should be visible with options
      await expect(page.locator('#quiz-step-1')).toBeVisible();
      await expect(page.locator('.quiz-option').first()).toBeVisible();
    });

    test('should advance through quiz steps', async ({ page }) => {
      await page.click('#tab-claim');
      await page.waitForTimeout(300);

      // Step 1: Select case type (click the first quiz option)
      await page.locator('.quiz-option').first().click();
      await page.waitForTimeout(500);

      // Step 2 should appear
      await expect(page.locator('#quiz-step-2')).toBeVisible();
    });
  });

  test.describe('Modals', () => {

    test('sign-in modal should open and close', async ({ page }) => {
      // Click sign-in button
      await page.click('#signin-btn');
      await page.waitForTimeout(300);

      // Modal should be visible
      await expect(page.locator('#signin-modal')).toHaveClass(/active/);

      // Close modal
      await page.click('#signin-modal .modal-close');
      await page.waitForTimeout(300);

      // Modal should be hidden
      await expect(page.locator('#signin-modal')).not.toHaveClass(/active/);
    });

    test('modals should be contained within device screen', async ({ page }) => {
      await page.click('#signin-btn');
      await page.waitForTimeout(300);

      // Verify modal is visible and has position absolute (contained in device-screen)
      const modal = page.locator('#signin-modal');
      await expect(modal).toBeVisible();

      // Check that modal has position absolute (not fixed - which would break containment)
      const position = await modal.evaluate(el => getComputedStyle(el).position);
      expect(position).toBe('absolute');
    });
  });

  test.describe('Accessibility', () => {

    test('tabs should have correct ARIA attributes', async ({ page }) => {
      const homeTab = page.locator('#tab-home');
      await expect(homeTab).toHaveAttribute('role', 'tab');
      await expect(homeTab).toHaveAttribute('aria-selected', 'true');
    });

    test('sign-in modal should have ARIA attributes', async ({ page }) => {
      await expect(page.locator('#signin-modal')).toHaveAttribute('role', 'dialog');
      await expect(page.locator('#signin-modal')).toHaveAttribute('aria-modal', 'true');
    });
  });

  test.describe('Practice Areas', () => {

    test('should show practice areas on Learn screen', async ({ page }) => {
      await page.click('#tab-learn');

      // Check some practice areas are visible
      await expect(page.locator('.learn-screen')).toBeVisible();
    });
  });

  test.describe('Home Screen', () => {

    test('should show home screen with CTA button', async ({ page }) => {
      await expect(page.locator('#screen-home')).toBeVisible();
      await expect(page.locator('#screen-home .btn-primary')).toBeVisible();
    });

    test('CTA should navigate to claim tab', async ({ page }) => {
      await page.locator('#screen-home .btn-primary').click();
      await page.waitForTimeout(300);
      await expect(page.locator('#screen-claim')).toHaveClass(/active/);
    });
  });

  test.describe('Tablet View', () => {

    test('iPad view should work with navigation', async ({ page }) => {
      await page.click('#toggle-ipad');
      await page.waitForTimeout(300);

      // Verify tablet mode active
      await expect(page.locator('.device-frame')).toHaveClass(/tablet/);

      // Test navigation works
      await page.click('#tab-claim');
      await expect(page.locator('#screen-claim')).toHaveClass(/active/);

      await page.click('#tab-learn');
      await expect(page.locator('#screen-learn')).toHaveClass(/active/);
    });

    test('modals should work in tablet view', async ({ page }) => {
      await page.click('#toggle-ipad');
      await page.waitForTimeout(300);

      // Test modal
      await page.click('#signin-btn');
      await page.waitForTimeout(300);
      await expect(page.locator('#signin-modal')).toHaveClass(/active/);

      await page.click('#signin-modal .modal-close');
      await page.waitForTimeout(300);
      await expect(page.locator('#signin-modal')).not.toHaveClass(/active/);
    });
  });

  test.describe('Form Elements', () => {

    test('form inputs should have proper attributes', async ({ page }) => {
      await page.click('#signin-btn');
      await page.waitForTimeout(300);

      // Check phone input
      const phoneInput = page.locator('#signin-phone');
      await expect(phoneInput).toHaveAttribute('type', 'tel');
      await expect(phoneInput).toHaveAttribute('autocomplete', 'tel');
      await expect(phoneInput).toHaveAttribute('maxlength', '14');

      // Check email input
      const emailInput = page.locator('#signin-email');
      await expect(emailInput).toHaveAttribute('type', 'email');
      await expect(emailInput).toHaveAttribute('autocomplete', 'email');
    });
  });
});
