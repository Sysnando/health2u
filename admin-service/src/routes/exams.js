const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const db = require('../db');

const router = express.Router();

const UPLOADS_BUCKET = process.env.UPLOADS_BUCKET;
const AWS_REGION = process.env.AWS_REGION || 'us-east-1';
const FILE_SIZE_LIMIT = 20 * 1024 * 1024;

// Build the multer uploader differently depending on whether we're running
// against S3 (Lambda) or local disk (developer machine without AWS creds).
let upload;
let s3Client;
if (UPLOADS_BUCKET) {
  const multerS3 = require('multer-s3');
  const { S3Client } = require('@aws-sdk/client-s3');
  s3Client = new S3Client({ region: AWS_REGION });
  upload = multer({
    storage: multerS3({
      s3: s3Client,
      bucket: UPLOADS_BUCKET,
      contentType: multerS3.AUTO_CONTENT_TYPE,
      key: (req, file, cb) => {
        const ts = Date.now();
        const safe = file.originalname.replace(/[^a-zA-Z0-9._-]/g, '_');
        cb(null, `exams/${req.user.id}/${ts}_${safe}`);
      },
    }),
    limits: { fileSize: FILE_SIZE_LIMIT },
  });
} else {
  const uploadsDir = path.join(__dirname, '..', '..', 'uploads');
  fs.mkdirSync(uploadsDir, { recursive: true });
  const storage = multer.diskStorage({
    destination: uploadsDir,
    filename: (req, file, cb) => {
      const ts = Date.now();
      const safe = file.originalname.replace(/[^a-zA-Z0-9._-]/g, '_');
      cb(null, `${ts}_${safe}`);
    },
  });
  upload = multer({ storage, limits: { fileSize: FILE_SIZE_LIMIT } });
}

// GET / - list exams with optional filter
router.get('/', (req, res) => {
  try {
    const exams = db.exams.list(req.user.id, req.query.filter);
    res.json(exams);
  } catch (err) {
    res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: err.message } });
  }
});

// GET /:id - get single exam
router.get('/:id', (req, res) => {
  try {
    const exam = db.exams.getById(req.params.id, req.user.id);
    if (!exam) {
      return res.status(404).json({ error: { code: 'NOT_FOUND', message: 'Exam not found' } });
    }
    res.json(exam);
  } catch (err) {
    res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: err.message } });
  }
});

// GET /:id/file - short-lived presigned URL for the exam file (S3 mode only)
router.get('/:id/file', async (req, res) => {
  try {
    const exam = db.exams.getById(req.params.id, req.user.id);
    if (!exam) {
      return res.status(404).json({ error: { code: 'NOT_FOUND', message: 'Exam not found' } });
    }
    if (!UPLOADS_BUCKET) {
      // Local mode: the client can just hit /uploads/<filename> directly.
      return res.json({ url: exam.fileUrl });
    }
    const { GetObjectCommand } = require('@aws-sdk/client-s3');
    const { getSignedUrl } = require('@aws-sdk/s3-request-presigner');
    const url = await getSignedUrl(
      s3Client,
      new GetObjectCommand({ Bucket: UPLOADS_BUCKET, Key: exam.fileUrl }),
      { expiresIn: 300 }
    );
    res.json({ url });
  } catch (err) {
    res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: err.message } });
  }
});

// POST /upload - upload exam with file
router.post('/upload', upload.single('file'), (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: { code: 'BAD_REQUEST', message: 'File is required' } });
    }

    let metadata;
    try {
      metadata = JSON.parse(req.body.metadata);
    } catch (e) {
      return res.status(400).json({ error: { code: 'BAD_REQUEST', message: 'Invalid metadata JSON' } });
    }

    const { title, type, date, notes } = metadata;
    if (!title || !type || date == null) {
      return res.status(400).json({ error: { code: 'BAD_REQUEST', message: 'Missing required fields: title, type, date' } });
    }

    const file_url = UPLOADS_BUCKET
      ? req.file.key // S3 object key
      : '/uploads/' + req.file.filename; // local static path
    const exam = db.exams.create(req.user.id, {
      title,
      type,
      date: Number(date),
      fileUrl: file_url,
      notes: notes || null,
    });

    res.status(201).json(exam);
  } catch (err) {
    res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: err.message } });
  }
});

// DELETE /:id - remove exam
router.delete('/:id', (req, res) => {
  try {
    const removed = db.exams.remove(req.params.id, req.user.id);
    if (!removed) {
      return res.status(404).json({ error: { code: 'NOT_FOUND', message: 'Exam not found' } });
    }
    res.status(204).send();
  } catch (err) {
    res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: err.message } });
  }
});

module.exports = router;
