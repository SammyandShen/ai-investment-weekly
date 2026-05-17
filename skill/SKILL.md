---
name: ai-turning-points
description: Run a buy-side AI industry research pass on AI investment turning points across the global AI value chain. Use this skill whenever the user asks for "AI investment research", "AI 调研报告", "AI 投资转折点", "AI 产业链周报", "扫描 AI 板块", "AI capex 跟踪", or any framing that asks to scan compute / memory / networking / power / robotics / agents / edge / drugs for trade ideas. The skill has two output modes — terminal markdown (default, conversational) and HTML publish (only when explicitly requested or driven by the weekly cron).
---

# AI Turning Points Research

Buy-side research workflow. Same methodology, two delivery surfaces.

## What this skill does

Scan the AI value chain for **investment turning points** — points where a new AI capability creates rigid demand for a hardware / data / network / power / device / service category that the market has not yet fully priced.

This is NOT:
- A general AI news roundup
- A list of "AI-related stocks"
- A model release / benchmark tracker

## Output modes — choose ONE based on user intent

### Mode A: Terminal markdown (DEFAULT)

When the user asks for the research conversationally — "做一份 AI 投资调研", "扫一下 AI 板块", "看看现在的转折点", "AI 产业链有什么新机会" — print the report **directly to the conversation as markdown**. Do NOT write any files. Do NOT touch `docs/`. Do NOT use the HTML template.

The report still follows the full structure (TL;DR, top picks, radar, deep dives, shorts, pairs, watchlist, data gaps, sources), just rendered as markdown tables and prose.

### Mode B: HTML publish

Only switch to HTML publish mode when ONE of these is true:
- The user explicitly asks for an HTML file ("生成 HTML", "写到网页", "上线", "更新网站", "publish", "weekly report").
- The user gives an explicit output path under `docs/`.
- The user mentions GitHub Pages, the weekly archive, or "publish".
- The prompt obviously comes from `weekly-update.sh` (it says something like "输出到 docs/reports/<DATE>/index.html").

In HTML publish mode:

1. Render the report into HTML using `skill/assets/template.html` (find `<!-- FILL: ... -->` markers, replace each).
2. Save to `<repo-root>/docs/reports/<YYYY-MM-DD>/index.html` where:
   - `<repo-root>` is the directory containing both `docs/` and `skill/`. Walk up from cwd to find it. If unresolvable, fall back to `~/Documents/CC/ai-investment-weekly/` — that is the current deployed location used by the cron and `git push`. Walk-up resolution is preferred and works even if the project has moved.
   - `<YYYY-MM-DD>` is **today's actual date** (system date, not training data).
3. Update `<repo-root>/docs/index.html`: find the `<!-- ARCHIVE-START -->` / `<!-- ARCHIVE-END -->` markers and insert a new `<li>` at the top of the list.
4. Never silently overwrite an existing report for the same date — append a `-v2` suffix to the directory name.

The HTML site lives under `docs/` because GitHub Pages deploys from there. Skill files / references / template stay outside `docs/`.

### When uncertain

If the user's intent could go either way, prefer terminal mode and ask: "要直接终端输出 markdown 还是写到 docs/ 上线网站？"

## Hard rules

1. **No fabricated data.** Every key fact (number, date, market share, capex, order, price, lead time) must cite a source. If you cannot verify, write "no reliable source found" or "needs further verification" — do not guess.
2. **Web search is mandatory.** Do not rely on training-data memory for current numbers. Use WebSearch / WebFetch for recent earnings, prices, capex guidance, supply-chain signals.
3. **Mark speculation explicitly.** Use "推测" or "情景分析" when the conclusion is reasoned but unverified.
4. **No concept-stock lists.** Do not equate "AI-related" with "tradeable". If there is no clear trade, say "没有明确交易机会" and explain what data is missing.
5. **Sources block at the bottom is mandatory** — markdown-style links converted to anchor tags inside the HTML.

## Research workflow (do this in order, every time)

### Step 1 — Capture today's date
Use the system date. Convert it to ISO `YYYY-MM-DD`. The output directory and report header both use this date.

### Step 2 — Scan for new capability (last 30 / 90 / 180 days)
Search across these themes (skip themes with no recent signal, add new themes as they emerge):

