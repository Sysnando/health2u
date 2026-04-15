const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');
const seed = require('./data/seed');

// ── In-memory stores ──────────────────────────────────────────────
const usersMap = new Map();
const examsMap = new Map();
const appointmentsMap = new Map();
const insightsMap = new Map();
const emergencyContactsMap = new Map();

// ── Seed data ─────────────────────────────────────────────────────
seed.users.forEach((u) => usersMap.set(u.id, { ...u }));
seed.exams.forEach((e) => examsMap.set(e.id, { ...e }));
seed.appointments.forEach((a) => appointmentsMap.set(a.id, { ...a }));
seed.insights.forEach((i) => insightsMap.set(i.id, { ...i }));
seed.emergencyContacts.forEach((c) => emergencyContactsMap.set(c.id, { ...c }));

// ── Users ─────────────────────────────────────────────────────────
const users = {
  findByEmail(email) {
    for (const user of usersMap.values()) {
      if (user.email === email) return user;
    }
    return null;
  },

  findById(id) {
    return usersMap.get(id) || null;
  },

  update(id, patch) {
    const user = usersMap.get(id);
    if (!user) return null;
    Object.assign(user, patch);
    return user;
  },

  async verifyPassword(user, plain) {
    return bcrypt.compare(plain, user.password_hash);
  },

  toPublicDto(user) {
    const { password_hash, ...dto } = user;
    return dto;
  },
};

// ── Exams ─────────────────────────────────────────────────────────
const exams = {
  list(userId, filter) {
    const results = [];
    for (const exam of examsMap.values()) {
      if (exam.user_id !== userId) continue;
      if (filter && exam.type !== filter) continue;
      results.push(exam);
    }
    return results;
  },

  getById(id, userId) {
    const exam = examsMap.get(id);
    if (!exam || exam.user_id !== userId) return null;
    return exam;
  },

  create(userId, { title, type, date, fileUrl, notes }) {
    const now = Date.now();
    const exam = {
      id: uuidv4(),
      user_id: userId,
      title,
      type,
      date,
      file_url: fileUrl || null,
      notes: notes || null,
      created_at: now,
      updated_at: now,
    };
    examsMap.set(exam.id, exam);
    return exam;
  },

  remove(id, userId) {
    const exam = examsMap.get(id);
    if (!exam || exam.user_id !== userId) return false;
    examsMap.delete(id);
    return true;
  },
};

// ── Appointments ──────────────────────────────────────────────────
const appointments = {
  list(userId) {
    const results = [];
    for (const apt of appointmentsMap.values()) {
      if (apt.user_id === userId) results.push(apt);
    }
    return results.sort((a, b) => a.date_time - b.date_time);
  },

  getById(id, userId) {
    const apt = appointmentsMap.get(id);
    if (!apt || apt.user_id !== userId) return null;
    return apt;
  },

  create(userId, data) {
    const apt = {
      id: uuidv4(),
      user_id: userId,
      title: data.title,
      description: data.description || null,
      doctor_name: data.doctor_name,
      location: data.location,
      date_time: data.date_time,
      reminder_minutes: data.reminder_minutes,
      status: 'UPCOMING',
      created_at: Date.now(),
    };
    appointmentsMap.set(apt.id, apt);
    return apt;
  },

  update(id, userId, patch) {
    const apt = appointmentsMap.get(id);
    if (!apt || apt.user_id !== userId) return null;
    Object.assign(apt, patch);
    return apt;
  },

  remove(id, userId) {
    const apt = appointmentsMap.get(id);
    if (!apt || apt.user_id !== userId) return false;
    appointmentsMap.delete(id);
    return true;
  },
};

// ── Insights ──────────────────────────────────────────────────────
const insights = {
  list(userId) {
    const results = [];
    for (const ins of insightsMap.values()) {
      if (ins.user_id === userId) results.push(ins);
    }
    return results.sort((a, b) => b.timestamp - a.timestamp);
  },
};

// ── Emergency Contacts ────────────────────────────────────────────
const emergencyContacts = {
  list(userId) {
    const results = [];
    for (const c of emergencyContactsMap.values()) {
      if (c.user_id === userId) results.push(c);
    }
    return results.sort((a, b) => a.order - b.order);
  },

  create(userId, data) {
    const contact = {
      id: uuidv4(),
      user_id: userId,
      name: data.name,
      relationship: data.relationship,
      phone: data.phone,
      email: data.email || null,
      is_primary: data.is_primary || false,
      order: data.order || 0,
    };
    emergencyContactsMap.set(contact.id, contact);
    return contact;
  },

  update(id, userId, patch) {
    const contact = emergencyContactsMap.get(id);
    if (!contact || contact.user_id !== userId) return null;
    Object.assign(contact, patch);
    return contact;
  },

  remove(id, userId) {
    const contact = emergencyContactsMap.get(id);
    if (!contact || contact.user_id !== userId) return false;
    emergencyContactsMap.delete(id);
    return true;
  },
};

module.exports = { users, exams, appointments, insights, emergencyContacts };
