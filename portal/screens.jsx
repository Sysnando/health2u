// 2YH mobile screens — all share tokens from window.H2U
const H2U = {
  bg: '#FAFBFC',
  surface: '#FFFFFF',
  ink: '#0B1626',
  ink2: '#4A5A6E',
  ink3: '#8B9AAE',
  line: '#E8ECF0',
  line2: '#D7DDE4',
  primary: 'oklch(0.45 0.08 200)',
  primaryTint: 'oklch(0.92 0.03 200)',
  ok: 'oklch(0.55 0.1 160)',
  warn: 'oklch(0.65 0.12 55)',
  tintOk: 'oklch(0.95 0.03 160)',
  tintWarn: 'oklch(0.96 0.04 55)',
  serif: '"Fraunces", "Instrument Serif", Georgia, serif',
  sans: '"Geist", -apple-system, system-ui, sans-serif',
  mono: '"Geist Mono", ui-monospace, monospace',
};
window.H2U = H2U;

// ─── shared atoms ──────────────────────────────────────────
function Mono({ children, size = 10, color, style = {} }) {
  return <span style={{ fontFamily: H2U.mono, fontSize: size, letterSpacing: 0.5, color: color || H2U.ink3, textTransform: 'uppercase', ...style }}>{children}</span>;
}
function Serif({ children, size = 22, color, style = {} }) {
  return <div style={{ fontFamily: H2U.serif, fontWeight: 400, fontSize: size, letterSpacing: -0.3, lineHeight: 1.1, color: color || H2U.ink, ...style }}>{children}</div>;
}
function Pill({ children, tone = 'ok' }) {
  const bg = tone === 'ok' ? H2U.tintOk : tone === 'warn' ? H2U.tintWarn : H2U.primaryTint;
  const fg = tone === 'ok' ? H2U.ok : tone === 'warn' ? H2U.warn : H2U.primary;
  return <span style={{ fontFamily: H2U.mono, fontSize: 9, textTransform: 'uppercase', letterSpacing: 0.8, padding: '3px 7px', borderRadius: 999, background: bg, color: fg, fontWeight: 500 }}>{children}</span>;
}
function TabBar({ active = 'home' }) {
  const items = [
    { k: 'home', l: 'Home' },
    { k: 'records', l: 'Records' },
    { k: 'upload', l: '', icon: '+' },
    { k: 'insights', l: 'Insights' },
    { k: 'profile', l: 'You' },
  ];
  return (
    <div style={{
      position: 'absolute', bottom: 0, left: 0, right: 0, zIndex: 40,
      padding: '8px 16px 28px', background: 'rgba(255,255,255,0.88)',
      backdropFilter: 'blur(20px) saturate(180%)',
      borderTop: `0.5px solid ${H2U.line}`,
      display: 'flex', justifyContent: 'space-around', alignItems: 'center',
      fontFamily: H2U.sans,
    }}>
      {items.map(it => it.k === 'upload' ? (
        <div key={it.k} style={{
          width: 48, height: 48, borderRadius: 16, background: H2U.primary,
          color: '#fff', fontFamily: H2U.serif, fontSize: 30, fontWeight: 300,
          display: 'grid', placeItems: 'center', lineHeight: 1,
          boxShadow: '0 8px 24px -8px ' + H2U.primary,
        }}>+</div>
      ) : (
        <div key={it.k} style={{ fontSize: 11, color: active === it.k ? H2U.ink : H2U.ink3, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, fontWeight: 500 }}>
          <div style={{ width: 22, height: 22, borderRadius: 6, border: `1.5px solid ${active === it.k ? H2U.ink : H2U.ink3}`, background: active === it.k ? H2U.ink : 'transparent' }} />
          <span>{it.l}</span>
        </div>
      ))}
    </div>
  );
}

// ─── helper: status bar row (dark text) ─────────────────
function StatusBarRow() {
  return (
    <div style={{ height: 54, flexShrink: 0 }} />
  );
}

