-- Seed data: the same demo user / records the in-memory version used,
-- so the Android app continues to work with sarah@example.com / password123.
--
-- pgcrypto lives in the `extensions` schema on hosted Supabase, so we
-- qualify the calls explicitly.

-- ── users ─────────────────────────────────────────────────────────────
insert into public.users (id, email, password_hash, name, phone, date_of_birth, profile_picture_url)
values (
  '00000000-0000-0000-0000-000000000001',
  'sarah@example.com',
  extensions.crypt('password123', extensions.gen_salt('bf', 10)),
  'Sarah Mitchell',
  '+15551234567',
  654307200000,
  null
);

-- ── exams ─────────────────────────────────────────────────────────────
insert into public.exams (user_id, title, type, date, notes) values
  ('00000000-0000-0000-0000-000000000001',
   'Complete Blood Count (CBC)', 'Lab Results', 1711929600000, 'Annual routine blood work'),
  ('00000000-0000-0000-0000-000000000001',
   'Lumbar Spine MRI', 'Radiology', 1714521600000, 'Follow-up for lower back pain'),
  ('00000000-0000-0000-0000-000000000001',
   'Annual Physical Wellness', 'Prescriptions', 1717200000000, null);

-- ── appointments ──────────────────────────────────────────────────────
-- `date_time` is seeded relative to the moment the migration runs so the
-- mobile app always sees "upcoming" demo appointments.
insert into public.appointments
  (user_id, title, description, doctor_name, location, date_time, reminder_minutes, status)
values
  ('00000000-0000-0000-0000-000000000001',
   'Annual Physical Checkup', 'Routine yearly physical examination',
   'Dr. Sarah Mitchell', 'City Health Clinic, Room 204',
   (extract(epoch from (now() + interval '7 days')) * 1000)::bigint, 30, 'UPCOMING'),
  ('00000000-0000-0000-0000-000000000001',
   'Dental Cleaning', 'Regular dental cleaning and checkup',
   'Bright Smile Dental', '123 Dental Ave, Suite 5',
   (extract(epoch from (now() + interval '14 days')) * 1000)::bigint, 60, 'UPCOMING');

-- ── insights ──────────────────────────────────────────────────────────
insert into public.insights
  (user_id, type, title, description, metric_value, timestamp)
values
  ('00000000-0000-0000-0000-000000000001',
   'heart_rate', 'Resting Heart Rate',
   'Your resting heart rate is within a healthy range.', 72,
   (extract(epoch from (now() - interval '1 hour')) * 1000)::bigint),
  ('00000000-0000-0000-0000-000000000001',
   'blood_pressure', 'Blood Pressure',
   'Your blood pressure reading is normal.', 118.75,
   (extract(epoch from (now() - interval '2 hours')) * 1000)::bigint),
  ('00000000-0000-0000-0000-000000000001',
   'sleep', 'Sleep Duration',
   'You averaged 8.2 hours of sleep this week. Great job!', 8.2,
   (extract(epoch from (now() - interval '3 hours')) * 1000)::bigint),
  ('00000000-0000-0000-0000-000000000001',
   'glucose', 'Fasting Glucose',
   'Your fasting glucose level is within normal range.', 94,
   (extract(epoch from (now() - interval '4 hours')) * 1000)::bigint),
  ('00000000-0000-0000-0000-000000000001',
   'ai_prediction', 'Focus on Vitamin D',
   'Based on your recent lab results, your Vitamin D levels are slightly below optimal. Consider increasing sun exposure and adding Vitamin D-rich foods to your diet.',
   null,
   (extract(epoch from (now() - interval '5 hours')) * 1000)::bigint);

-- ── emergency_contacts ────────────────────────────────────────────────
insert into public.emergency_contacts
  (user_id, name, relationship, phone, is_primary, "order")
values
  ('00000000-0000-0000-0000-000000000001',
   'David Mitchell', 'Spouse', '+15559876543', true, 0),
  ('00000000-0000-0000-0000-000000000001',
   'Elena Jenkins', 'Sister', '+15555678901', false, 1);
