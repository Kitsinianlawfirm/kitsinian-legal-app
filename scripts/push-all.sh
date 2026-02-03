#!/bin/bash
# Push changes to both repos

MESSAGE="${1:-Update preview}"

echo "📦 Pushing to main repo..."
cd /Users/hkitsinian/kitsinian-legal-app
git add -A
git commit -m "$MESSAGE

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
git push

echo ""
echo "📦 Syncing and pushing to GitHub Pages..."
cp preview/index.html /Users/hkitsinian/claimit-preview/index.html
cd /Users/hkitsinian/claimit-preview
git add -A
git commit -m "$MESSAGE

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
git push

echo ""
echo "✅ Done! Both repos updated."
echo "🌐 Live at: https://kitsinianlawfirm.github.io/claimit-preview/"
