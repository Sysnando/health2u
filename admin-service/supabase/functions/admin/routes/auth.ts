import { Hono } from "hono";
import bcrypt from "bcryptjs";
import { db } from "../../_shared/db.ts";
import { signAccessToken } from "../../_shared/jwt.ts";
import { env } from "../../_shared/env.ts";
import { badRequest, errorBody, internal } from "../../_shared/errors.ts";
import { userDto } from "../../_shared/dto.ts";

const app = new Hono();

async function issueTokenPair(user: { id: string; email: string }) {
  const accessToken = signAccessToken(user);

  const expiresAt = new Date(
    Date.now() + env.refreshTokenTtlDays * 24 * 60 * 60 * 1000,
  ).toISOString();

  const { data, error } = await db()
    .from("refresh_tokens")
    .insert({ user_id: user.id, expires_at: expiresAt })
    .select("token")
    .single();

  if (error || !data) throw new Error(error?.message ?? "failed to mint refresh token");

  return { access_token: accessToken, refresh_token: data.token };
}

app.post("/login", async (c) => {
  const { email, password } = await c.req.json().catch(() => ({}));
  if (!email || !password) {
    return badRequest(c, "email and password required");
  }

  const { data: user, error } = await db()
    .from("users")
    .select("id, email, password_hash, name, phone, date_of_birth, profile_picture_url")
    .eq("email", email)
    .maybeSingle();

  if (error) return internal(c, error.message);
  if (!user) {
    return c.json(errorBody("INVALID_CREDENTIALS", "Invalid email or password"), 401);
  }

  const ok = await bcrypt.compare(password, user.password_hash);
  if (!ok) {
    return c.json(errorBody("INVALID_CREDENTIALS", "Invalid email or password"), 401);
  }

  try {
    const tokens = await issueTokenPair({ id: user.id, email: user.email });
    return c.json({ ...tokens, user: userDto(user) }, 200);
  } catch (e) {
    return internal(c, (e as Error).message);
  }
});

app.post("/refresh", async (c) => {
  const { refresh_token } = await c.req.json().catch(() => ({}));
  if (!refresh_token) {
    return c.json(errorBody("INVALID_REFRESH_TOKEN", "Invalid or expired refresh token"), 401);
  }

  // One-time-use: look up, verify not expired, delete, then mint a new pair.
  const { data: row, error } = await db()
    .from("refresh_tokens")
    .select("user_id, expires_at")
    .eq("token", refresh_token)
    .maybeSingle();

  if (error) return internal(c, error.message);
  if (!row || new Date(row.expires_at) <= new Date()) {
    return c.json(errorBody("INVALID_REFRESH_TOKEN", "Invalid or expired refresh token"), 401);
  }

  await db().from("refresh_tokens").delete().eq("token", refresh_token);

  const { data: user, error: userErr } = await db()
    .from("users")
    .select("id, email, password_hash, name, phone, date_of_birth, profile_picture_url")
    .eq("id", row.user_id)
    .maybeSingle();

  if (userErr) return internal(c, userErr.message);
  if (!user) {
    return c.json(errorBody("INVALID_REFRESH_TOKEN", "Invalid or expired refresh token"), 401);
  }

  try {
    const tokens = await issueTokenPair({ id: user.id, email: user.email });
    return c.json({ ...tokens, user: userDto(user) }, 200);
  } catch (e) {
    return internal(c, (e as Error).message);
  }
});

app.post("/logout", async (c) => {
  const { refresh_token } = await c.req.json().catch(() => ({}));
  if (refresh_token) {
    await db().from("refresh_tokens").delete().eq("token", refresh_token);
  }
  return c.body(null, 204);
});

export default app;
