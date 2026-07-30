const fs = require('node:fs');
const path = require('node:path');
const sharp = require('sharp');

const projectRoot = path.resolve(__dirname, '..');
const sourcePath = path.join(
  projectRoot,
  'store_assets/appstore/raw/ipad-create.png',
);
const logoPath = path.join(projectRoot, 'assets/images/app_logo.png');
const outputPath = path.join(
  projectRoot,
  'store_assets/appstore/final/04-ipad-create.png',
);

const sourceData = fs.readFileSync(sourcePath).toString('base64');
const logoData = fs.readFileSync(logoPath).toString('base64');

const artwork = `
<svg width="2064" height="2752" viewBox="0 0 2064 2752"
  xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="background" x1="0" y1="0" x2="2064" y2="2752">
      <stop offset="0" stop-color="#24468D"/>
      <stop offset="0.48" stop-color="#112757"/>
      <stop offset="1" stop-color="#071226"/>
    </linearGradient>
    <radialGradient id="glow" cx="0.82" cy="0.18" r="0.78">
      <stop offset="0" stop-color="#376DE8" stop-opacity="0.36"/>
      <stop offset="1" stop-color="#376DE8" stop-opacity="0"/>
    </radialGradient>
    <pattern id="grid" width="72" height="72" patternUnits="userSpaceOnUse">
      <path d="M72 0H0V72" fill="none" stroke="#7AA0FF"
        stroke-opacity="0.055" stroke-width="2"/>
    </pattern>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="160%">
      <feDropShadow dx="0" dy="36" stdDeviation="42"
        flood-color="#000817" flood-opacity="0.48"/>
    </filter>
    <clipPath id="screenClip">
      <rect x="252" y="650" width="1560" height="2080" rx="54"/>
    </clipPath>
  </defs>

  <rect width="2064" height="2752" fill="url(#background)"/>
  <rect width="2064" height="2752" fill="url(#glow)"/>
  <rect width="2064" height="2752" fill="url(#grid)"/>

  <image href="data:image/png;base64,${logoData}"
    x="104" y="92" width="86" height="86"/>
  <text x="222" y="154" fill="#F8FAFF"
    font-family="-apple-system, BlinkMacSystemFont, 'Helvetica Neue', sans-serif"
    font-size="48" font-weight="700" letter-spacing="0.5">CODE POCKET</text>

  <rect x="104" y="222" width="116" height="10" rx="5" fill="#4D7CFF"/>
  <text x="104" y="318" fill="#5F8AFF"
    font-family="-apple-system, BlinkMacSystemFont, 'Helvetica Neue', sans-serif"
    font-size="35" font-weight="700" letter-spacing="1.8">CREATE</text>
  <text x="104" y="442" fill="#FFFFFF"
    font-family="-apple-system, BlinkMacSystemFont, 'Helvetica Neue', sans-serif"
    font-size="96" font-weight="750" letter-spacing="-2.2">Your code toolkit,</text>
  <text x="104" y="548" fill="#FFFFFF"
    font-family="-apple-system, BlinkMacSystemFont, 'Helvetica Neue', sans-serif"
    font-size="96" font-weight="750" letter-spacing="-2.2">beautifully organized.</text>

  <rect x="238" y="636" width="1588" height="2108" rx="68"
    fill="#E8EEFA" fill-opacity="0.22" stroke="#C8D8FF"
    stroke-opacity="0.52" stroke-width="3" filter="url(#shadow)"/>
  <image href="data:image/png;base64,${sourceData}"
    x="252" y="650" width="1560" height="2080"
    preserveAspectRatio="xMidYMid slice" clip-path="url(#screenClip)"/>
</svg>`;

sharp(Buffer.from(artwork))
  .png({ compressionLevel: 9 })
  .toFile(outputPath)
  .then(() => console.log(outputPath))
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
