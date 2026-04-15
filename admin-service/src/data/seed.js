const bcrypt = require('bcryptjs');

const passwordHash = bcrypt.hashSync('password123', 10);

const users = [
  {
    id: 'u1',
    email: 'sarah@example.com',
    name: 'Sarah Mitchell',
    profile_picture_url: null,
    date_of_birth: 654307200000,
    phone: '+15551234567',
    password_hash: passwordHash,
  },
];

const exams = [
  {
    id: 'ex1',
    user_id: 'u1',
    title: 'Complete Blood Count (CBC)',
    type: 'Lab Results',
    date: 1711929600000,
    file_url: null,
    notes: 'Annual routine blood work',
    created_at: 1711929600000,
    updated_at: 1711929600000,
  },
  {
    id: 'ex2',
    user_id: 'u1',
    title: 'Lumbar Spine MRI',
    type: 'Radiology',
    date: 1714521600000,
    file_url: null,
    notes: 'Follow-up for lower back pain',
    created_at: 1714521600000,
    updated_at: 1714521600000,
  },
  {
    id: 'ex3',
    user_id: 'u1',
    title: 'Annual Physical Wellness',
    type: 'Prescriptions',
    date: 1717200000000,
    file_url: null,
    notes: null,
    created_at: 1717200000000,
    updated_at: 1717200000000,
  },
];

const now = Date.now();

const appointments = [
  {
    id: 'apt1',
    user_id: 'u1',
    title: 'Annual Physical Checkup',
    description: 'Routine yearly physical examination',
    doctor_name: 'Dr. Sarah Mitchell',
    location: 'City Health Clinic, Room 204',
    date_time: now + 7 * 24 * 60 * 60 * 1000,
    reminder_minutes: 30,
    status: 'UPCOMING',
    created_at: now,
  },
  {
    id: 'apt2',
    user_id: 'u1',
    title: 'Dental Cleaning',
    description: 'Regular dental cleaning and checkup',
    doctor_name: 'Bright Smile Dental',
    location: '123 Dental Ave, Suite 5',
    date_time: now + 14 * 24 * 60 * 60 * 1000,
    reminder_minutes: 60,
    status: 'UPCOMING',
    created_at: now,
  },
];

const insights = [
  {
    id: 'ins1',
    user_id: 'u1',
    type: 'heart_rate',
    title: 'Resting Heart Rate',
    description: 'Your resting heart rate is within a healthy range.',
    metric_value: 72,
    timestamp: now - 1 * 60 * 60 * 1000,
    created_at: now - 1 * 60 * 60 * 1000,
  },
  {
    id: 'ins2',
    user_id: 'u1',
    type: 'blood_pressure',
    title: 'Blood Pressure',
    description: 'Your blood pressure reading is normal.',
    metric_value: 118.75,
    timestamp: now - 2 * 60 * 60 * 1000,
    created_at: now - 2 * 60 * 60 * 1000,
  },
  {
    id: 'ins3',
    user_id: 'u1',
    type: 'sleep',
    title: 'Sleep Duration',
    description: 'You averaged 8.2 hours of sleep this week. Great job!',
    metric_value: 8.2,
    timestamp: now - 3 * 60 * 60 * 1000,
    created_at: now - 3 * 60 * 60 * 1000,
  },
  {
    id: 'ins4',
    user_id: 'u1',
    type: 'glucose',
    title: 'Fasting Glucose',
    description: 'Your fasting glucose level is within normal range.',
    metric_value: 94,
    timestamp: now - 4 * 60 * 60 * 1000,
    created_at: now - 4 * 60 * 60 * 1000,
  },
  {
    id: 'ins5',
    user_id: 'u1',
    type: 'ai_prediction',
    title: 'Focus on Vitamin D',
    description: 'Based on your recent lab results, your Vitamin D levels are slightly below optimal. Consider increasing sun exposure and adding Vitamin D-rich foods to your diet.',
    metric_value: null,
    timestamp: now - 5 * 60 * 60 * 1000,
    created_at: now - 5 * 60 * 60 * 1000,
  },
];

const emergencyContacts = [
  {
    id: 'ec1',
    user_id: 'u1',
    name: 'David Mitchell',
    relationship: 'Spouse',
    phone: '+15559876543',
    email: null,
    is_primary: true,
    order: 0,
  },
  {
    id: 'ec2',
    user_id: 'u1',
    name: 'Elena Jenkins',
    relationship: 'Sister',
    phone: '+15555678901',
    email: null,
    is_primary: false,
    order: 1,
  },
];

module.exports = { users, exams, appointments, insights, emergencyContacts };
