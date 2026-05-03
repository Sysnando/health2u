import jwt from "jsonwebtoken";
import { env } from "./env.ts";

export interface AccessTokenPayload {
  sub: string; // user id
  email: string;
}

export function signAccessToken(user: { id: string; email: string }): string {
  return jwt.sign(
    { sub: user.id, email: user.email },
    env.jwtSecret,
    { expiresIn: env.jwtExpiresIn },
  );
}

export function verifyAccessToken(token: string): AccessTokenPayload {
  // Throws on invalid/expired; caller turns that into a 401.
  return jwt.verify(token, env.jwtSecret) as AccessTokenPayload;
}