// ─── Screen 1: HOME / overview ─────────────────────────
function ScreenHome() {
  return (
    <div style={{ background: H2U.bg, height: '100%', fontFamily: H2U.sans, color: H2U.ink, position: 'relative', overflow: 'hidden' }}>
      <StatusBarRow />
      {/* Greeting */}
      <div style={{ padding: '8px 22px 14px' }}>
        <Mono size={10}>TUESDAY · APR 19</Mono>
        <Serif size={34} style={{ marginTop: 10, lineHeight: 1.05 }}>
          Good morning,<br/><em style={{ fontStyle: 'italic', color: H2U.primary }}>Maria.</em>
        </Serif>
        <div style={{ fontSize: 13, color: H2U.ink2, marginTop: 10, lineHeight: 1.5 }}>
          3 documents synced overnight. 1 new insight worth a look.
        </div>
      </div>

      {/* Hero insight card */}
      <div style={{ margin: '6px 16px 16px', background: H2U.ink, color: '#fff', borderRadius: 22, padding: '20px 20px 22px', position: 'relative', overflow: 'hidden' }}>
        <Mono color="rgba(255,255,255,0.55)" size={9}>INSIGHT · NEW</Mono>
        <div style={{ fontFamily: H2U.serif, fontSize: 22, lineHeight: 1.2, marginTop: 10, letterSpacing: -0.3 }}>
          Your vitamin D has trended down for 3 quarters.
        </div>
        <div style={{ fontSize: 12.5, color: 'rgba(255,255,255,0.72)', marginTop: 10, lineHeight: 1.55 }}>
          Last three readings form a clear downward pattern. Supplementation is commonly recommended at this level.
        </div>
        <div style={{ display: 'flex', gap: 10, marginTop: 16 }}>
          <div style={{ padding: '8px 12px', borderRadius: 10, background: '#fff', color: H2U.ink, fontSize: 12, fontWeight: 500 }}>See timeline →</div>
          <div style={{ padding: '8px 12px', borderRadius: 10, border: '1px solid rgba(255,255,255,0.2)', fontSize: 12 }}>Dismiss</div>
        </div>
      </div>

      {/* Vitals row */}
      <div style={{ padding: '6px 16px 14px' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', padding: '0 6px 10px' }}>
          <Mono>SNAPSHOT</Mono>
          <Mono color={H2U.ink2}>Last 6 mo</Mono>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
          {[
            { l: 'HDL', v: '62', u: 'mg/dL', t: '↑ 8%', tone: 'ok' },
            { l: 'HbA1c', v: '5.4', u: '%', t: '↓ 0.3', tone: 'ok' },
            { l: 'Vit D', v: '21', u: 'ng/mL', t: 'below', tone: 'warn' },
            { l: 'RHR', v: '68', u: 'bpm', t: 'stable', tone: 'ok' },
          ].map(s => (
            <div key={s.l} style={{ background: H2U.surface, borderRadius: 14, padding: '14px 14px 12px', border: `0.5px solid ${H2U.line}` }}>
              <Mono size={9.5}>{s.l}</Mono>
              <div style={{ fontFamily: H2U.serif, fontSize: 28, marginTop: 8, lineHeight: 1 }}>
                {s.v}<span style={{ fontFamily: H2U.mono, fontSize: 10, color: H2U.ink3, marginLeft: 4, letterSpacing: 0 }}>{s.u}</span>
              </div>
              <div style={{ marginTop: 8 }}><Pill tone={s.tone}>{s.t}</Pill></div>
            </div>
          ))}
        </div>
      </div>

      {/* Recent */}
      <div style={{ padding: '8px 16px 120px' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', padding: '0 6px 10px' }}>
          <Mono>RECENT</Mono>
          <Mono color={H2U.ink2}>See all →</Mono>
        </div>
        <div style={{ background: H2U.surface, borderRadius: 14, border: `0.5px solid ${H2U.line}`, overflow: 'hidden' }}>
          {[
            { lang: 'PT', ttl: 'Hemograma Completo', src: 'Lab Ferraz · Lisboa', date: 'Apr 14', tone: 'ok' },
            { lang: 'EN', ttl: 'Lipid Panel', src: 'Quest Diagnostics', date: 'Mar 28', tone: 'ok' },
            { lang: 'ES', ttl: 'Análisis Tiroideo', src: 'Sanitas · Madrid', date: 'Mar 02', tone: 'warn' },
          ].map((e, i, arr) => (
            <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '14px 14px', borderBottom: i < arr.length - 1 ? `0.5px solid ${H2U.line}` : 'none' }}>
              <div style={{ width: 36, height: 44, borderRadius: 4, background: H2U.bg, border: `0.5px solid ${H2U.line2}`, display: 'grid', placeItems: 'center', fontFamily: H2U.mono, fontSize: 10, color: H2U.ink3, letterSpacing: 0.5 }}>{e.lang}</div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 14, color: H2U.ink, fontWeight: 500 }}>{e.ttl}</div>
                <div style={{ fontFamily: H2U.mono, fontSize: 10.5, color: H2U.ink3, marginTop: 3 }}>{e.src}</div>
              </div>
              <div style={{ textAlign: 'right' }}>
                <Mono size={10} color={H2U.ink2}>{e.date}</Mono>
                <div style={{ marginTop: 6 }}><Pill tone={e.tone}>{e.tone === 'ok' ? 'normal' : 'review'}</Pill></div>
              </div>
            </div>
          ))}
        </div>
      </div>

      <TabBar active="home" />
    </div>
  );
}