| Theme | What to look for |
|---|---|
| Training compute | NVIDIA / AMD / hyperscaler ASIC chip cycle, capex guidance |
| Inference compute | inference ASICs, edge NPUs, token economics |
| Memory | HBM / DRAM / NAND contract pricing, sold-out signals |
| Networking | 800G / 1.6T optics, CPO, switch ASICs |
| Data center power | gas turbines, transformers, on-site generation, nuclear |
| Cooling | direct-to-chip, immersion, rack-density transitions |
| Robotics / embodied | humanoid roadmaps, supply-chain orders, actuators |
| Edge devices | AI glasses, AI PC, AI phone unit shipments |
| AI agents / software | enterprise ARR, ACV, agent token consumption |
| AI medicine | clinical milestones, AI-designed molecule pipeline |
| Auto / robotaxi | unit economics, miles, regulatory approvals |
| AI security / data | spending shifts, tooling adoption |

### Step 3 — Identify the new bottleneck
For each capability surge: what does it consume? (compute, memory, storage, network, power, cooling, sensors, actuators, data, lab capacity, manufacturing capacity, certification capacity)

### Step 4 — Identify who pays
Real buyer (cloud / enterprise / consumer / pharma / auto / robot OEM / government / industrial). Distinguish real buyers from concept beneficiaries.

### Step 5 — Find supply / demand evidence
Orders, prices, lead times, inventory, capacity utilization, capex revisions, management commentary. Hard data only.

### Step 6 — Find the profit pool
Which link in the chain has pricing power, certification moat, scale advantage, customer lock-in?

### Step 7 — Test for market mispricing
Required checks:
- Stock 1M / 3M / 6M / 12M performance
- Valuation vs. historical and peer
- Analyst EPS / revenue / GM revisions
- Management guidance gap
- IV, short interest, institutional positioning, news heat

### Step 8 — Pick the trade expression
- Long stock / short stock / pair / call / call spread / ETF / cross-market handoff (US capex → TW/JP/KR/CN supply chain) / watchlist only.

## Scoring rubric (0–100)

| Dimension | Max | What earns points |
|---|---|---|
| Demand inflection strength | 20 | Real new spend, durable, changes procurement budget |
| Hard-evidence strength | 15 | Orders, prices, lead times, capex, guidance — not narrative |
| Profit-pool quality | 15 | Pricing power, GM expansion, scarce capacity, moat |
| Mispricing | 20 | Stock / valuation / EPS revisions / positioning still lagging |
| Catalyst clarity | 10 | Specific events in next 1–12 months |
| Tradability | 10 | Liquidity, options availability, shortability |
| Risk control | 10 | Clear invalidation conditions and hedges |

- **80+** = high-conviction trade candidate
- **65–79** = watchlist or small probe
- **50–64** = thesis exists, evidence thin
- **<50** = no clear trade

## Report structure (same for both modes)

The report — whether terminal markdown or HTML — has these sections in this order:

1. **Header** — date, issue number (in HTML mode: count subdirs in `docs/reports/`), researcher framing
2. **TL;DR** — top 3 turning points, top crowded narrative to avoid, single biggest risk, what needs more data
3. **Top picks table** — ranked trades with score
4. **Radar table** — broader scan with all themes
5. **Deep dives** — Top 3–5 trades with: thesis, security, why-now, evidence, mispricing evidence, catalysts, upside scenarios, downside, invalidation, sizing, hedges
6. **Shorts / impaired assets** — table
7. **Pairs / cross-market** — table
8. **Watchlist** — table
9. **Data gaps** — list of what's missing or needs follow-up
10. **Sources** — categorized, every key fact linked

In **terminal mode**, render with markdown headings and pipe tables; print directly to chat. No files.

In **HTML publish mode**, use `skill/assets/template.html` — find the `<!-- FILL: ... -->` placeholders and replace each. The template has CSS linked via `../../assets/styles.css` (relative to the report's location under `docs/reports/<DATE>/`).

## Resources in this skill

- `assets/template.html` — the HTML template (open it, find FILL markers, fill in)
- `references/methodology.md` — long-form version of the research framework, scoring details, prior-week patterns. Read this when you need more detail than SKILL.md provides.

## Common failure modes to avoid

- Writing a "narrative" report instead of a data-driven one. If a section has no hard numbers, the section's score is wrong.
- Listing >10 ideas. Discipline matters more than coverage. Top 5 deep-dives is the cap.
- Defaulting to HTML when the user just wants a quick conversational read. Default is terminal markdown.
- In HTML publish mode: forgetting to update the homepage archive list after writing the report.
- Using last week's numbers because search felt slow. The data must be fresh.
- Skipping the sources block. Every fact, every link.
