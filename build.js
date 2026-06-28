const fs = require('fs');
const path = require('path');

const supabaseUrl = process.env.SUPABASE_URL || '';
const supabaseKey = process.env.SUPABASE_ANON_KEY || '';

if (!supabaseUrl || !supabaseKey) {
  console.warn('⚠  SUPABASE_URL / SUPABASE_ANON_KEY not set — site will use localStorage fallback');
}

let html = fs.readFileSync(path.join(__dirname, 'src', 'index.html'), 'utf-8');
html = html.replace(/\{\{SUPABASE_URL\}\}/g, supabaseUrl);
html = html.replace(/\{\{SUPABASE_ANON_KEY\}\}/g, supabaseKey);

fs.mkdirSync(path.join(__dirname, 'public'), { recursive: true });
fs.writeFileSync(path.join(__dirname, 'public', 'index.html'), html);

console.log('✅ Build complete → public/index.html');
if (supabaseUrl) console.log('   Supabase URL: ' + supabaseUrl);