// ─── Screen 2: UPLOAD — ingesting any language ─────────
function ScreenUpload() {
  return (
    <div style={{ background: H2U.bg, height: '100%', fontFamily: H2U.sans, color: H2U.ink, position: 'relative', overflow: 'hidden' }}>
      <StatusBarRow />
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 18px 0' }}>
        <div style={{ fontSize: 22, lineHeight: 1 }}>×</div>
        <Mono size={10.5} color={H2U.ink2}>NEW DOCUMENT</Mono>
        <div style={{ width: 18 }} />
      </div>

      <div style={{ padding: '32px 22px 16px' }}>
        <Mono>STEP 01 · SEND IT IN</Mono>
        <Serif size={30} style={{ marginTop: 12, letterSpacing: -0.4, lineHeight: 1.05 }}>
          Drop an exam.<br/>Any lab. <em style={{ fontStyle: 'italic', color: H2U.primary }}>Any language.</em>
        </Serif>
        <div style={{ fontSize: 13.5, color: H2U.ink2, marginTop: 12, lineHeight: 1.55 }}>
          We accept PDFs, photos, paper reports, handwritten notes and forwarded emails.
        </div>
      </div>

      {/* Drop zone */}
      <div style={{ margin: '18px 22px 14px', padding: '32px 22px', borderRadius: 20, background: H2U.surface, border: `1.5px dashed ${H2U.line2}`, textAlign: 'center' }}>
        <div style={{ width: 56, height: 56, borderRadius: 16, background: H2U.primaryTint, margin: '0 auto 14px', display: 'grid', placeItems: 'center', color: H2U.primary, fontFamily: H2U.serif, fontSize: 32, lineHeight: 1 }}>↑</div>
        <div style={{ fontSize: 15, fontWeight: 500 }}>Tap to choose a file</div>
        <div style={{ fontSize: 12, color: H2U.ink3, marginTop: 6 }}>or drag one in from Files</div>
      </div>

      {/* Source options */}
      <div style={{ padding: '4px 22px 16px', display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 10 }}>
        {[
          { l: 'Camera', s: 'Scan paper' },
          { l: 'Email', s: 'Forward' },
          { l: 'Lab link', s: '12 connected' },
        ].map(o => (
          <div key={o.l} style={{ padding: '14px 12px', borderRadius: 14, background: H2U.surface, border: `0.5px solid ${H2U.line}`, textAlign: 'center' }}>
            <div style={{ width: 28, height: 28, background: H2U.bg, borderRadius: 8, margin: '0 auto 10px', border: `0.5px solid ${H2U.line2}` }} />
            <div style={{ fontSize: 12.5, fontWeight: 500 }}>{o.l}</div>
            <Mono size={9}>{o.s}</Mono>
          </div>
        ))}
      </div>

      {/* Language pills */}
      <div style={{ padding: '16px 22px 0' }}>
        <Mono>WE READ 24 LANGUAGES</Mono>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6, marginTop: 12 }}>
          {['pt-BR', 'pt-PT', 'en-US', 'es-ES', 'fr-FR', 'it-IT', 'de-DE', 'ja-JP', '+16'].map((l, i) => (
            <span key={l} style={{ fontFamily: H2U.mono, fontSize: 11, padding: '5px 9px', borderRadius: 999, background: i < 2 ? H2U.ink : H2U.surface, color: i < 2 ? '#fff' : H2U.ink2, border: i < 2 ? 'none' : `0.5px solid ${H2U.line2}` }}>{l}</span>
          ))}
        </div>
      </div>

      <TabBar active="upload" />
    </div>
  );
}

