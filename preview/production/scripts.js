        };

        // ==================== EVENT DELEGATION SYSTEM ====================
        // Central event handler for data-action attributes
        // This replaces inline onclick handlers for better maintainability
        document.addEventListener('DOMContentLoaded', function() {
            const screenContainer = document.querySelector('.device-screen');
            if (!screenContainer) return;

            screenContainer.addEventListener('click', function(e) {
                // Find closest element with data-action
                const actionEl = e.target.closest('[data-action]');
                if (!actionEl) return;

                const action = actionEl.dataset.action;

                // Route to appropriate handler
                switch(action) {
                    case 'switch-tab':
                        e.preventDefault();
                        switchTab(actionEl.dataset.tab);
                        break;
                    case 'show-article':
                        e.preventDefault();
                        showArticle(actionEl.dataset.article);
                        break;
                    case 'hide-article':
                        e.preventDefault();
                        hideArticle();
                        break;
                    case 'toggle-faq':
                        e.preventDefault();
                        toggleFaq(actionEl);
                        break;
                    case 'toggle-check':
                        e.preventDefault();
                        toggleCheck(actionEl);
                        break;
                    case 'show-privacy':
                        e.preventDefault();
                        showPrivacyModal();
                        break;
                    case 'show-terms':
                        e.preventDefault();
                        showTermsModal();
                        break;
                    case 'show-signin':
                        e.preventDefault();
                        toggleSignIn();
                        break;
                    case 'start-quiz':
                        e.preventDefault();
                        const topic = actionEl.dataset.topic;
                        if (topic) {
                            startQuizWithTopic(topic);
                        } else {
                            switchTab('claim');
                        }
                        break;
                }
            });
        });

        // Dynamic questions for Step 2 based on case type
        const step2Questions = {
            'car-accident': {
                question: 'What was your role in the accident?',
                subtext: 'This helps us understand your situation',
                options: [
                    { value: 'driver', label: 'I was driving', icon: 'car' },
                    { value: 'passenger', label: 'I was a passenger', icon: 'injury' },
                    { value: 'pedestrian', label: 'Pedestrian or cyclist', icon: 'fall' },
                    { value: 'parked', label: 'My parked car was hit', icon: 'property' },
                    { value: 'rideshare', label: 'Uber/Lyft accident', icon: 'car' }
                ]
            },
            'injury': {
                question: 'How were you injured?',
                subtext: 'Select the cause of your injury',
                options: [
                    { value: 'work-accident', label: 'Accident at work', icon: 'work' },
                    { value: 'medical', label: 'Medical malpractice', icon: 'hospital' },
                    { value: 'product', label: 'Defective product', icon: 'denied' },
                    { value: 'dog-bite', label: 'Dog bite or animal attack', icon: 'injury' },
                    { value: 'assault', label: 'Assault or battery', icon: 'injury' },
                    { value: 'other-injury', label: 'Other injury', icon: 'question' }
                ]
            },
            'slip-fall': {
                question: 'Where did you fall?',
                subtext: 'The location affects who may be liable',
                options: [
                    { value: 'store', label: 'Store or business', icon: 'building' },
                    { value: 'apartment', label: 'Apartment or rental', icon: 'home' },
                    { value: 'sidewalk', label: 'Sidewalk or public area', icon: 'location' },
                    { value: 'workplace', label: 'At my workplace', icon: 'work' },
                    { value: 'private', label: 'Private residence', icon: 'home' },
                    { value: 'other-location', label: 'Other location', icon: 'question' }
                ]
            },
            'insurance': {
                question: "What's happening with your claim?",
                subtext: 'Tell us about the dispute',
                options: [
                    { value: 'denied', label: 'My claim was denied', icon: 'denied' },
                    { value: 'delayed', label: 'Unreasonable delays', icon: 'clock' },
                    { value: 'lowball', label: 'Lowball settlement offer', icon: 'lowball' },
                    { value: 'cancelled', label: 'Policy cancelled unfairly', icon: 'denied' },
                    { value: 'other-insurance', label: 'Other dispute', icon: 'question' }
                ]
            },
            'lemon': {
                question: "What's wrong with your vehicle?",
                subtext: 'Select the main issue',
                options: [
                    { value: 'engine', label: 'Engine or transmission', icon: 'car' },
                    { value: 'electrical', label: 'Electrical problems', icon: 'lightning' },
                    { value: 'safety', label: 'Safety defects (brakes, steering)', icon: 'shield' },
                    { value: 'recurring', label: 'Same problem keeps returning', icon: 'alarm' },
                    { value: 'multiple', label: 'Multiple different issues', icon: 'question' }
                ]
            },
            'property': {
                question: 'What type of property damage?',
                subtext: 'Select what was damaged',
                options: [
                    { value: 'vehicle-damage', label: 'Vehicle from accident', icon: 'car' },
                    { value: 'fire', label: 'Fire damage', icon: 'alarm' },
                    { value: 'water', label: 'Water or flood damage', icon: 'property' },
                    { value: 'theft', label: 'Theft or vandalism', icon: 'denied' },
                    { value: 'other-damage', label: 'Other property damage', icon: 'question' }
                ]
            },
            'other': {
                question: 'What type of legal help do you need?',
                subtext: 'We can connect you with the right attorney',
                options: [
                    { value: 'employment', label: 'Employment or workplace issue', icon: 'work' },
                    { value: 'family', label: 'Family law matter', icon: 'family' },
                    { value: 'criminal', label: 'Criminal defense', icon: 'gavel' },
                    { value: 'business', label: 'Business dispute', icon: 'document' },
                    { value: 'other-legal', label: 'Something else', icon: 'question' }
                ]
            },
            // Referral Network practice areas
            'family-law': {
                question: 'What family law matter do you need help with?',
                subtext: 'Select the option that best describes your situation',
                options: [
                    { value: 'divorce', label: 'Divorce or separation', icon: 'family' },
                    { value: 'custody', label: 'Child custody or visitation', icon: 'family' },
                    { value: 'support', label: 'Child or spousal support', icon: 'document' },
                    { value: 'adoption', label: 'Adoption or guardianship', icon: 'family' },
                    { value: 'domestic-violence', label: 'Domestic violence / restraining order', icon: 'shield' },
                    { value: 'other-family', label: 'Other family matter', icon: 'question' }
                ]
            },
            'criminal-defense': {
                question: 'What type of criminal matter?',
                subtext: 'All consultations are confidential',
                options: [
                    { value: 'dui', label: 'DUI / DWI', icon: 'car' },
                    { value: 'drug', label: 'Drug charges', icon: 'gavel' },
                    { value: 'theft', label: 'Theft or property crimes', icon: 'denied' },
                    { value: 'assault', label: 'Assault or violent crimes', icon: 'injury' },
                    { value: 'traffic', label: 'Traffic violations', icon: 'car' },
                    { value: 'other-criminal', label: 'Other criminal matter', icon: 'question' }
                ]
            },
            'employment-law': {
                question: 'What employment issue are you facing?',
                subtext: 'Tell us about your workplace situation',
                options: [
                    { value: 'wrongful-termination', label: 'Wrongful termination', icon: 'denied' },
                    { value: 'discrimination', label: 'Discrimination or harassment', icon: 'injury' },
                    { value: 'wage', label: 'Unpaid wages or overtime', icon: 'document' },
                    { value: 'retaliation', label: 'Retaliation for reporting', icon: 'shield' },
                    { value: 'contract', label: 'Employment contract dispute', icon: 'document' },
                    { value: 'other-employment', label: 'Other employment issue', icon: 'question' }
                ]
            },
            'real-estate': {
                question: 'What real estate issue do you have?',
                subtext: 'Select the option that applies',
                options: [
                    { value: 'landlord-tenant', label: 'Landlord-tenant dispute', icon: 'home' },
                    { value: 'purchase', label: 'Purchase or sale issue', icon: 'document' },
                    { value: 'boundary', label: 'Boundary or neighbor dispute', icon: 'building' },
                    { value: 'hoa', label: 'HOA dispute', icon: 'building' },
                    { value: 'foreclosure', label: 'Foreclosure', icon: 'denied' },
                    { value: 'other-realestate', label: 'Other real estate matter', icon: 'question' }
                ]
            }
        };

        function switchTab(tabName) {
            if (articleOpen) return;

            document.querySelectorAll('.tab').forEach(t => {
                t.classList.remove('active');
                t.setAttribute('aria-selected', 'false');
            });
            document.querySelectorAll('.screen:not(.detail-screen)').forEach(s => s.classList.remove('active'));

            const activeTab = document.getElementById('tab-' + tabName);
            activeTab.classList.add('active');
            activeTab.setAttribute('aria-selected', 'true');
            document.getElementById('screen-' + tabName).classList.add('active');

            const statusBar = document.getElementById('status-bar');
            statusBar.className = tabName === 'home' ? 'status-bar light' : 'status-bar dark';

            document.getElementById('screen-' + tabName).scrollTop = 0;
            currentScreen = tabName;

            // Update account UI when switching to account tab
            if (tabName === 'account') {
                updateAccountUI();
            }
        }

        function showArticle(articleId) {
            // First, hide any currently open article
            document.querySelectorAll('.detail-screen').forEach(s => s.classList.remove('active'));

            document.getElementById('screen-' + currentScreen).classList.add('slide-left');
            const article = document.getElementById('article-' + articleId);
            article.classList.add('active');
            article.scrollTop = 0;
            document.getElementById('tab-bar').classList.add('hidden');
            document.getElementById('status-bar').className = 'status-bar dark';
            articleOpen = true;
        }

        function hideArticle() {
            document.querySelectorAll('.detail-screen').forEach(s => s.classList.remove('active'));
            document.getElementById('screen-' + currentScreen).classList.remove('slide-left');
            document.getElementById('tab-bar').classList.remove('hidden');
            const statusBar = document.getElementById('status-bar');
            statusBar.className = currentScreen === 'home' ? 'status-bar light' : 'status-bar dark';
            articleOpen = false;
        }

        function goToStep(stepNum) {
            console.log('goToStep called with:', stepNum);
            document.querySelectorAll('.quiz-step').forEach(s => s.classList.remove('active'));
            const targetStep = document.getElementById('quiz-step-' + stepNum);
            if (targetStep) {
                targetStep.classList.add('active');
                console.log('Step ' + stepNum + ' activated');
            } else {
                console.error('Could not find quiz-step-' + stepNum);
            }
            document.getElementById('progress-fill').style.width = progressSteps[stepNum] + '%';
            currentQuizStep = stepNum;
            document.getElementById('screen-claim').scrollTop = 0;

            // Launch confetti on success step
            if (stepNum === 5) {
                setTimeout(() => {
                    if (confetti && confetti.burst) {
                        confetti.burst(window.innerWidth / 2, window.innerHeight / 3);
                    }
                }, 300);
            }
        }

        function selectAndAdvance(element, value, nextStep) {
            console.log('selectAndAdvance called:', value, 'next:', nextStep, 'currentStep:', currentQuizStep);
            // Highlight selected option briefly
            const parentStep = element.closest('.quiz-step');
            if (parentStep) {
                parentStep.querySelectorAll('.quiz-option').forEach(o => o.classList.remove('selected'));
            }
            element.classList.add('selected');

            // Store answer
            quizAnswers['step' + currentQuizStep] = value;
            console.log('Stored answer:', quizAnswers);

            // Advance after short delay
            setTimeout(() => {
                console.log('Advancing to step:', nextStep);
                goToStep(nextStep);
            }, 200);
        }

        function selectCaseType(element, caseType) {
            // Highlight selected option
            const parentStep = element.closest('.quiz-step');
            if (parentStep) {
                parentStep.querySelectorAll('.quiz-option').forEach(o => o.classList.remove('selected'));
            }
            element.classList.add('selected');

            // Store case type
            quizAnswers.step1 = caseType;
            quizAnswers.caseType = caseType;

            // Populate Step 2 with dynamic questions
            const config = step2Questions[caseType];
            if (config) {
                document.getElementById('step2-question').textContent = config.question;
                document.getElementById('step2-subtext').textContent = config.subtext;

                const optionsContainer = document.getElementById('step2-options');
                optionsContainer.innerHTML = config.options.map(opt => `
                    <div class="quiz-option" onclick="selectAndAdvance(this, '${opt.value}', 3)">
                        <div class="quiz-option-icon">
                            <svg style="width: 26px; height: 26px; color: white;"><use href="#icon-${opt.icon}"/></svg>
                        </div>
                        <span>${opt.label}</span>
                    </div>
                `).join('');
            }

            // Advance to step 2
            setTimeout(() => {
                goToStep(2);
            }, 200);
        }

        function submitLead() {
            const name = document.getElementById('lead-name').value;
            const phone = document.getElementById('lead-phone').value;
            const email = document.getElementById('lead-email').value;
            const description = document.getElementById('lead-description').value;
            const submitBtn = document.getElementById('submit-btn');

            // Simple validation
            if (!name || !phone) {
                showToast('Please enter your name and phone number', 'error');
                return;
            }

            // Show loading state
            submitBtn.classList.add('loading');
            submitBtn.disabled = true;

            // Store lead info
            quizAnswers.name = name;
            quizAnswers.phone = phone;
            quizAnswers.email = email;
            quizAnswers.description = description;

            // Note: In production, submit to secure backend API here
            // Simulate API call with timeout (remove in production)
            setTimeout(() => {
                // Remove loading state before transitioning
                submitBtn.classList.remove('loading');
                submitBtn.disabled = false;

                // Get case type from step 1 answer
            const caseTypeMap = {
                'car-accident': 'Car Accident',
                'injury': 'Personal Injury',
                'slip-fall': 'Slip & Fall',
                'insurance': 'Insurance Dispute',
                'lemon': 'Lemon Law',
                'property': 'Property Damage',
                'family-law': 'Family Law',
                'criminal-defense': 'Criminal Defense',
                'employment-law': 'Employment Law',
                'real-estate': 'Real Estate',
                'other': 'Other',
                'referral': quizAnswers.referralArea || 'Referral'
            };
            const caseType = caseTypeMap[quizAnswers.step1] || 'General Inquiry';

            // Create new case
            const newCase = {
                id: Date.now(),
                type: caseType,
                submitted: new Date().toISOString().split('T')[0],
                status: 'submitted',
                attorney: null
            };

            // Add to user cases
            userCases.unshift(newCase);

            // Auto sign in the user if not already signed in
            if (!isSignedIn) {
                currentUser = {
                    name: name,
                    phone: phone,
                    email: email
                };
                isSignedIn = true;
                updateSignInButton();
            }

            console.log('Case created:', newCase);

            // Go to success step
            goToStep(5);
            }, 1500); // End setTimeout - simulates API call delay
        }

        function resetQuiz() {
            quizAnswers = {};
            currentQuizStep = 1;

            // Clear form fields
            document.getElementById('lead-name').value = '';
            document.getElementById('lead-phone').value = '';
            document.getElementById('lead-email').value = '';
            document.getElementById('lead-description').value = '';

            // Reset submit button state
            const submitBtn = document.getElementById('submit-btn');
            if (submitBtn) {
                submitBtn.classList.remove('loading');
                submitBtn.disabled = false;
            }

            // Clear selections
            document.querySelectorAll('.quiz-option').forEach(o => o.classList.remove('selected'));

            // Clear dynamic Step 2 options
            document.getElementById('step2-options').innerHTML = '';

            // Go back to step 1
            goToStep(1);
        }

        function toggleCheck(element) {
            element.querySelector('.check').classList.toggle('checked');
        }

        document.querySelectorAll('.category-chip').forEach(chip => {
            chip.addEventListener('click', function() {
                document.querySelectorAll('.category-chip').forEach(c => c.classList.remove('active'));
                this.classList.add('active');
            });
        });

        // Event delegation for quiz options (backup for inline onclick)
        document.addEventListener('click', function(e) {
            const quizOption = e.target.closest('.quiz-option');
            if (quizOption && quizOption.hasAttribute('onclick')) {
                console.log('Quiz option clicked via delegation:', quizOption);
            }
        });

        // ==================== ONBOARDING ====================
        function nextOnboarding() {
            document.getElementById('onboarding-1').classList.remove('active');
            document.getElementById('onboarding-1').classList.add('exit-left');
            document.getElementById('onboarding-2').classList.add('active');
            currentOnboardingScreen = 2;
        }

        function selectOnboardingOption(element, value) {
            document.querySelectorAll('.onboarding-option').forEach(o => o.classList.remove('selected'));
            element.classList.add('selected');
            selectedOnboardingOption = value;

            // Enable the continue button
            const btn = document.getElementById('onboarding-continue-btn');
            btn.style.opacity = '1';
            btn.style.pointerEvents = 'all';
        }

        // Accident Mode consent state
        let accidentModeConsent = true; // Default ON

        // Check if user has scrolled to bottom of legal agreement
        function checkLegalScroll() {
            const container = document.getElementById('legal-scroll-container');
            const btn = document.getElementById('btn-agree-continue');
            const indicator = document.getElementById('scroll-indicator');

            if (!container || !btn) return;

            // Check if scrolled near bottom (within 50px)
            const isAtBottom = container.scrollHeight - container.scrollTop - container.clientHeight < 50;

            if (isAtBottom) {
                btn.disabled = false;
                if (indicator) indicator.classList.add('hidden');
            }
        }

        // Proceed from legal agreement (screen 1) to welcome screen (screen 2)
        function proceedFromConsent() {
            // User agreed to terms - Accident Mode enabled by default
            // User can toggle it off in Settings if they choose
            localStorage.setItem('accidentModeEnabled', 'true');
            localStorage.setItem('userAgreedToTerms', 'true');

            // Update banner visibility
            updateAccidentBannerVisibility();

            // Go from consent (onboarding-3) to welcome (onboarding-1)
            // Use class-based transitions like nextOnboarding()
            document.getElementById('onboarding-3').classList.remove('active');
            document.getElementById('onboarding-3').classList.add('exit-left');
            document.getElementById('onboarding-1').classList.add('active');
        }

        function toggleAccidentConsent(element) {
            element.classList.toggle('active');
            accidentModeConsent = element.classList.contains('active');
        }

        // Complete onboarding after incident selection (final step)
        function completeOnboardingWithConsent() {
            if (!selectedOnboardingOption) return;

            // Store the answer for later
            quizAnswers['step1'] = selectedOnboardingOption;
            quizAnswers.caseType = selectedOnboardingOption;

            // Complete the quiz setup
            const config = step2Questions[selectedOnboardingOption];
            if (config) {
                document.getElementById('step2-question').textContent = config.question;
                document.getElementById('step2-subtext').textContent = config.subtext;

                const optionsContainer = document.getElementById('step2-options');
                optionsContainer.innerHTML = config.options.map(opt => `
                    <div class="quiz-option" onclick="selectAndAdvance(this, '${opt.value}', 3)">
                        <div class="quiz-option-icon">
                            <svg style="width: 26px; height: 26px; color: white;"><use href="#icon-${opt.icon}"/></svg>
                        </div>
                        <span>${opt.label}</span>
                    </div>
                `).join('');
            }

            // Hide onboarding
            document.getElementById('onboarding').classList.add('hidden');

            // Switch to claim tab and go to step 2
            switchTab('claim');

            // Small delay to let tab switch, then go to step 2
            setTimeout(() => {
                goToStep(2);
            }, 100);
        }

        function updateAccidentBannerVisibility() {
            const isEnabled = localStorage.getItem('accidentModeEnabled') === 'true';

            // Update Accident tab screen UI
            const statusBadge = document.getElementById('accident-status-badge');
            const statusText = document.getElementById('accident-status-text');
            const accidentToggle = document.getElementById('accident-mode-toggle');
            const accidentBtn = document.getElementById('manual-accident-btn');
            const tabDot = document.getElementById('accident-tab-dot');

            if (statusBadge) {
                if (isEnabled) {
                    statusBadge.classList.remove('disabled');
                    statusBadge.classList.add('enabled');
                } else {
                    statusBadge.classList.remove('enabled');
                    statusBadge.classList.add('disabled');
                }
            }

            if (statusText) {
                statusText.textContent = isEnabled ? 'Enabled & Ready' : 'Disabled';
            }

            if (accidentToggle) {
                if (isEnabled) {
                    accidentToggle.classList.add('active');
                } else {
                    accidentToggle.classList.remove('active');
                }
            }

            if (accidentBtn) {
                accidentBtn.disabled = !isEnabled;
            }

            if (tabDot) {
                tabDot.style.display = isEnabled ? 'block' : 'none';
            }

            // Also sync the settings toggle in Account screen
            const settingsToggle = document.getElementById('accident-settings-toggle');
            if (settingsToggle) {
                if (isEnabled) {
                    settingsToggle.classList.add('active');
                } else {
                    settingsToggle.classList.remove('active');
                }
            }
        }

        function toggleAccidentMode(element) {
            element.classList.toggle('active');
            const isEnabled = element.classList.contains('active');
            localStorage.setItem('accidentModeEnabled', isEnabled ? 'true' : 'false');
            updateAccidentBannerVisibility();
            showToast(isEnabled ? 'Accident Mode enabled' : 'Accident Mode disabled', 'success');
        }

        function toggleAccidentModeFromSettings(element) {
            element.classList.toggle('active');
            const isEnabled = element.classList.contains('active');
            localStorage.setItem('accidentModeEnabled', isEnabled ? 'true' : 'false');
            updateAccidentBannerVisibility();
            showToast(isEnabled ? 'Accident Mode enabled' : 'Accident Mode disabled', 'success');
        }

        function skipOnboarding() {
            // Save default accident mode preference (enabled)
            localStorage.setItem('accidentModeEnabled', 'true');
            updateAccidentBannerVisibility();
            document.getElementById('onboarding').classList.add('hidden');
        }

        // Start quiz with a specific topic pre-selected (for article CTAs)
        function startQuizWithTopic(topic) {
            // Hide any open article
            hideArticle();

            // Hide onboarding if visible
            document.getElementById('onboarding').classList.add('hidden');

            // Store the topic as step 1 answer
            quizAnswers.step1 = topic;
            quizAnswers.caseType = topic;

            // Populate Step 2 with dynamic questions
            const config = step2Questions[topic];
            if (config) {
                document.getElementById('step2-question').textContent = config.question;
                document.getElementById('step2-subtext').textContent = config.subtext;

                const optionsContainer = document.getElementById('step2-options');
                optionsContainer.innerHTML = config.options.map(opt => `
                    <div class="quiz-option" onclick="selectAndAdvance(this, '${opt.value}', 3)">
                        <div class="quiz-option-icon">
                            <svg style="width: 26px; height: 26px; color: white;"><use href="#icon-${opt.icon}"/></svg>
                        </div>
                        <span>${opt.label}</span>
                    </div>
                `).join('');
            }

            // Switch to claim tab
            switchTab('claim');

            // Go directly to step 2
            setTimeout(() => {
                goToStep(2);
            }, 100);
        }

        // ==================== AUTH & ACCOUNT FUNCTIONS ====================

        function toggleSignIn() {
            if (isSignedIn) {
                // Show account tab when signed in
                switchTab('account');
            } else {
                showSignInModal();
            }
        }

        function showSignInModal() {
            document.getElementById('signin-modal').classList.add('active');
        }

        function hideSignInModal() {
            document.getElementById('signin-modal').classList.remove('active');
            document.getElementById('signin-phone').value = '';
            document.getElementById('signin-email').value = '';
        }

        function signIn() {
            const phone = document.getElementById('signin-phone').value;
            const email = document.getElementById('signin-email').value;

            if (!phone) {
                showToast('Please enter your phone number', 'error');
                return;
            }

            // Demo: create mock user
            currentUser = {
                name: 'Demo User',
                phone: phone,
                email: email || 'demo@example.com'
            };

            // Load mock cases for demo
            userCases = [...mockCases];

            isSignedIn = true;
            hideSignInModal();
            updateSignInButton();
            updateAccountUI();
        }

        function signOut() {
            isSignedIn = false;
            currentUser = null;
            userCases = [];
            updateSignInButton();
            updateAccountUI();
        }

        function signInWithApple() {
            // Demo: simulate Apple sign-in
            showToast('Apple Sign-in coming in native app!', 'info');

            // For demo purposes, sign in with mock data
            setTimeout(() => {
                isSignedIn = true;
                currentUser = {
                    name: 'Apple User',
                    email: 'user@icloud.com',
                    phone: ''
                };

                // Load mock cases for demo
                userCases = [...mockCases];

                hideSignInModal();
                updateSignInButton();
                updateAccountUI();
                showToast('Signed in successfully!', 'success');
            }, 500);
        }

        function updateSignInButton() {
            const btn = document.getElementById('signin-btn');
            if (isSignedIn && currentUser) {
                btn.classList.add('signed-in');
                const initial = currentUser.name.charAt(0).toUpperCase();
                btn.innerHTML = '<span class="user-initial">' + initial + '</span>';
            } else {
                btn.classList.remove('signed-in');
                btn.innerHTML = '<svg><use href="#icon-user"/></svg>';
            }
        }

        function updateAccountUI() {
            const signinPrompt = document.getElementById('signin-prompt');
            const casesList = document.getElementById('cases-list');
            const casesContainer = document.getElementById('cases-container');

            if (isSignedIn && currentUser) {
                signinPrompt.style.display = 'none';
                casesList.classList.remove('hidden');

                // Update user profile
                document.getElementById('user-avatar').textContent = currentUser.name.charAt(0).toUpperCase();
                document.getElementById('user-name').textContent = currentUser.name;
                document.getElementById('user-phone').textContent = currentUser.phone;

                // Render cases
                renderCases(casesContainer);
            } else {
                signinPrompt.style.display = 'block';
                casesList.classList.add('hidden');
            }
        }

        function renderCases(container) {
            if (userCases.length === 0) {
                container.innerHTML = `
                    <div class="no-cases-message">
                        <svg><use href="#icon-briefcase"/></svg>
                        <h3>No Cases Yet</h3>
                        <p>Submit your first claim to start tracking your case here.</p>
                        <button class="btn-start-claim" onclick="switchTab('claim')">
                            <svg style="width: 16px; height: 16px;"><use href="#icon-lightning"/></svg>
                            Start a Claim
                        </button>
                    </div>
                `;
                return;
            }

            const statusConfig = {
                'submitted': {
                    label: 'Submitted',
                    text: 'We received your information and will review it shortly.',
                    progress: 1
                },
                'under-review': {
                    label: 'Under Review',
                    text: 'Our team is reviewing your case details.',
                    progress: 2
                },
                'qualified': {
                    label: 'Qualified',
                    text: 'Good news! Your case qualifies for representation.',
                    progress: 3
                },
                'matched': {
                    label: 'Matched',
                    text: 'You have been matched with an attorney.',
                    progress: 4
                },
                'retained': {
                    label: 'Retained',
                    text: 'Your attorney has been assigned and will contact you.',
                    progress: 5
                }
            };

            let html = '';
            userCases.forEach(caseItem => {
                const config = statusConfig[caseItem.status] || statusConfig['submitted'];

                // Format date
                const date = new Date(caseItem.submitted);
                const formattedDate = date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });

                // Progress steps
                let progressHtml = '';
                for (let i = 1; i <= 5; i++) {
                    let stepClass = '';
                    if (i < config.progress) stepClass = 'complete';
                    else if (i === config.progress) stepClass = 'current';
                    progressHtml += '<div class="case-progress-step ' + stepClass + '"></div>';
                }

                // Attorney card if matched/retained
                let attorneyHtml = '';
                if (caseItem.attorney && (caseItem.status === 'matched' || caseItem.status === 'retained')) {
                    const attInitial = caseItem.attorney.name.split(' ').map(n => n[0]).join('');
                    attorneyHtml = `
                        <div class="attorney-card">
                            <div class="attorney-avatar">${escapeHtml(attInitial)}</div>
                            <div class="attorney-info">
                                <h4>${escapeHtml(caseItem.attorney.name)}</h4>
                                <p>Your Attorney</p>
                            </div>
                            <div class="attorney-contact">
                                <button class="attorney-contact-btn" onclick="showToast('Calling ${escapeHtml(caseItem.attorney.phone)}...', 'success')" aria-label="Call attorney">
                                    <svg style="width: 16px; height: 16px;" aria-hidden="true"><use href="#icon-phone"/></svg>
                                </button>
                            </div>
                        </div>
                    `;
                }

                html += `
                    <div class="case-card">
                        <div class="case-card-header">
                            <div>
                                <div class="case-type">${escapeHtml(caseItem.type)}</div>
                                <div class="case-date">Submitted ${escapeHtml(formattedDate)}</div>
                            </div>
                            <span class="case-status-badge ${caseItem.status}">${config.label}</span>
                        </div>
                        <div class="case-progress">${progressHtml}</div>
                        <div class="case-status-text">${config.text}</div>
                        ${attorneyHtml}
                    </div>
                `;
            });

            container.innerHTML = html;
        }

        let currentReferralArea = '';

        function showReferralInfo(areaName) {
            currentReferralArea = areaName;
            document.getElementById('referral-area-name').textContent = areaName;
            document.getElementById('referral-area-desc').textContent = 'We partner with trusted California attorneys who specialize in ' + areaName.toLowerCase() + '.';
            document.getElementById('referral-modal').classList.add('active');
        }

        function hideReferralModal() {
            document.getElementById('referral-modal').classList.remove('active');
        }

        function startReferralQuiz() {
            hideReferralModal();

            // Map referral area names to case type keys
            const referralMap = {
                'Family Law': 'family-law',
                'Criminal Defense': 'criminal-defense',
                'Employment Law': 'employment-law',
                'Real Estate Law': 'real-estate'
            };

            const caseType = referralMap[currentReferralArea] || 'other';

            // Set quiz answers
            quizAnswers = {
                step1: caseType,
                caseType: caseType,
                referralArea: currentReferralArea
            };

            // Populate Step 2 with relevant questions
            const config = step2Questions[caseType];
            if (config) {
                document.getElementById('step2-question').textContent = config.question;
                document.getElementById('step2-subtext').textContent = config.subtext;

                const optionsContainer = document.getElementById('step2-options');
                optionsContainer.innerHTML = config.options.map(opt => `
                    <div class="quiz-option" onclick="selectAndAdvance(this, '${opt.value}', 3)">
                        <div class="quiz-option-icon">
                            <svg style="width: 26px; height: 26px; color: white;"><use href="#icon-${opt.icon}"/></svg>
                        </div>
                        <span>${opt.label}</span>
                    </div>
                `).join('');
            }

            // Switch to claim tab and go to Step 2
            switchTab('claim');
            setTimeout(() => {
                goToStep(2);
            }, 100);
        }

        // Legal Modal Functions
        function showPrivacyModal() {
            document.getElementById('privacy-modal').classList.add('active');
        }

        function hidePrivacyModal() {
            document.getElementById('privacy-modal').classList.remove('active');
        }

        function showTermsModal() {
            document.getElementById('terms-modal').classList.add('active');
        }

        function hideTermsModal() {
            document.getElementById('terms-modal').classList.remove('active');
        }

        function showLegalDisclaimer() {
            document.getElementById('disclaimer-modal').classList.add('active');
        }

        function showNoFeeDisclaimer() {
            document.getElementById('disclaimer-modal').classList.add('active');
        }

        function hideDisclaimerModal() {
            document.getElementById('disclaimer-modal').classList.remove('active');
        }

        // ==================== NEW OPTIMIZATION FUNCTIONS ====================

        // FAQ Accordion
        function toggleFaq(element) {
            // Close all other FAQ items
            document.querySelectorAll('.faq-item').forEach(item => {
                if (item !== element) {
                    item.classList.remove('open');
                }
            });
            // Toggle current item
            element.classList.toggle('open');
        }

        // Phone Number Auto-Formatting
        function formatPhoneNumber(input) {
            let value = input.value.replace(/\D/g, '');
            let formatted = '';

            if (value.length > 0) {
                formatted = '(' + value.substring(0, 3);
            }
            if (value.length > 3) {
                formatted += ') ' + value.substring(3, 6);
            }
            if (value.length > 6) {
                formatted += '-' + value.substring(6, 10);
            }

            input.value = formatted;
            validateInput(input, 'phone');
        }

        // Form Validation
        function validateInput(input, type) {
            const value = input.value.trim();
            let isValid = false;

            switch (type) {
                case 'name':
                    isValid = value.length >= 2;
                    break;
                case 'phone':
                    // Check for formatted phone number (xxx) xxx-xxxx
                    const phoneDigits = value.replace(/\D/g, '');
                    isValid = phoneDigits.length === 10;
                    break;
                case 'email':
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    isValid = emailRegex.test(value);
                    break;
            }

            input.classList.remove('valid', 'invalid');
            if (value.length > 0) {
                input.classList.add(isValid ? 'valid' : 'invalid');
            }

            return isValid;
        }

        // Document Upload Handler (Quiz Form)
        let uploadedFiles = [];
        function handleFileUpload(input) {
            const files = Array.from(input.files);
            const uploadArea = document.getElementById('doc-upload-area');

            if (files.length > 0) {
                uploadedFiles = uploadedFiles.concat(files);
                uploadArea.classList.add('has-files');

                // Update upload area display
                let filesHtml = '<div class="uploaded-files">';
                uploadedFiles.forEach((file, index) => {
                    const isImage = file.type.startsWith('image/');
                    filesHtml += `
                        <div class="uploaded-file">
                            <svg><use href="#icon-${isImage ? 'image' : 'document'}"/></svg>
                            <span>${file.name}</span>
                            <span class="remove-file" onclick="removeFile(${index}, event)">×</span>
                        </div>
                    `;
                });
                filesHtml += '</div>';

                uploadArea.innerHTML = `
                    <svg><use href="#icon-check-circle"/></svg>
                    <h4>${uploadedFiles.length} file${uploadedFiles.length > 1 ? 's' : ''} selected</h4>
                    <p>Tap to add more</p>
                    ${filesHtml}
                    <input type="file" id="file-input" multiple accept="image/*,.pdf" style="display:none" onchange="handleFileUpload(this)">
                `;
            }
        }

        function removeFile(index, event) {
            event.stopPropagation();
            uploadedFiles.splice(index, 1);

            const uploadArea = document.getElementById('doc-upload-area');
            if (uploadedFiles.length === 0) {
                uploadArea.classList.remove('has-files');
                uploadArea.innerHTML = `
                    <input type="file" id="file-input" multiple accept="image/*,.pdf" style="display:none" onchange="handleFileUpload(this)">
                    <svg><use href="#icon-upload"/></svg>
                    <h4>Have photos or documents?</h4>
                    <p>Tap to upload for faster review</p>
                    <div class="upload-hint">Photos, PDFs, or screenshots</div>
                `;
            } else {
                // Re-render file list
                handleFileUpload({files: []});
            }
        }

        // Document Upload Handler (Account Section)
        let accountUploadedFiles = [];
        function handleAccountFileUpload(input) {
            const files = Array.from(input.files);
            const uploadArea = document.getElementById('account-upload-area');

            if (files.length > 0) {
                accountUploadedFiles = accountUploadedFiles.concat(files);
                uploadArea.classList.add('has-files');

                let filesHtml = '<div class="uploaded-files">';
                accountUploadedFiles.forEach((file, index) => {
                    const isImage = file.type.startsWith('image/');
                    filesHtml += `
                        <div class="uploaded-file">
                            <svg><use href="#icon-${isImage ? 'image' : 'document'}"/></svg>
                            <span>${file.name}</span>
                            <span class="remove-file" onclick="removeAccountFile(${index}, event)">×</span>
                        </div>
                    `;
                });
                filesHtml += '</div>';

                uploadArea.innerHTML = `
                    <svg><use href="#icon-check-circle"/></svg>
                    <h4>${accountUploadedFiles.length} file${accountUploadedFiles.length > 1 ? 's' : ''} uploaded</h4>
                    <p>Tap to add more</p>
                    ${filesHtml}
                    <input type="file" id="account-file-input" multiple accept="image/*,.pdf" style="display:none" onchange="handleAccountFileUpload(this)">
                `;
            }
        }

        function removeAccountFile(index, event) {
            event.stopPropagation();
            accountUploadedFiles.splice(index, 1);

            const uploadArea = document.getElementById('account-upload-area');
            if (accountUploadedFiles.length === 0) {
                uploadArea.classList.remove('has-files');
                uploadArea.innerHTML = `
                    <input type="file" id="account-file-input" multiple accept="image/*,.pdf" style="display:none" onchange="handleAccountFileUpload(this)">
                    <svg><use href="#icon-upload"/></svg>
                    <h4>Upload supporting documents</h4>
                    <p>Photos, medical records, receipts</p>
                `;
            }
        }

        // Post-Submit Notification Selection
        function toggleNotificationOption(element) {
            element.classList.toggle('selected');
            const type = element.getAttribute('data-type');
            console.log('Notification preference:', type, element.classList.contains('selected'));
        }

        // Account Notification Toggle Switches
        function toggleSwitch(element) {
            element.classList.toggle('active');
            const pref = element.getAttribute('data-pref');
            const isActive = element.classList.contains('active');
            console.log('Setting preference:', pref, isActive);
            // In production, this would save to user preferences
        }

        // Save Progress Modal
        function showSaveProgressModal() {
            document.getElementById('save-progress-modal').classList.add('active');
        }

        function hideSaveProgressModal() {
            document.getElementById('save-progress-modal').classList.remove('active');
        }

        function showSaveMethod(method) {
            // Toggle tab buttons
            document.querySelectorAll('.save-tab').forEach(tab => tab.classList.remove('active'));
            event.target.classList.add('active');

            // Toggle method forms
            document.getElementById('save-method-sms').classList.toggle('hidden', method !== 'sms');
            document.getElementById('save-method-email').classList.toggle('hidden', method !== 'email');
        }

        function saveProgress(method) {
            const contact = method === 'email'
                ? document.getElementById('save-email').value
                : document.getElementById('save-phone').value;

            if (!contact) {
                showToast('Please enter your ' + method, 'error');
                return;
            }

            console.log('Saving progress via', method, contact);
            showToast('We\'ll send you a link to continue!', 'success');
            hideSaveProgressModal();
        }

        // Article Helpful Feedback
        function helpfulFeedback(button, response) {
            const container = button.parentElement;
            const buttons = container.querySelectorAll('.helpful-btn');

            buttons.forEach(btn => btn.classList.remove('selected'));
            button.classList.add('selected');

            // In production, this would send analytics
            console.log('Article feedback:', response);

            // Show thank you message
            setTimeout(() => {
                container.innerHTML = '<span style="color: var(--success); font-weight: 600;">Thanks for your feedback!</span>';
            }, 300);
        }

        // Share Article Functions
        function shareArticle(method) {
            const title = document.querySelector('.detail-screen:not([style*="display: none"]) .detail-title')?.textContent || 'ClaimIt Legal Guide';
            const url = window.location.href;

            switch (method) {
                case 'sms':
                    window.open(`sms:?body=Check out this helpful legal guide: ${title} - ${url}`);
                    break;
                case 'email':
                    window.open(`mailto:?subject=${encodeURIComponent(title)}&body=${encodeURIComponent('I thought you might find this helpful: ' + url)}`);
                    break;
                case 'copy':
                    navigator.clipboard.writeText(url).then(() => {
                        showToast('Link copied to clipboard!', 'success');
                    }).catch(() => {
                        showToast('Could not copy link', 'error');
                    });
                    break;
            }
        }

        // Progress text labels for quiz steps
        const stepLabels = ['', 'What happened', 'Details', 'Timing', 'Your Info', 'Done!'];

        // Update goToStep to include progress text
        const originalGoToStep = goToStep;
        goToStep = function(step) {
            originalGoToStep(step);

            // Update progress text
            const progressText = document.getElementById('progress-text');
            if (progressText && step <= 4) {
                progressText.textContent = `Step ${step} of 4: ${stepLabels[step]}`;
            }
        };

        // ==================== WOW FACTOR: TOAST NOTIFICATIONS ====================

        function showToast(message, type = 'success') {
            const toast = document.getElementById('toast');
            const toastMessage = document.getElementById('toastMessage');

            toastMessage.textContent = message;
            toast.className = 'toast ' + type;
            toast.classList.add('show');

            setTimeout(() => {
                toast.classList.remove('show');
            }, 3000);
        }

        // ==================== WOW FACTOR: CONFETTI ====================

        class Confetti {
            constructor() {
                this.canvas = document.getElementById('confetti-canvas');
                if (!this.canvas) return;
                this.ctx = this.canvas.getContext('2d');
                this.particles = [];
                this.colors = ['#0066FF', '#FF6B35', '#00C48C', '#FFD700', '#FF69B4'];
                this.resize();
                window.addEventListener('resize', () => this.resize());
            }

            resize() {
                if (!this.canvas) return;
                this.canvas.width = window.innerWidth;
                this.canvas.height = window.innerHeight;
            }

            createParticle(x, y) {
                return {
                    x, y,
                    vx: (Math.random() - 0.5) * 20,
                    vy: Math.random() * -15 - 5,
                    color: this.colors[Math.floor(Math.random() * this.colors.length)],
                    size: Math.random() * 8 + 4,
                    rotation: Math.random() * 360,
                    rotationSpeed: (Math.random() - 0.5) * 10,
                    gravity: 0.3,
                    opacity: 1
                };
            }

            burst(x, y, count = 80) {
                for (let i = 0; i < count; i++) {
                    this.particles.push(this.createParticle(x, y));
                }
                this.animate();
            }

            animate() {
                if (!this.ctx) return;
                this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

                this.particles = this.particles.filter(p => {
                    p.x += p.vx;
                    p.y += p.vy;
                    p.vy += p.gravity;
                    p.rotation += p.rotationSpeed;
                    p.opacity -= 0.012;

                    if (p.opacity <= 0) return false;

                    this.ctx.save();
                    this.ctx.translate(p.x, p.y);
                    this.ctx.rotate(p.rotation * Math.PI / 180);
                    this.ctx.fillStyle = p.color;
                    this.ctx.globalAlpha = p.opacity;
                    this.ctx.fillRect(-p.size / 2, -p.size / 2, p.size, p.size * 0.6);
                    this.ctx.restore();

                    return true;
                });

                if (this.particles.length > 0) {
                    requestAnimationFrame(() => this.animate());
                }
            }
        }

        const confetti = new Confetti();

        // ==================== WOW FACTOR: ACHIEVEMENTS ====================

        const achievements = {
            claimStarted: { title: 'Claim Started!', desc: 'You\'ve taken the first step toward justice.' },
            quizComplete: { title: 'Almost There!', desc: 'Just a few more details needed.' },
            formSubmitted: { title: 'Claim Submitted!', desc: 'Our team will review your case within 24 hours.' },
            documentUploaded: { title: 'Evidence Added!', desc: 'Documents strengthen your case significantly.' }
        };

        function showAchievement(type) {
            const achievement = achievements[type];
            if (!achievement) return;

            document.getElementById('achievementTitle').textContent = achievement.title;
            document.getElementById('achievementDesc').textContent = achievement.desc;

            const popup = document.getElementById('achievementPopup');
            popup.classList.add('show');

            // Trigger confetti
            if (confetti && confetti.burst) {
                confetti.burst(window.innerWidth / 2, window.innerHeight / 2);
            }
        }

        function hideAchievement() {
            document.getElementById('achievementPopup').classList.remove('show');
        }

        // ==================== WOW FACTOR: SOCIAL PROOF FEED ====================

        const proofData = [
            { initials: 'MR', location: 'Los Angeles', type: 'Car Accident', action: 'matched with an attorney', time: '2 min ago' },
            { initials: 'JK', location: 'San Diego', type: 'Slip & Fall', action: 'submitted a claim', time: '5 min ago' },
            { initials: 'AT', location: 'Irvine', type: 'Insurance Dispute', action: 'received case update', time: '8 min ago' },
            { initials: 'SL', location: 'Pasadena', type: 'Personal Injury', action: 'claim qualified', time: '12 min ago' },
            { initials: 'DW', location: 'Long Beach', type: 'Property Damage', action: 'started a claim', time: '15 min ago' }
        ];

        function initializeSocialProof() {
            const feed = document.getElementById('proofFeed');
            if (!feed) return;

            let currentIndex = 0;

            function addProofItem() {
                const data = proofData[currentIndex % proofData.length];

                const item = document.createElement('div');
                item.className = 'proof-item';
                item.innerHTML = `
                    <div class="proof-avatar">${data.initials}</div>
                    <div class="proof-content">
                        <strong>Someone in ${data.location}</strong>
                        <p>${data.action} for ${data.type}</p>
                    </div>
                    <span class="proof-time">${data.time}</span>
                `;

                // Remove old items if more than 3
                while (feed.children.length >= 3) {
                    feed.removeChild(feed.lastChild);
                }

                feed.insertBefore(item, feed.firstChild);

                // Trigger animation
                setTimeout(() => item.classList.add('visible'), 50);

                currentIndex++;
            }

            // Initial items
            addProofItem();
            setTimeout(addProofItem, 200);
            setTimeout(addProofItem, 400);

            // Add new item every 10-18 seconds
            setInterval(() => {
                addProofItem();
            }, 10000 + Math.random() * 8000);
        }

        // Initialize social proof on load
        document.addEventListener('DOMContentLoaded', initializeSocialProof);
        // Also try immediately in case DOM is already loaded
        if (document.readyState !== 'loading') {
            initializeSocialProof();
        }

        // Initialize accident mode banner visibility on load
        document.addEventListener('DOMContentLoaded', function() {
            updateAccidentBannerVisibility();
        });

        // ==================== ENHANCED SUBMIT WITH ACHIEVEMENTS ====================

        // Override submitLead to show achievement
        const originalSubmitLead = submitLead;
        submitLead = function() {
            originalSubmitLead();

            // Show achievement after a brief delay
            setTimeout(() => {
                showAchievement('formSubmitted');
            }, 500);
        };

        // ==================== DEVICE SWITCHING ====================

        function switchDevice(device) {
            if (device === currentDevice) return;

            currentDevice = device;

            // Update toggle buttons
            document.querySelectorAll('.device-toggle-btn').forEach(btn => {
                if (btn.id.startsWith('toggle-i')) { // Only update device buttons, not theme buttons
                    btn.classList.remove('active');
                }
            });
            document.getElementById('toggle-' + device).classList.add('active');

            // Toggle tablet class on the single device frame
            const deviceFrame = document.getElementById('device-frame');
            if (device === 'ipad') {
                deviceFrame.classList.add('tablet');
            } else {
                deviceFrame.classList.remove('tablet');
            }
        }

        function toggleTheme(theme) {
            const screen = document.querySelector('.device-screen');
            isDarkMode = theme === 'dark';

            if (isDarkMode) {
                screen.classList.add('dark-mode');
                document.getElementById('toggle-dark').classList.add('active');
                document.getElementById('toggle-light').classList.remove('active');
            } else {
                screen.classList.remove('dark-mode');
                document.getElementById('toggle-light').classList.add('active');
                document.getElementById('toggle-dark').classList.remove('active');
            }
        }

        // Auto-detect system dark mode preference
        function initThemeFromSystem() {
            const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
            if (prefersDark) {
                toggleTheme('dark');
            }
        }

        // Listen for system theme changes
        window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
            toggleTheme(e.matches ? 'dark' : 'light');
        });

        // Initialize theme on page load
        document.addEventListener('DOMContentLoaded', initThemeFromSystem);

        // ===== ACCESSIBILITY ENHANCEMENTS =====

        // Keyboard navigation for tab bar (arrow keys)
        document.addEventListener('DOMContentLoaded', function() {
            const tabBar = document.getElementById('tab-bar');
            const tabs = ['home', 'claim', 'learn', 'accident', 'account'];

            tabBar.addEventListener('keydown', function(e) {
                const currentTab = document.activeElement;
                if (!currentTab.classList.contains('tab')) return;

                const currentIndex = tabs.findIndex(t => currentTab.id === 'tab-' + t);
                let newIndex = currentIndex;

                if (e.key === 'ArrowRight' || e.key === 'ArrowDown') {
                    e.preventDefault();
                    newIndex = (currentIndex + 1) % tabs.length;
                } else if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') {
                    e.preventDefault();
                    newIndex = (currentIndex - 1 + tabs.length) % tabs.length;
                } else if (e.key === 'Home') {
                    e.preventDefault();
                    newIndex = 0;
                } else if (e.key === 'End') {
                    e.preventDefault();
                    newIndex = tabs.length - 1;
                }

                if (newIndex !== currentIndex) {
                    const newTab = document.getElementById('tab-' + tabs[newIndex]);
                    newTab.focus();
                    switchTab(tabs[newIndex]);
                }
            });
        });

        // Focus trap helper for modals
        function trapFocus(modal) {
            const focusableElements = modal.querySelectorAll(
                'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
            );
            const firstFocusable = focusableElements[0];
            const lastFocusable = focusableElements[focusableElements.length - 1];

            modal.addEventListener('keydown', function(e) {
                if (e.key !== 'Tab') return;

                if (e.shiftKey) {
                    if (document.activeElement === firstFocusable) {
                        lastFocusable.focus();
                        e.preventDefault();
                    }
                } else {
                    if (document.activeElement === lastFocusable) {
                        firstFocusable.focus();
                        e.preventDefault();
                    }
                }
            });
        }

        // Initialize focus trapping for modals
        document.addEventListener('DOMContentLoaded', function() {
            const modals = document.querySelectorAll('.modal-overlay, .legal-modal');
            modals.forEach(trapFocus);

            // Close modals with Escape key
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    const activeModal = document.querySelector('.modal-overlay.active, .legal-modal.active');
                    if (activeModal) {
                        if (activeModal.id === 'signin-modal') hideSignInModal();
                        else if (activeModal.id === 'privacy-modal') hidePrivacyModal();
                        else if (activeModal.id === 'terms-modal') hideTermsModal();
                        else if (activeModal.id === 'disclaimer-modal') hideDisclaimerModal();
                        else if (activeModal.id === 'referral-modal') hideReferralModal();
                        else if (activeModal.id === 'save-progress-modal') hideSaveProgressModal();
                    }
                }
            });
        });

        // ========================================
        // ACCIDENT MODE FUNCTIONS
        // ========================================

        let accidentModeActive = false;
        let currentAccidentStep = 1;
        let accidentPhotos = [false, false, false, false, false, false, false, false];
        let accidentWitnesses = [];
        let isRecording = false;
        let recordingTime = 0;
        let recordingInterval = null;
        let hasRecording = false;

        // Enter Accident Mode
        function enterAccidentMode() {
            accidentModeActive = true;
            currentAccidentStep = 1;
            const screen = document.getElementById('accident-mode-screen');
            screen.classList.add('active');
            document.body.style.overflow = 'hidden';

            // Reset all state
            accidentPhotos = [false, false, false, false, false, false, false, false];
            accidentWitnesses = [];
            hasRecording = false;
            isRecording = false;
            recordingTime = 0;

            // Reset UI
            resetPhotoChecklist();
            document.getElementById('witness-list').innerHTML = '';
            document.querySelectorAll('.reminder-checkbox').forEach(cb => cb.checked = false);

            // Update timestamp
            updateEvidenceTimestamp();

            // Show step 1
            accidentGoToStep(1);

            showToast('Accident Mode activated - Stay calm', 'info');
        }

        // Exit Accident Mode
        function exitAccidentMode() {
            if (accidentModeActive && currentAccidentStep < 7) {
                if (!confirm('Are you sure you want to exit? Your evidence will not be saved.')) {
                    return;
                }
            }

            accidentModeActive = false;
            const screen = document.getElementById('accident-mode-screen');
            screen.classList.remove('active');
            document.body.style.overflow = '';

            // Stop recording if active
            if (isRecording) {
                toggleRecording();
            }
        }

        // Navigate between accident steps
        function accidentGoToStep(step) {
            // Hide all steps
            for (let i = 1; i <= 7; i++) {
                const stepEl = document.getElementById('accident-step-' + i);
                if (stepEl) {
                    stepEl.style.display = 'none';
                }
            }

            // Show target step
            const targetStep = document.getElementById('accident-step-' + step);
            if (targetStep) {
                targetStep.style.display = 'block';
            }

            currentAccidentStep = step;

            // Update progress
            const progress = Math.round((step / 7) * 100);
            document.getElementById('accident-progress-fill').style.width = progress + '%';
            document.getElementById('accident-step-indicator').textContent = 'Step ' + step + ' of 7';

            // Update evidence review if on step 6
            if (step === 6) {
                updateEvidenceReview();
                updateEvidenceSummaryCompact();
                selectDistribution('both'); // Default to "both" option
            }
        }

        // Call 911
        function call911() {
            if (confirm('This will open your phone dialer to call 911. Continue?')) {
                window.location.href = 'tel:911';
            }
        }

        // Capture photo (simulated for prototype)
        function capturePhoto(index, photoType) {
            const photoItems = document.querySelectorAll('.photo-item');
            const item = photoItems[index];

            if (!item) return;

            // Toggle captured state
            const wasCaptured = accidentPhotos[index];
            accidentPhotos[index] = !wasCaptured;

            if (accidentPhotos[index]) {
                item.classList.add('captured');
                item.setAttribute('data-captured', 'true');
                showToast(photoType + ' captured!', 'success');
            } else {
                item.classList.remove('captured');
                item.setAttribute('data-captured', 'false');
            }

            updatePhotoCounter();
        }

        // Reset photo checklist
        function resetPhotoChecklist() {
            const photoItems = document.querySelectorAll('.photo-item');
            photoItems.forEach((item, index) => {
                item.classList.remove('captured');
                item.setAttribute('data-captured', 'false');
                accidentPhotos[index] = false;
            });
            updatePhotoCounter();
        }

        // Update photo counter
        function updatePhotoCounter() {
            const count = accidentPhotos.filter(p => p).length;
            document.getElementById('photo-counter').textContent = count + ' of 8 photos captured';
        }

        // Toggle voice recording
        function toggleRecording() {
            const button = document.getElementById('record-button');
            const btnText = document.getElementById('record-btn-text');
            const circle = document.getElementById('recorder-circle');
            const timer = document.getElementById('recorder-timer');

            if (!isRecording) {
                // Start recording
                isRecording = true;
                hasRecording = true;
                recordingTime = 0;
                button.classList.add('recording');
                circle.classList.add('recording');
                btnText.textContent = 'Tap to Stop';

                recordingInterval = setInterval(() => {
                    recordingTime++;
                    const minutes = Math.floor(recordingTime / 60);
                    const seconds = recordingTime % 60;
                    timer.textContent = minutes + ':' + (seconds < 10 ? '0' : '') + seconds;
                }, 1000);

                showToast('Recording started...', 'info');
            } else {
                // Stop recording
                isRecording = false;
                button.classList.remove('recording');
                circle.classList.remove('recording');
                btnText.textContent = 'Tap to Record Again';

                clearInterval(recordingInterval);
                showToast('Recording saved!', 'success');
            }
        }

        // Format phone number for witness input
        function formatWitnessPhone(input) {
            let value = input.value.replace(/\D/g, '');
            if (value.length > 10) value = value.substring(0, 10);

            if (value.length > 6) {
                input.value = '(' + value.substring(0, 3) + ') ' + value.substring(3, 6) + '-' + value.substring(6);
            } else if (value.length > 3) {
                input.value = '(' + value.substring(0, 3) + ') ' + value.substring(3);
            } else if (value.length > 0) {
                input.value = '(' + value;
            }
        }

        // Add witness
        function addWitness() {
            const nameInput = document.getElementById('witness-name');
            const phoneInput = document.getElementById('witness-phone');
            const emailInput = document.getElementById('witness-email');

            const name = nameInput.value.trim();
            const phone = phoneInput.value.trim();
            const email = emailInput.value.trim();

            if (!name) {
                showToast('Please enter witness name', 'error');
                nameInput.focus();
                return;
            }

            if (!phone || phone.replace(/\D/g, '').length < 10) {
                showToast('Please enter valid phone number', 'error');
                phoneInput.focus();
                return;
            }

            const witness = { name, phone, email, id: Date.now() };
            accidentWitnesses.push(witness);

            renderWitnessList();

            // Clear inputs
            nameInput.value = '';
            phoneInput.value = '';
            emailInput.value = '';

            showToast('Witness added!', 'success');
        }

        // Render witness list
        function renderWitnessList() {
            const container = document.getElementById('witness-list');
            container.innerHTML = accidentWitnesses.map((w, index) => `
                <div class="witness-card">
                    <div class="witness-card-info">
                        <strong>${escapeHtml(w.name)}</strong>
                        <span>${escapeHtml(w.phone)}</span>
                        ${w.email ? '<span>' + escapeHtml(w.email) + '</span>' : ''}
                    </div>
                    <button class="witness-remove-btn" onclick="removeWitness(${index})" aria-label="Remove witness">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                        </svg>
                    </button>
                </div>
            `).join('');
        }

        // Remove witness
        function removeWitness(index) {
            accidentWitnesses.splice(index, 1);
            renderWitnessList();
            showToast('Witness removed', 'info');
        }

        // Update reminder progress
        function updateReminderProgress() {
            // Visual feedback only for prototype
            const checkboxes = document.querySelectorAll('.reminder-checkbox:checked');
            if (checkboxes.length > 0) {
                // Could add progress indicator here
            }
        }

        // Update evidence review
        function updateEvidenceReview() {
            const photoCount = accidentPhotos.filter(p => p).length;
            document.getElementById('evidence-photos-count').textContent = photoCount + ' photos captured';

            const recordingStatus = hasRecording ?
                'Recording saved (' + document.getElementById('recorder-timer').textContent + ')' :
                'No recording';
            document.getElementById('evidence-recording-status').textContent = recordingStatus;

            document.getElementById('evidence-witnesses-count').textContent =
                accidentWitnesses.length + ' witness' + (accidentWitnesses.length !== 1 ? 'es' : '') + ' added';

            updateEvidenceTimestamp();
        }

        // Update evidence timestamp
        function updateEvidenceTimestamp() {
            const now = new Date();
            const formatted = now.toLocaleDateString('en-US', {
                month: 'short',
                day: 'numeric',
                year: 'numeric',
                hour: 'numeric',
                minute: '2-digit',
                hour12: true
            });
            const timestampEl = document.getElementById('evidence-timestamp');
            if (timestampEl) {
                timestampEl.textContent = formatted;
            }
        }

        // Distribution selection state
        let selectedDistribution = 'both'; // Default to "both"

        // Select distribution option
        function selectDistribution(option) {
            selectedDistribution = option;

            // Update visual selection
            ['self', 'lawyer', 'both'].forEach(opt => {
                const el = document.getElementById('dist-option-' + opt);
                if (el) {
                    el.classList.toggle('selected', opt === option);
                }
            });

            // Show/hide email input based on selection
            const emailSection = document.getElementById('distribution-email-section');
            if (emailSection) {
                emailSection.style.display = (option === 'self' || option === 'both') ? 'block' : 'none';
            }

            // Update disclaimer text and button text
            const disclaimerText = document.getElementById('submit-disclaimer-text');
            const submitBtnText = document.getElementById('submit-btn-text');

            if (option === 'self') {
                disclaimerText.textContent = 'Your evidence will be securely packaged and emailed to you.';
                submitBtnText.textContent = 'Email My Evidence';
            } else if (option === 'lawyer') {
                disclaimerText.textContent = 'Your evidence will be securely encrypted and sent to our legal team.';
                submitBtnText.textContent = 'Send to Attorney';
            } else {
                disclaimerText.textContent = 'Your evidence will be sent to you and our legal team.';
                submitBtnText.textContent = 'Send Evidence';
            }
        }

        // Update compact evidence summary
        function updateEvidenceSummaryCompact() {
            const photoCount = accidentPhotos.filter(p => p).length;

            const photosEl = document.getElementById('evidence-photos-count-compact');
            if (photosEl) photosEl.textContent = photoCount + ' captured';

            const recordingEl = document.getElementById('evidence-recording-compact');
            if (recordingEl) recordingEl.textContent = hasRecording ? 'Recorded' : 'None';

            const witnessesEl = document.getElementById('evidence-witnesses-compact');
            if (witnessesEl) witnessesEl.textContent = accidentWitnesses.length + ' added';

            const timestampEl = document.getElementById('evidence-timestamp-compact');
            if (timestampEl) {
                const now = new Date();
                timestampEl.textContent = now.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
            }
        }

        // Submit evidence (handles distribution options)
        function submitEvidence() {
            const photoCount = accidentPhotos.filter(p => p).length;

            if (photoCount === 0 && !hasRecording && accidentWitnesses.length === 0) {
                if (!confirm('You haven\'t collected any evidence. Submit anyway?')) {
                    return;
                }
            }

            // Check email if required
            if (selectedDistribution === 'self' || selectedDistribution === 'both') {
                const emailInput = document.getElementById('evidence-email');
                const email = emailInput?.value?.trim();
                if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                    showToast('Please enter a valid email address', 'error');
                    emailInput?.focus();
                    return;
                }
            }

            // Show loading state
            const submitBtn = document.getElementById('submit-evidence-btn');
            const submitBtnText = document.getElementById('submit-btn-text');
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner"></span> Processing...';

            // Simulate submission delay
            setTimeout(() => {
                submitBtn.disabled = false;
                submitBtn.innerHTML = `
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="22" y1="2" x2="11" y2="13"></line>
                        <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                    </svg>
                    <span id="submit-btn-text">Send Evidence</span>
                `;

                // Update success screen based on distribution choice
                updateSuccessScreen();

                // Store reminder if only saved to self (for 24-48 hour follow-up)
                if (selectedDistribution === 'self') {
                    scheduleEvidenceReminder();
                }

                // Go to success screen
                accidentGoToStep(7);

                // Show appropriate toast
                if (selectedDistribution === 'self') {
                    showToast('Evidence package sent to your email!', 'success');
                } else if (selectedDistribution === 'lawyer') {
                    showToast('Evidence sent to our legal team!', 'success');
                } else {
                    showToast('Evidence saved and sent to legal team!', 'success');
                }
            }, 2000);
        }

        // Update success screen based on distribution choice
        function updateSuccessScreen() {
            const title = document.getElementById('success-title');
            const subtitle = document.getElementById('success-subtitle');
            const selfContent = document.getElementById('success-self-content');
            const lawyerContent = document.getElementById('success-lawyer-content');
            const bothContent = document.getElementById('success-both-content');

            // Hide all content sections
            if (selfContent) selfContent.style.display = 'none';
            if (lawyerContent) lawyerContent.style.display = 'none';
            if (bothContent) bothContent.style.display = 'none';

            if (selectedDistribution === 'self') {
                title.textContent = 'Evidence Saved!';
                subtitle.textContent = 'Check your email for the secure evidence package.';
                if (selfContent) selfContent.style.display = 'block';
            } else if (selectedDistribution === 'lawyer') {
                title.textContent = 'Evidence Submitted!';
                subtitle.textContent = 'Our legal team will review your case within 2 hours.';
                if (lawyerContent) lawyerContent.style.display = 'block';
            } else {
                title.textContent = "You're Protected!";
                subtitle.textContent = 'Evidence saved to your email and sent to our legal team.';
                if (bothContent) bothContent.style.display = 'block';
            }
        }

        // Schedule gentle reminder (24-48 hours after self-save)
        function scheduleEvidenceReminder() {
            // Store timestamp for reminder system
            const reminderData = {
                timestamp: Date.now(),
                email: document.getElementById('evidence-email')?.value,
                photoCount: accidentPhotos.filter(p => p).length,
                hasRecording: hasRecording,
                witnessCount: accidentWitnesses.length
            };
            localStorage.setItem('evidenceReminder', JSON.stringify(reminderData));

            // In production, this would trigger a push notification or email
            // For prototype, just log it
            console.log('Reminder scheduled for evidence follow-up:', reminderData);
        }

        // Send to lawyer after initially saving only to self
        function sendToLawyerLater() {
            const reminderNotice = document.getElementById('reminder-notice');
            if (reminderNotice) {
                reminderNotice.innerHTML = `
                    <div class="reminder-icon">✅</div>
                    <div class="reminder-content">
                        <h4>Sent to Legal Team!</h4>
                        <p>Our attorneys will review your evidence and contact you within 2 hours.</p>
                    </div>
                `;
            }

            // Clear the reminder since they've now sent to lawyer
            localStorage.removeItem('evidenceReminder');

            showToast('Evidence sent to our legal team!', 'success');
        }

        // Check for pending evidence reminder on app load
        function checkEvidenceReminder() {
            const reminderJSON = localStorage.getItem('evidenceReminder');
            if (!reminderJSON) return;

            const reminder = JSON.parse(reminderJSON);
            const hoursSinceAccident = (Date.now() - reminder.timestamp) / (1000 * 60 * 60);

            // Show reminder if 24-48 hours have passed
            // For prototype demo, we'll also show if it's been more than 10 seconds
            const shouldShowReminder = hoursSinceAccident >= 24 ||
                (window.location.search.includes('demo=reminder')); // Demo mode for testing

            if (shouldShowReminder) {
                showEvidenceReminderModal(reminder);
            }
        }

        // Show gentle reminder modal
        function showEvidenceReminderModal(reminder) {
            const modal = document.getElementById('evidence-reminder-modal');
            if (modal) {
                // Update modal content with evidence summary
                const evidenceSummary = document.getElementById('reminder-evidence-summary');
                if (evidenceSummary) {
                    evidenceSummary.innerHTML = `
                        <div class="reminder-summary-item">
                            <span>📸</span>
                            <span>${reminder.photoCount} photos</span>
                        </div>
                        <div class="reminder-summary-item">
                            <span>🎙️</span>
                            <span>${reminder.hasRecording ? 'Voice recording' : 'No recording'}</span>
                        </div>
                        <div class="reminder-summary-item">
                            <span>👥</span>
                            <span>${reminder.witnessCount} witnesses</span>
                        </div>
                    `;
                }
                modal.style.display = 'flex';
            }
        }

        // Hide reminder modal
        function hideReminderModal() {
            const modal = document.getElementById('evidence-reminder-modal');
            if (modal) {
                modal.style.display = 'none';
            }
        }

        // Send evidence from reminder modal
        function sendEvidenceFromReminder() {
            hideReminderModal();
            localStorage.removeItem('evidenceReminder');
            showToast('Evidence sent to our legal team for review!', 'success');
        }

        // Dismiss reminder (ask again later or dismiss permanently)
        function dismissReminder(permanent = false) {
            hideReminderModal();
            if (permanent) {
                localStorage.removeItem('evidenceReminder');
            } else {
                // Update timestamp to delay next reminder by 24 hours
                const reminderJSON = localStorage.getItem('evidenceReminder');
                if (reminderJSON) {
                    const reminder = JSON.parse(reminderJSON);
                    reminder.timestamp = Date.now();
                    localStorage.setItem('evidenceReminder', JSON.stringify(reminder));
                }
            }
        }

        // Add event listener for witness phone formatting
        document.addEventListener('DOMContentLoaded', function() {
            const witnessPhoneInput = document.getElementById('witness-phone');
            if (witnessPhoneInput) {
                witnessPhoneInput.addEventListener('input', function() {
                    formatWitnessPhone(this);
                });
            }

            // Check for pending evidence reminder (24-48 hours after self-save)
            // Small delay to let app fully load first
            setTimeout(checkEvidenceReminder, 1000);
        });

        // Handle Escape key for accident mode
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && accidentModeActive) {
                exitAccidentMode();
            }
        });

        // ========================================
        // END ACCIDENT MODE FUNCTIONS
        // ========================================

        // Skip to main content link
        document.addEventListener('DOMContentLoaded', function() {
            const skipLink = document.createElement('a');
            skipLink.href = '#main-content';
            skipLink.className = 'skip-link';
            skipLink.textContent = 'Skip to main content';
            skipLink.style.cssText = 'position:absolute;left:-9999px;top:auto;width:1px;height:1px;overflow:hidden;z-index:9999;';
            skipLink.addEventListener('focus', function() {
                this.style.cssText = 'position:fixed;left:50%;transform:translateX(-50%);top:10px;padding:12px 24px;background:#0066FF;color:white;border-radius:8px;z-index:9999;font-weight:600;';
            });
            skipLink.addEventListener('blur', function() {
                this.style.cssText = 'position:absolute;left:-9999px;top:auto;width:1px;height:1px;overflow:hidden;z-index:9999;';
            });
            document.querySelector('.device-screen').prepend(skipLink);
        });
    </script>

</body>
</html>
