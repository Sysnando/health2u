const express = require('express');
const db = require('../db');

const router = express.Router();

// GET / - list emergency contacts
router.get('/', (req, res) => {
  try {
    const contacts = db.emergencyContacts.list(req.user.id);
    res.json(contacts);
  } catch (err) {
    res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: err.message } });
  }
});

// POST / - create emergency contact
router.post('/', (req, res) => {
  try {
    const { name, relationship, phone, email, is_primary, order } = req.body;

    if (!name || !relationship || !phone) {
      return res.status(400).json({ error: { code: 'BAD_REQUEST', message: 'Missing required fields: name, relationship, phone' } });
    }

    const contact = db.emergencyContacts.create(req.user.id, {
      name,
      relationship,
      phone,
      email: email || null,
      is_primary: is_primary != null ? is_primary : false,
      order: order != null ? order : 0,
    });

    res.status(201).json(contact);
  } catch (err) {
    res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: err.message } });
  }
});

// PUT /:id - update emergency contact
router.put('/:id', (req, res) => {
  try {
    const updated = db.emergencyContacts.update(req.params.id, req.user.id, req.body);
    if (!updated) {
      return res.status(404).json({ error: { code: 'NOT_FOUND', message: 'Emergency contact not found' } });
    }
    res.json(updated);
  } catch (err) {
    res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: err.message } });
  }
});

// DELETE /:id - remove emergency contact
router.delete('/:id', (req, res) => {
  try {
    const removed = db.emergencyContacts.remove(req.params.id, req.user.id);
    if (!removed) {
      return res.status(404).json({ error: { code: 'NOT_FOUND', message: 'Emergency contact not found' } });
    }
    res.status(204).send();
  } catch (err) {
    res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: err.message } });
  }
});

module.exports = router;
