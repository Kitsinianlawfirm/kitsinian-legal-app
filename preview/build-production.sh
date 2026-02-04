#!/bin/bash
# Build script to split index.html into separate CSS, JS, and HTML files
# Run: ./build-production.sh

set -e

PREVIEW_DIR="$(dirname "$0")"
PROD_DIR="$PREVIEW_DIR/production"

echo "Creating production build..."

# Create production directory
mkdir -p "$PROD_DIR"

# Extract CSS (lines 13-7994)
echo "Extracting CSS..."
sed -n '13,7994p' "$PREVIEW_DIR/index.html" > "$PROD_DIR/styles.css"

# Extract JS (lines 10769-12961)
echo "Extracting JavaScript..."
sed -n '10821,13014p' "$PREVIEW_DIR/index.html" > "$PROD_DIR/scripts.js"

# Create production HTML with external references
echo "Creating production HTML..."
cat > "$PROD_DIR/index.html" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ClaimIt - Full Interactive Preview</title>
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'%3E%3Crect width='32' height='32' rx='6' fill='%230066FF'/%3E%3Cpath d='M17.5 6L10 17h5.5l-1 9L22 15h-5.5l1-9z' fill='%23F59E0B'/%3E%3C/svg%3E">
    <link rel="apple-touch-icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 180 180'%3E%3Crect width='180' height='180' rx='40' fill='%230066FF'/%3E%3Cpath d='M98 30L52 95h35l-7 55 53-70h-35l7-50z' fill='%23F59E0B'/%3E%3C/svg%3E">
    <meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self'; style-src 'self' https://fonts.googleapis.com; font-src https://fonts.gstatic.com; img-src 'self' data:; connect-src 'self';">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="styles.css">
</head>
HTMLEOF

# Append the body content (between </style> and <script>)
# This extracts lines 7996-10767 (HTML body)
sed -n '7996,10820p' "$PREVIEW_DIR/index.html" >> "$PROD_DIR/index.html"

# Add script reference
cat >> "$PROD_DIR/index.html" << 'HTMLEOF'
    <script src="scripts.js"></script>
</body>
</html>
HTMLEOF

# Calculate sizes
ORIGINAL_SIZE=$(du -h "$PREVIEW_DIR/index.html" | cut -f1)
CSS_SIZE=$(du -h "$PROD_DIR/styles.css" | cut -f1)
JS_SIZE=$(du -h "$PROD_DIR/scripts.js" | cut -f1)
HTML_SIZE=$(du -h "$PROD_DIR/index.html" | cut -f1)

echo ""
echo "Production build complete!"
echo "=========================="
echo "Original: $ORIGINAL_SIZE"
echo ""
echo "Split files in $PROD_DIR/:"
echo "  - styles.css:  $CSS_SIZE"
echo "  - scripts.js:  $JS_SIZE"
echo "  - index.html:  $HTML_SIZE"
echo ""
echo "Benefits:"
echo "  - CSS and JS can be cached separately"
echo "  - Easier to maintain and debug"
echo "  - CSP allows 'self' only (more secure)"
echo ""
echo "Note: For GitHub Pages, the single-file version is simpler."
