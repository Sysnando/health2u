import { Hono } from "hono";
import { currentUser, requireAuth } from "../../_shared/auth.ts";
import { db } from "../../_shared/db.ts";
import { insightDto } from "../../_shared/dto.ts";
import { internal } from "../../_shared/errors.ts";

const app = new Hono();
app.use("*", requireAuth);

app.get("/", async (c) => {
  const me = currentUser(c);
  const { data, error } = await db()
    .from("insights")
    .select("id, user_id, type, title, description, metric_value, timestamp, created_at")
    .eq("user_id", me.id)
    .order("timestamp", { ascending: false });

  if (error) return internal(c, error.message);
  // Original API wrapped this list in { insights: [...] }; preserve that.
  return c.json({ insights: (data ?? []).map(insightDto) });
});

export default app;
