const express = require('express');
const db = require('../db');

const router = express.Router();

// GET / - list insights (wrapped in envelope)
router.get('/', (req, res) => {
  try {
    const insights = db.insights.list(req.user.id);
    res.json({ insights });
  } catch (err) {
    res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: err.message } });
  }
});

module.exports = router;
