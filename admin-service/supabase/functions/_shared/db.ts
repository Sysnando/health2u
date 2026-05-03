import { createClient, SupabaseClient } from "@supabase/supabase-js";
import { env } from "./env.ts";

// Service-role client: bypasses RLS. Only used inside this function.
let client: SupabaseClient | null = null;

export function db(): SupabaseClient {
  if (!client) {
    client = createClient(env.supabaseUrl, env.supabaseServiceRoleKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
  }
  return client;
}
