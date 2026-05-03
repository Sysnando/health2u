import { Context } from "hono";

// Uniform error envelope matching the original Express service so the
// mobile client doesn't need to learn a new error shape.
export function errorBody(code: string, message: string) {
  return { error: { code, message } };
}

export function badRequest(c: Context, message: string) {
  return c.json(errorBody("BAD_REQUEST", message), 400);
}

export function notFound(c: Context, message = "Not found") {
  return c.json(errorBody("NOT_FOUND", message), 404);
}

export function internal(c: Context, message: string) {
  console.error("internal error:", message);
  return c.json(errorBody("INTERNAL_ERROR", message), 500);
}
