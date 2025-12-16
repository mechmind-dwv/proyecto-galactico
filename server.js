// server.js
import https from 'https';
import fs from 'fs';
import app from './app';

const options = {
  key: fs.readFileSync('/path/to/privkey.pem'),
  cert: fs.readFileSync('/path/to/fullchain.pem'),
  // HSTS
  strictTransportSecurity: 'max-age=31536000; includeSubDomains',
  // Seguridad adicional
  ciphers: 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384'
};

https.createServer(options, app).listen(443);
