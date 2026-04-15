const express = require('express');
const db = require('../db');

const router = express.Router();

const VALID_STATUSES = ['UPCOMING', 'COMPLETED', 'CANCELLED'];

// GET / - list appointments
router.get('/', (req, res) => {
  try {
    const appointments = db.appointments.list(req.user.id);
    res.json(appointments);
  } catch (err) {
    res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: err.message } });
  }
});

// POST / - create appointment
router.post('/', (req, res) => {
  try {
    const { title, description, doctor_name, location, date_time, reminder_minutes, status } = req.body;

    if (!title || date_time == null || typeof date_time !== 'number') {
      return res.status(400).json({ error: { code: 'BAD_REQUEST', message: 'Missing required fields: title, date_time (number)' } });
    }

    const appointmentStatus = status || 'UPCOMING';
    if (!VALID_STATUSES.includes(appointmentStatus)) {
      return res.status(400).json({ error: { code: 'BAD_REQUEST', message: 'Invalid status. Must be UPCOMING, COMPLETED, or CANCELLED' } });
    }

    const appointment = db.appointments.create(req.user.id, {
      title,
      description: description || null,
      doctor_name: doctor_name || null,
      location: location || null,
      date_time,
      reminder_minutes: reminder_minutes != null ? reminder_minutes : null,
      status: appointmentStatus,
    });

    res.status(201).json(appointment);
  } catch (err) {
    res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: err.message } });
  }
});

// PUT /:id - update appointment
router.put('/:id', (req, res) => {
  try {
    const patch = req.body;

    if (patch.status && !VALID_STATUSES.includes(patch.status)) {
      return res.status(400).json({ error: { code: 'BAD_REQUEST', message: 'Invalid status. Must be UPCOMING, COMPLETED, or CANCELLED' } });
    }

    const updated = db.appointments.update(req.params.id, req.user.id, patch);
    if (!updated) {
      return res.status(404).json({ error: { code: 'NOT_FOUND', message: 'Appointment not found' } });
    }
    res.json(updated);
  } catch (err) {
    res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: err.message } });
  }
});

// DELETE /:id - remove appointment
router.delete('/:id', (req, res) => {
  try {
    const removed = db.appointments.remove(req.params.id, req.user.id);
    if (!removed) {
      return res.status(404).json({ error: { code: 'NOT_FOUND', message: 'Appointment not found' } });
    }
    res.status(204).send();
  } catch (err) {
    res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: err.message } });
  }
});

module.exports = router;
