import { Context, Next } from "hono";
import { verifyAccessToken } from "./jwt.ts";

export interface AuthUser {
  id: string;
  email: string;
}

// Hono middleware: require a valid Bearer token and stash the user on the
// context so route handlers can call c.get("user").
export async function requireAuth(c: Context, next: Next) {
  const header = c.req.header("authorization");
  if (!header || !header.toLowerCase().startsWith("bearer ")) {
    return c.json(
      { error: { code: "UNAUTHORIZED", message: "Missing or invalid authorization header" } },
      401,
    );
  }

  const token = header.slice(7);
  try {
    const payload = verifyAccessToken(token);
    const user: AuthUser = { id: payload.sub, email: payload.email };
    c.set("user", user);
    await next();
  } catch {
    return c.json(
      { error: { code: "UNAUTHORIZED", message: "Invalid or expired token" } },
      401,
    );
  }
}

export function currentUser(c: Context): AuthUser {
  return c.get("user") as AuthUser;
}
