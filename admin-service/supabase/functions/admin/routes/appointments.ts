import { Hono } from "hono";
import { currentUser, requireAuth } from "../../_shared/auth.ts";
import { db } from "../../_shared/db.ts";
import { badRequest, internal, notFound } from "../../_shared/errors.ts";

const app = new Hono();
app.use("*", requireAuth);

const VALID_STATUSES = new Set(["UPCOMING", "COMPLETED", "CANCELLED"]);

// Convert timestamptz strings to epoch-ms so the mobile client can decode
// them with its millisecondsSince1970 date strategy.
function appointmentDto(row: Record<string, unknown>) {
  const { created_at, ...rest } = row;
  return {
    ...rest,
    created_at: new Date(created_at as string).getTime(),
  };
}

const COLUMNS =
  "id, user_id, title, description, doctor_name, location, date_time, reminder_minutes, status, created_at";

app.get("/", async (c) => {
  const me = currentUser(c);
  const { data, error } = await db()
    .from("appointments")
    .select(COLUMNS)
    .eq("user_id", me.id)
    .order("date_time", { ascending: true });

  if (error) return internal(c, error.message);
  return c.json((data ?? []).map(appointmentDto));
});

app.post("/", async (c) => {
  const me = currentUser(c);
  const body = await c.req.json().catch(() => ({}));
  const {
    title,
    description,
    doctor_name,
    location,
    date_time,
    reminder_minutes,
    status,
  } = body;

  if (!title || date_time == null || typeof date_time !== "number") {
    return badRequest(c, "Missing required fields: title, date_time (number)");
  }

  const appointmentStatus = status ?? "UPCOMING";
  if (!VALID_STATUSES.has(appointmentStatus)) {
    return badRequest(c, "Invalid status. Must be UPCOMING, COMPLETED, or CANCELLED");
  }

  const { data, error } = await db()
    .from("appointments")
    .insert({
      user_id: me.id,
      title,
      description: description ?? null,
      doctor_name: doctor_name ?? null,
      location: location ?? null,
      date_time,
      reminder_minutes: reminder_minutes ?? null,
      status: appointmentStatus,
    })
    .select(COLUMNS)
    .single();

  if (error) return internal(c, error.message);
  return c.json(appointmentDto(data), 201);
});

app.put("/:id", async (c) => {
  const me = currentUser(c);
  const patch = await c.req.json().catch(() => ({}));

  if (patch.status && !VALID_STATUSES.has(patch.status)) {
    return badRequest(c, "Invalid status. Must be UPCOMING, COMPLETED, or CANCELLED");
  }

  // Strip fields the client shouldn't be allowed to change.
  delete patch.id;
  delete patch.user_id;
  delete patch.created_at;

  const { data, error } = await db()
    .from("appointments")
    .update(patch)
    .eq("id", c.req.param("id"))
    .eq("user_id", me.id)
    .select(COLUMNS)
    .maybeSingle();

  if (error) return internal(c, error.message);
  if (!data) return notFound(c, "Appointment not found");
  return c.json(appointmentDto(data));
});

app.delete("/:id", async (c) => {
  const me = currentUser(c);
  const { data, error } = await db()
    .from("appointments")
    .delete()
    .eq("id", c.req.param("id"))
    .eq("user_id", me.id)
    .select("id")
    .maybeSingle();

  if (error) return internal(c, error.message);
  if (!data) return notFound(c, "Appointment not found");
  return c.body(null, 204);
});

export default app;
