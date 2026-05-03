import { Hono } from "hono";
import { currentUser, requireAuth } from "../../_shared/auth.ts";
import { db } from "../../_shared/db.ts";
import { badRequest, internal, notFound } from "../../_shared/errors.ts";

const app = new Hono();
app.use("*", requireAuth);

// Note: `order` is a reserved word; Supabase-js quotes it automatically.
const COLUMNS =
  'id, user_id, name, relationship, phone, email, is_primary, "order", created_at';

app.get("/", async (c) => {
  const me = currentUser(c);
  const { data, error } = await db()
    .from("emergency_contacts")
    .select(COLUMNS)
    .eq("user_id", me.id)
    .order("order", { ascending: true });

  if (error) return internal(c, error.message);
  return c.json(data ?? []);
});

app.post("/", async (c) => {
  const me = currentUser(c);
  const body = await c.req.json().catch(() => ({}));
  const { name, relationship, phone, email, is_primary, order } = body;

  if (!name || !relationship || !phone) {
    return badRequest(c, "Missing required fields: name, relationship, phone");
  }

  const { data, error } = await db()
    .from("emergency_contacts")
    .insert({
      user_id: me.id,
      name,
      relationship,
      phone,
      email: email ?? null,
      is_primary: is_primary ?? false,
      order: order ?? 0,
    })
    .select(COLUMNS)
    .single();

  if (error) return internal(c, error.message);
  return c.json(data, 201);
});

app.put("/:id", async (c) => {
  const me = currentUser(c);
  const patch = await c.req.json().catch(() => ({}));

  delete patch.id;
  delete patch.user_id;
  delete patch.created_at;

  const { data, error } = await db()
    .from("emergency_contacts")
    .update(patch)
    .eq("id", c.req.param("id"))
    .eq("user_id", me.id)
    .select(COLUMNS)
    .maybeSingle();

  if (error) return internal(c, error.message);
  if (!data) return notFound(c, "Emergency contact not found");
  return c.json(data);
});

app.delete("/:id", async (c) => {
  const me = currentUser(c);
  const { data, error } = await db()
    .from("emergency_contacts")
    .delete()
    .eq("id", c.req.param("id"))
    .eq("user_id", me.id)
    .select("id")
    .maybeSingle();

  if (error) return internal(c, error.message);
  if (!data) return notFound(c, "Emergency contact not found");
  return c.body(null, 204);
});

export default app;
