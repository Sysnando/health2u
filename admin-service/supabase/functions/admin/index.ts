import { Hono } from "hono";
import { cors } from "hono/cors";
import { logger } from "hono/logger";

import auth from "./routes/auth.ts";
import user from "./routes/user.ts";
import exams from "./routes/exams.ts";
import appointments from "./routes/appointments.ts";
import insights from "./routes/insights.ts";
import emergencyContacts from "./routes/emergencyContacts.ts";
import allergies from "./routes/allergies.ts";

// Supabase Edge Functions are always served under the path
// /functions/v1/<function-name>, so everything routes here is nested under
// `/admin`. We strip that prefix so routes read naturally ("/health",
// "/auth/login", etc.).
const app = new Hono().basePath("/admin");

app.use("*", logger());
app.use(
  "*",
  cors({
    origin: "*",
    allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowHeaders: ["authorization", "content-type"],
    maxAge: 3600,
  }),
);

app.get("/health", (c) => c.json({ status: "ok" }));

app.route("/auth", auth);
app.route("/user", user);
app.route("/exams", exams);
app.route("/appointments", appointments);
app.route("/insights", insights);
app.route("/emergency-contacts", emergencyContacts);
app.route("/allergies", allergies);

app.notFound((c) =>
  c.json({ error: { code: "NOT_FOUND", message: "Route not found" } }, 404)
);

app.onError((err, c) => {
  console.error("unhandled error:", err);
  return c.json(
    { error: { code: "INTERNAL_ERROR", message: err.message } },
    500,
  );
});

Deno.serve(app.fetch);
