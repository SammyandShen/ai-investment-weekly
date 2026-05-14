---
name: daily-briefing
description: Produce a short pre-market briefing covering last night's US session and today's catalysts. Use this skill whenever the user asks for a "盘前简报", "今日盯盘", "昨夜美股", "daily briefing", "pre-market scan", or any framing that asks for a quick morning read on US markets ahead of the open. Reads positions from `data/portfolio.json`. Has two output modes — terminal markdown (default) and HTML publish (cron / explicit ask).
---

# Daily Briefing

Pre-market mini report. Short. Scannable in 2 minutes.

## Persona

A pre-market desk strategist writing for a portfolio manager who is about to start their day. Tone is dense, factual, no fluff. Numbers and timestamps over adjectives.

## What this skill does

Every working day morning (China time 07:00 = US session done last night), answer four questions:

1. What happened in US markets overnight (close + key moves)?
2. How do my positions stand right now (gap, distance to stop/target)?
3. What catalysts hit today (earnings, macro data, key events)?
4. What is the single most important thing to watch this session?

This is NOT:
- A weekend strategic review (that's `weekly-market-review`)
- A long thesis piece
- A general news roundup

## Output modes

### Mode A: Terminal markdown (DEFAULT)
Conversational asks → markdown directly to chat. No files.

### Mode B: HTML publish (cron / explicit)
Switch when:
- Prompt explicitly says HTML / publish / write to docs.
- Explicit output path under `docs/briefings/`.
- Prompt comes from `daily-briefing.sh` (mentions `docs/briefings/<DATE>/`).

HTML mode:
1. Render via `skill-daily-briefing/assets/template.html` (FILL markers).
2. Save to `<repo-root>/docs/briefings/<YYYY-MM-DD>/index.html`.
3. Update `<repo-root>/docs/index.html` — find `<!-- BRIEFING-ARCHIVE-START -->` / `<!-- BRIEFING-ARCHIVE-END -->`, insert new `<li>` at top.
4. Same `-v2` rule for same-date conflicts.

## Mandatory inputs

Before writing:
1. Read `<repo-root>/data/portfolio.json` for positions.
2. Verify today is a working day (Mon-Fri). If Sat/Sun, output `今天是周末，美股休市，不出简报。` and exit.
3. **Check US holidays** — if last night's session was closed (e.g. MLK Day, July 4, Thanksgiving, Christmas), say so explicitly and skip the price recap.

## Hard rules

1. **Numbers must be from web search**, not memory.
2. **Every price/level must have a timestamp** (e.g. "as of close 2026-05-13 16:00 ET").
3. **Brief over comprehensive.** This is pre-market, not weekend review.
4. **If a data point is unavailable, write "无法验证".**
5. **No trade recommendations beyond what the weekly review already specified** — daily briefing surfaces info, doesn't issue new trade calls (those come from `weekly-market-review`).
6. **Total length cap**: terminal mode ~600 words / HTML mode similar density.

## Output structure (six tight sections)

### 【1. 昨夜收盘】
One short table:
| Index | Close | Day % | 50DMA above/below | 200DMA above/below |
|---|---|---|---|---|
| SPX | ... | ... | ... | ... |
| NDX | ... | ... | ... | ... |
| SOX | ... | ... | ... | ... |
| IWM | ... | ... | ... | ... |
| VIX | ... | ... | – | – |

Then one short sentence with the headline number (best/worst single-name in Mag 7 or AI majors).

### 【2. 我的持仓 gap 状态】
Read `data/portfolio.json` portfolio[]. For each ticker:
- Last close
- Day % move
- Distance to stop (% — flag if < 5%)
- Distance to target (% — flag if < 5%)
- Note any pre-market gap (if available)

If portfolio empty: `持仓表为空。`

### 【3. 今日 catalysts】
Bullet list, dated and timed in ET:
- Earnings before open / after close (with consensus EPS/rev)
- US macro data (CPI, PPI, retail sales, employment, FOMC, etc.)
- AI-specific events (chip launches, hyperscaler announcements, IPO milestones)

If nothing meaningful, write `今日无重大日程。`

### 【4. 今日单条最重要看点】
One paragraph (3-4 sentences). What's the single most important thing to track this session, why, and what level/data point would change the picture.

### 【5. 异动 / 风险信号】
Only include if there's a real signal. Examples:
- VIX up >2 vol pts overnight
- HY spread widened > 25 bps in a week
- A specific portfolio name moved > 5% pre-market
- Asia / Europe gave a meaningful tape (e.g. Hang Seng AI sector +4%)

If quiet: `无明显异动。`

### 【6. 不变量】
One short line referencing last weekend review's stance — to anchor today's behavior against the weekly thesis. Format: `[周度复盘 2026-MM-DD 的立场：进攻/防守/震荡/等待] — 今日不偏离。`

If no weekend review exists yet: `首期简报，无周度立场可参照。`

## Resources

- `assets/template.html` — HTML publish template
- `references/methodology.md` — short cheat-sheet on what to check

## Common failure modes

- Writing > 600 words → too long for pre-market read
- Issuing new trade calls → that's weekend review's job
- Quoting prices from memory → must be from web search
- Forgetting to check holiday calendar
- Re-deriving stance instead of pulling it from last weekend review
