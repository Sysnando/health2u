require('dotenv').config();
const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const auth = require('./middleware/auth');
const errorHandler = require('./middleware/errorHandler');

const app = express();

app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(morgan('dev'));

// Local-disk uploads are only served when we are NOT running against S3
// (i.e. no UPLOADS_BUCKET env var). In Lambda/S3 mode files are accessed
// via presigned URLs from `GET /exams/:id/file`.
if (!process.env.UPLOADS_BUCKET) {
  const fs = require('fs');
  const path = require('path');
  const uploadsDir = path.join(__dirname, '..', 'uploads');
  fs.mkdirSync(uploadsDir, { recursive: true });
  app.use('/uploads', express.static(uploadsDir));
}

// Health check
app.get('/health', (req, res) => res.json({ status: 'ok' }));

// Routes
app.use('/auth', require('./routes/auth'));
app.use('/user', auth, require('./routes/user'));
app.use('/exams', auth, require('./routes/exams'));
app.use('/appointments', auth, require('./routes/appointments'));
app.use('/insights', auth, require('./routes/insights'));
app.use('/emergency-contacts', auth, require('./routes/emergencyContacts'));

// 404
app.use((req, res) => {
  res.status(404).json({ error: { code: 'NOT_FOUND', message: 'Route not found' } });
});

app.use(errorHandler);

module.exports = app;
