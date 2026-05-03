// Typed access to the secrets configured with `supabase secrets set`.
// Fails fast at startup so a missing secret surfaces in logs, not at first use.

function required(name: string): string {
  const value = Deno.env.get(name);
  if (!value) {
    throw new Error(`Missing required env var: ${name}`);
  }
  return value;
}

export const env = {
  supabaseUrl: required("SUPABASE_URL"),
  supabaseServiceRoleKey: required("SUPABASE_SERVICE_ROLE_KEY"),

  jwtSecret: required("JWT_SECRET"),
  jwtExpiresIn: Deno.env.get("JWT_EXPIRES_IN") ?? "1h",
  // Refresh tokens live this long in the DB. Shorter than a typical session
  // so an abandoned device is not logged in forever.
  refreshTokenTtlDays: Number(Deno.env.get("REFRESH_TOKEN_TTL_DAYS") ?? "30"),

  r2AccountId: Deno.env.get("R2_ACCOUNT_ID") ?? "",
  r2AccessKeyId: Deno.env.get("R2_ACCESS_KEY_ID") ?? "",
  r2SecretAccessKey: Deno.env.get("R2_SECRET_ACCESS_KEY") ?? "",
  r2Bucket: Deno.env.get("R2_BUCKET") ?? "",

  anthropicApiKey: Deno.env.get("ANTHROPIC_API_KEY") ?? "",
};
