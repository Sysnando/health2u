import { Hono } from "hono";
import { currentUser, requireAuth } from "../../_shared/auth.ts";
import { db } from "../../_shared/db.ts";
import { badRequest, internal, notFound } from "../../_shared/errors.ts";

const app = new Hono();
app.use("*", requireAuth);

const COLUMNS = "id, user_id, name, severity, notes, created_at";

function allergyDto(row: Record<string, unknown>) {
  const { created_at, ...rest } = row;
  return { ...rest, created_at: new Date(created_at as string).getTime() };
}

app.get("/", async (c) => {
  const me = currentUser(c);
  const { data, error } = await db()
    .from("allergies")
    .select(COLUMNS)
    .eq("user_id", me.id)
    .order("created_at", { ascending: true });
  if (error) return internal(c, error.message);
  return c.json((data ?? []).map(allergyDto));
});

app.post("/", async (c) => {
  const me = currentUser(c);
  const body = await c.req.json().catch(() => ({}));
  const { name, severity, notes } = body;
  if (!name || typeof name !== "string") return badRequest(c, "name is required");
  const { data, error } = await db()
    .from("allergies")
    .insert({ user_id: me.id, name, severity: severity ?? null, notes: notes ?? null })
    .select(COLUMNS)
    .single();
  if (error) return internal(c, error.message);
  return c.json(allergyDto(data), 201);
});

app.put("/:id", async (c) => {
  const me = currentUser(c);
  const patch = await c.req.json().catch(() => ({}));
  delete patch.id;
  delete patch.user_id;
  delete patch.created_at;
  const { data, error } = await db()
    .from("allergies")
    .update(patch)
    .eq("id", c.req.param("id"))
    .eq("user_id", me.id)
    .select(COLUMNS)
    .maybeSingle();
  if (error) return internal(c, error.message);
  if (!data) return notFound(c, "Allergy not found");
  return c.json(allergyDto(data));
});

app.delete("/:id", async (c) => {
  const me = currentUser(c);
  const { data, error } = await db()
    .from("allergies")
    .delete()
    .eq("id", c.req.param("id"))
    .eq("user_id", me.id)
    .select("id")
    .maybeSingle();
  if (error) return internal(c, error.message);
  if (!data) return notFound(c, "Allergy not found");
  return c.body(null, 204);
});

export default app;