// ─── Screen 3: INTERPRETING — live AI ingestion ───────
function ScreenInterpreting() {
  return (
    <div style={{ background: H2U.bg, height: '100%', fontFamily: H2U.sans, color: H2U.ink, position: 'relative', overflow: 'hidden' }}>
      <StatusBarRow />
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 18px 0' }}>
        <div style={{ fontSize: 22, lineHeight: 1 }}>×</div>
        <Mono size={10.5} color={H2U.ink2}>STEP 02 · INTERPRETING</Mono>
        <div style={{ width: 18 }} />
      </div>

      {/* Doc preview with highlights */}
      <div style={{ margin: '22px 22px 0', borderRadius: 16, background: H2U.surface, border: `0.5px solid ${H2U.line}`, overflow: 'hidden' }}>
        <div style={{ padding: '10px 14px', borderBottom: `0.5px solid ${H2U.line}`, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <Mono size={10}>HEMOGRAMA.PDF · PT-BR</Mono>
          <Pill tone="info">reading…</Pill>
        </div>
        <div style={{ padding: '14px 16px', fontFamily: H2U.mono, fontSize: 11, lineHeight: 1.7, color: H2U.ink2 }}>
          <div>Lab Central · São Paulo</div>
          <div>Paciente: M. Silva · 04/14/26</div>
          <div style={{ marginTop: 8 }}>
            Hemácias <span style={{ background: H2U.primaryTint, padding: '0 3px', borderRadius: 2, color: H2U.ink }}>4.82 mi/mm³</span>
          </div>
          <div>
            Hemoglobina <span style={{ background: H2U.primaryTint, padding: '0 3px', borderRadius: 2, color: H2U.ink }}>14.1 g/dL</span>
          </div>
          <div>
            Colesterol Total <span style={{ background: H2U.primaryTint, padding: '0 3px', borderRadius: 2, color: H2U.ink }}>192 mg/dL</span>
          </div>
          <div>
            Triglicerídeos <span style={{ background: 'oklch(0.94 0.05 55)', padding: '0 3px', borderRadius: 2, color: H2U.ink }}>118 mg/dL</span>
          </div>
        </div>
      </div>

      {/* Arrow */}
      <div style={{ textAlign: 'center', padding: '14px 0 8px' }}>
        <Mono size={9.5}>TRANSLATE · NORMALIZE · STANDARDIZE</Mono>
        <div style={{ fontFamily: H2U.mono, fontSize: 14, color: H2U.ink3, marginTop: 4 }}>↓</div>
      </div>

      {/* Standardized output */}
      <div style={{ margin: '0 22px 16px', borderRadius: 16, background: H2U.ink, color: '#fff', overflow: 'hidden' }}>
        <div style={{ padding: '12px 16px', borderBottom: '0.5px solid rgba(255,255,255,0.1)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <Mono size={10} color="rgba(255,255,255,0.55)">STANDARDIZED · LOINC</Mono>
          <Mono size={10} color="rgba(255,255,255,0.4)">v2.78</Mono>
        </div>
        <div style={{ padding: '8px 4px' }}>
          {[
            { k: 'Erythrocytes', c: '789-8', v: '4.82', u: '×10⁶/µL', s: 'normal', warn: false },
            { k: 'Hemoglobin', c: '718-7', v: '14.1', u: 'g/dL', s: 'normal', warn: false },
            { k: 'Cholesterol, total', c: '2093-3', v: '192', u: 'mg/dL', s: 'normal', warn: false },
            { k: 'Triglycerides', c: '2571-8', v: '118', u: 'mg/dL', s: 'borderline', warn: true },
          ].map((r, i) => (
            <div key={i} style={{ display: 'grid', gridTemplateColumns: '1fr auto', gap: 10, padding: '10px 14px', alignItems: 'center' }}>
              <div>
                <div style={{ fontSize: 12.5, color: '#fff' }}>{r.k}</div>
                <Mono size={9.5} color="rgba(255,255,255,0.45)">{r.c}</Mono>
              </div>
              <div style={{ textAlign: 'right' }}>
                <div style={{ fontFamily: H2U.mono, fontSize: 12, color: '#fff' }}>{r.v} <span style={{ color: 'rgba(255,255,255,0.5)' }}>{r.u}</span></div>
                <div style={{ marginTop: 4 }}>
                  <span style={{ fontFamily: H2U.mono, fontSize: 9, textTransform: 'uppercase', letterSpacing: 0.8, padding: '2px 6px', borderRadius: 999, background: r.warn ? 'oklch(0.3 0.08 55)' : 'oklch(0.3 0.05 160)', color: r.warn ? 'oklch(0.8 0.1 55)' : 'oklch(0.8 0.1 160)' }}>{r.s}</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      <div style={{ padding: '4px 22px' }}>
        <div style={{ padding: '14px 16px', borderRadius: 14, background: H2U.primaryTint, border: `0.5px solid oklch(0.82 0.05 200)` }}>
          <Mono color={H2U.primary} size={9.5}>DONE · 6.4S · 4 BIOMARKERS</Mono>
          <div style={{ fontSize: 13, color: H2U.ink, marginTop: 6, lineHeight: 1.5 }}>
            Added to your timeline. Triglycerides are close to the upper limit — we'll watch them.
          </div>
        </div>
      </div>

      <TabBar active="upload" />
    </div>
  );
}

// ─── Screen 4: BIOMARKER DETAIL ────────────────────────
function ScreenBiomarker() {
  return (
    <div style={{ background: H2U.bg, height: '100%', fontFamily: H2U.sans, color: H2U.ink, position: 'relative', overflow: 'hidden' }}>
      <StatusBarRow />
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 18px 0' }}>
        <div style={{ fontFamily: H2U.mono, fontSize: 13, color: H2U.ink2 }}>← Back</div>
        <Mono size={10.5} color={H2U.ink2}>DETAIL</Mono>
        <Mono size={10.5} color={H2U.ink2}>Share</Mono>
      </div>

      <div style={{ padding: '24px 22px 4px' }}>
        <Mono>VITAMIN D · 25-HYDROXY</Mono>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 10, marginTop: 12 }}>
          <div style={{ fontFamily: H2U.serif, fontSize: 68, lineHeight: 0.9, letterSpacing: -1.5 }}>21</div>
          <div style={{ fontFamily: H2U.mono, fontSize: 14, color: H2U.ink3 }}>ng/mL</div>
        </div>
        <div style={{ marginTop: 10, display: 'flex', gap: 8, alignItems: 'center' }}>
          <Pill tone="warn">below range</Pill>
          <Mono color={H2U.ink2}>Range 30–100</Mono>
        </div>
      </div>

      {/* Chart */}
      <div style={{ margin: '18px 22px 0', padding: '16px 14px 10px', background: H2U.surface, borderRadius: 16, border: `0.5px solid ${H2U.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', padding: '0 6px 10px' }}>
          <Mono>4 YEARS · 11 READINGS</Mono>
          <Mono color={H2U.ink2}>1y · 4y · All</Mono>
        </div>
        <svg viewBox="0 0 340 140" style={{ width: '100%', height: 140, display: 'block' }}>
          {/* range band */}
          <rect x="0" y="20" width="340" height="36" fill="oklch(0.95 0.03 160)" />
          <line x1="0" y1="20" x2="340" y2="20" stroke="oklch(0.85 0.03 160)" strokeDasharray="2 2" />
          {/* line */}
          <path d="M6,42 L40,48 L74,44 L108,52 L142,58 L176,68 L210,76 L244,82 L278,90 L312,98 L334,104"
                fill="none" stroke={H2U.primary} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/>
          {/* last-point pulse */}
          <circle cx="334" cy="104" r="10" fill="oklch(0.65 0.12 55 / 0.15)"/>
          <circle cx="334" cy="104" r="4" fill="oklch(0.65 0.12 55)"/>
          <circle cx="278" cy="90" r="2.5" fill={H2U.primary}/>
          <circle cx="210" cy="76" r="2.5" fill={H2U.primary}/>
          {/* axis ticks */}
          <text x="6" y="132" fontFamily="Geist Mono" fontSize="9" fill={H2U.ink3}>2022</text>
          <text x="110" y="132" fontFamily="Geist Mono" fontSize="9" fill={H2U.ink3}>2023</text>
          <text x="210" y="132" fontFamily="Geist Mono" fontSize="9" fill={H2U.ink3}>2024</text>
          <text x="312" y="132" fontFamily="Geist Mono" fontSize="9" fill={H2U.ink3}>apr 26</text>
        </svg>
      </div>

      {/* AI note */}
      <div style={{ margin: '14px 22px 0', padding: '16px 16px', borderRadius: 14, background: H2U.ink, color: '#fff' }}>
        <Mono color="rgba(255,255,255,0.55)" size={9.5}>WHAT THIS MEANS</Mono>
        <div style={{ fontFamily: H2U.serif, fontSize: 18, lineHeight: 1.25, marginTop: 10, letterSpacing: -0.2 }}>
          3 straight quarters of decline.
        </div>
        <div style={{ fontSize: 12.5, color: 'rgba(255,255,255,0.72)', marginTop: 10, lineHeight: 1.55 }}>
          Your level has dropped from 36 to 21 ng/mL since Jan 2025. Common causes: reduced sun exposure, dietary change, or absorption issues. Worth discussing at your next visit.
        </div>
        <div style={{ display: 'flex', gap: 10, marginTop: 14 }}>
          <Mono color="rgba(255,255,255,0.55)" size={9}>CONFIDENCE 94%</Mono>
          <Mono color="rgba(255,255,255,0.55)" size={9}>· 3 SOURCES</Mono>
        </div>
      </div>

      {/* Sources */}
      <div style={{ padding: '14px 22px 120px' }}>
        <div style={{ padding: '0 6px 10px' }}><Mono>READINGS</Mono></div>
        <div style={{ background: H2U.surface, borderRadius: 14, border: `0.5px solid ${H2U.line}`, overflow: 'hidden' }}>
          {[
            { d: 'Apr 14, 2026', v: '21', lab: 'Lab Ferraz · pt-PT' },
            { d: 'Dec 02, 2025', v: '26', lab: 'Quest · en-US' },
            { d: 'Aug 10, 2025', v: '31', lab: 'Sanitas · es-ES' },
          ].map((r, i, arr) => (
            <div key={i} style={{ display: 'grid', gridTemplateColumns: '1fr auto', gap: 10, padding: '12px 14px', borderBottom: i < arr.length - 1 ? `0.5px solid ${H2U.line}` : 'none', alignItems: 'center' }}>
              <div>
                <div style={{ fontSize: 13 }}>{r.d}</div>
                <Mono size={10}>{r.lab}</Mono>
              </div>
              <div style={{ fontFamily: H2U.mono, fontSize: 13, color: H2U.ink }}>{r.v} <span style={{ color: H2U.ink3 }}>ng/mL</span></div>
            </div>
          ))}
        </div>
      </div>

      <TabBar active="records" />
    </div>
  );
}

// ─── Screen 5: INSIGHTS FEED ───────────────────────────
function ScreenInsights() {
  return (
    <div style={{ background: H2U.bg, height: '100%', fontFamily: H2U.sans, color: H2U.ink, position: 'relative', overflow: 'hidden' }}>
      <StatusBarRow />
      <div style={{ padding: '8px 22px 14px' }}>
        <Mono>STEP 03 · UNDERSTAND</Mono>
        <Serif size={34} style={{ marginTop: 12, letterSpacing: -0.4, lineHeight: 1.05 }}>
          Your data,<br/><em style={{ fontStyle: 'italic', color: H2U.primary }}>talking back.</em>
        </Serif>
      </div>

      {/* Filter */}
      <div style={{ padding: '2px 22px 12px', display: 'flex', gap: 6, overflowX: 'auto' }}>
        {['All', 'Flags', 'Trends', 'Correlations', 'Win'].map((t, i) => (
          <span key={t} style={{ fontFamily: H2U.mono, fontSize: 11, padding: '6px 11px', borderRadius: 999, background: i === 0 ? H2U.ink : H2U.surface, color: i === 0 ? '#fff' : H2U.ink2, border: i === 0 ? 'none' : `0.5px solid ${H2U.line2}`, whiteSpace: 'nowrap' }}>{t}</span>
        ))}
      </div>

      <div style={{ padding: '0 16px 120px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {/* Flag */}
        <div style={{ background: H2U.surface, borderRadius: 16, border: `0.5px solid ${H2U.line}`, padding: '16px 16px' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <Pill tone="warn">proactive flag</Pill>
            <Mono color={H2U.ink3}>2d ago</Mono>
          </div>
          <div style={{ fontFamily: H2U.serif, fontSize: 19, lineHeight: 1.25, marginTop: 10, letterSpacing: -0.2 }}>
            Fasting glucose has crept up toward the upper limit.
          </div>
          <div style={{ fontSize: 12.5, color: H2U.ink2, marginTop: 8, lineHeight: 1.5 }}>
            Still "normal" at 97 mg/dL, but 4 consecutive rises. Worth flagging before it becomes a pattern.
          </div>
        </div>

        {/* Correlation */}
        <div style={{ background: H2U.surface, borderRadius: 16, border: `0.5px solid ${H2U.line}`, padding: '16px 16px' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <Pill tone="info">correlation</Pill>
            <Mono color={H2U.ink3}>5d ago</Mono>
          </div>
          <div style={{ fontFamily: H2U.serif, fontSize: 19, lineHeight: 1.25, marginTop: 10, letterSpacing: -0.2 }}>
            HDL climbed 8% since you started walking.
          </div>
          <svg viewBox="0 0 280 50" style={{ width: '100%', height: 50, marginTop: 10 }}>
            <path d="M4,34 C40,30 70,24 110,22 S180,16 220,10 260,8 276,6" fill="none" stroke={H2U.primary} strokeWidth="1.6"/>
            <path d="M4,42 C60,40 120,38 180,34 S240,30 276,28" fill="none" stroke={H2U.ink3} strokeWidth="1.2" strokeDasharray="3 3"/>
          </svg>
          <Mono size={9.5} style={{ marginTop: 6, display: 'block' }}>HDL ● · STEPS ⋯</Mono>
        </div>

        {/* Win */}
        <div style={{ background: H2U.tintOk, borderRadius: 16, border: `0.5px solid oklch(0.85 0.05 160)`, padding: '16px 16px' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <Pill tone="ok">win</Pill>
            <Mono color={H2U.ink3}>1w ago</Mono>
          </div>
          <div style={{ fontFamily: H2U.serif, fontSize: 19, lineHeight: 1.25, marginTop: 10, letterSpacing: -0.2, color: H2U.ink }}>
            HbA1c reached your personal best. 5.4%.
          </div>
          <div style={{ fontSize: 12.5, color: H2U.ink2, marginTop: 8, lineHeight: 1.5 }}>
            Lowest reading in 3 years of data. Whatever you're doing, keep it up.
          </div>
        </div>
      </div>

      <TabBar active="insights" />
    </div>
  );
}

// ─── Screen 6: SHARE with DOCTOR ────────────────────────
function ScreenShare() {
  return (
    <div style={{ background: H2U.bg, height: '100%', fontFamily: H2U.sans, color: H2U.ink, position: 'relative', overflow: 'hidden' }}>
      <StatusBarRow />
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 18px 0' }}>
        <div style={{ fontSize: 22, lineHeight: 1 }}>×</div>
        <Mono size={10.5} color={H2U.ink2}>SHARE WITH DOCTOR</Mono>
        <div style={{ width: 18 }} />
      </div>

      <div style={{ padding: '24px 22px 12px' }}>
        <Serif size={30} style={{ letterSpacing: -0.4, lineHeight: 1.1 }}>
          A doctor-ready summary,<br/><em style={{ fontStyle: 'italic', color: H2U.primary }}>in one link.</em>
        </Serif>
        <div style={{ fontSize: 13, color: H2U.ink2, marginTop: 12, lineHeight: 1.55 }}>
          Choose what to include. We'll generate a secure link that expires when you say so.
        </div>
      </div>

      {/* Include list */}
      <div style={{ margin: '12px 22px 0', background: H2U.surface, borderRadius: 14, border: `0.5px solid ${H2U.line}`, overflow: 'hidden' }}>
        {[
          { l: 'Full biomarker timeline', s: '4 years · 11 labs · 182 markers', on: true },
          { l: 'AI insights & flags', s: '8 active', on: true },
          { l: 'Prescriptions', s: 'Last 12 months', on: true },
          { l: 'Imaging reports', s: '3 studies', on: false },
        ].map((it, i, arr) => (
          <div key={i} style={{ display: 'flex', alignItems: 'center', padding: '14px 14px', borderBottom: i < arr.length - 1 ? `0.5px solid ${H2U.line}` : 'none', gap: 12 }}>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontWeight: 500 }}>{it.l}</div>
              <Mono size={10}>{it.s}</Mono>
            </div>
            <div style={{ width: 36, height: 22, borderRadius: 11, background: it.on ? H2U.primary : H2U.line2, position: 'relative' }}>
              <div style={{ position: 'absolute', top: 2, left: it.on ? 16 : 2, width: 18, height: 18, borderRadius: 9, background: '#fff', boxShadow: '0 1px 3px rgba(0,0,0,0.18)' }} />
            </div>
          </div>
        ))}
      </div>

      {/* Expiry */}
      <div style={{ padding: '18px 22px 10px' }}><Mono>LINK EXPIRES</Mono></div>
      <div style={{ margin: '0 22px', display: 'grid', gridTemplateColumns: '1fr 1fr 1fr 1fr', gap: 6 }}>
        {['24h', '7d', '30d', 'Never'].map((t, i) => (
          <div key={t} style={{ padding: '10px 0', textAlign: 'center', borderRadius: 10, background: i === 1 ? H2U.ink : H2U.surface, color: i === 1 ? '#fff' : H2U.ink, fontFamily: H2U.mono, fontSize: 12, border: i === 1 ? 'none' : `0.5px solid ${H2U.line2}` }}>{t}</div>
        ))}
      </div>

      {/* Link preview */}
      <div style={{ margin: '18px 22px 0', padding: '16px 14px', background: H2U.ink, color: '#fff', borderRadius: 14 }}>
        <Mono color="rgba(255,255,255,0.5)" size={9.5}>SECURE LINK · EXPIRES IN 7 DAYS</Mono>
        <div style={{ fontFamily: H2U.mono, fontSize: 11.5, marginTop: 8, color: '#fff', wordBreak: 'break-all' }}>
          2yh.app/s/maria-silva/a8fK3xQ
        </div>
        <div style={{ display: 'flex', gap: 8, marginTop: 14 }}>
          <div style={{ flex: 1, padding: '10px 12px', borderRadius: 10, background: '#fff', color: H2U.ink, fontSize: 12.5, fontWeight: 500, textAlign: 'center' }}>Copy link</div>
          <div style={{ flex: 1, padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(255,255,255,0.2)', fontSize: 12.5, textAlign: 'center' }}>Export PDF</div>
        </div>
      </div>

      <TabBar active="records" />
    </div>
  );
}

Object.assign(window, { ScreenHome, ScreenUpload, ScreenInterpreting, ScreenBiomarker, ScreenInsights, ScreenShare });
