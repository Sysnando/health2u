const express = require('express');
const db = require('../db');

const router = express.Router();

// GET /profile
router.get('/profile', (req, res) => {
  const user = db.users.findById(req.user.id);

  if (!user) {
    return res.status(404).json({
      error: { code: 'NOT_FOUND', message: 'User not found' },
    });
  }

  return res.status(200).json(db.users.toPublicDto(user));
});

// PUT /profile
router.put('/profile', (req, res) => {
  const allowedFields = ['name', 'profile_picture_url', 'date_of_birth', 'phone', 'email'];
  const patch = {};

  for (const field of allowedFields) {
    if (req.body[field] !== undefined) {
      patch[field] = req.body[field];
    }
  }

  const updated = db.users.update(req.user.id, patch);

  return res.status(200).json(db.users.toPublicDto(updated));
});

module.exports = router;
