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

// 422 Unprocessable Entity — for inputs that are syntactically valid but
// semantically rejected (e.g. an uploaded file the AI classifies as
// not-a-medical-document).
export function unprocessable(c: Context, code: string, message: string) {
  return c.json(errorBody(code, message), 422);
}
