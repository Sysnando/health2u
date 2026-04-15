const express = require('express');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const db = require('../db');
const config = require('../config');

const router = express.Router();

// In-memory refresh token store (opaque token -> userId)
const refreshTokens = new Map();

function signAccessToken(user) {
  return jwt.sign(
    { sub: user.id, email: user.email },
    config.jwtSecret,
    { expiresIn: config.jwtExpiresIn }
  );
}

function makeAuthResponse(user) {
  const accessToken = signAccessToken(user);
  const refreshToken = uuidv4();
  refreshTokens.set(refreshToken, user.id);
  return {
    access_token: accessToken,
    refresh_token: refreshToken,
    user: db.users.toPublicDto(user),
  };
}

// POST /login
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({
      error: { code: 'VALIDATION_ERROR', message: 'email and password required' },
    });
  }

  const user = db.users.findByEmail(email);
  if (!user) {
    return res.status(401).json({
      error: { code: 'INVALID_CREDENTIALS', message: 'Invalid email or password' },
    });
  }

  const valid = await db.users.verifyPassword(user, password);
  if (!valid) {
    return res.status(401).json({
      error: { code: 'INVALID_CREDENTIALS', message: 'Invalid email or password' },
    });
  }

  return res.status(200).json(makeAuthResponse(user));
});

// POST /refresh
router.post('/refresh', (req, res) => {
  const { refresh_token } = req.body;

  if (!refresh_token || !refreshTokens.has(refresh_token)) {
    return res.status(401).json({
      error: { code: 'INVALID_REFRESH_TOKEN', message: 'Invalid or expired refresh token' },
    });
  }

  const userId = refreshTokens.get(refresh_token);
  refreshTokens.delete(refresh_token);

  const user = db.users.findById(userId);
  if (!user) {
    return res.status(401).json({
      error: { code: 'INVALID_REFRESH_TOKEN', message: 'Invalid or expired refresh token' },
    });
  }

  return res.status(200).json(makeAuthResponse(user));
});

// POST /logout
router.post('/logout', (req, res) => {
  const { refresh_token } = req.body || {};

  if (refresh_token && refreshTokens.has(refresh_token)) {
    refreshTokens.delete(refresh_token);
  }

  return res.status(204).send();
});

module.exports = router;
