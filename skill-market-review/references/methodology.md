# Methodology — Weekly Market Review

Companion to SKILL.md. Read this when you need more depth on cycle diagnostics, scoring details, or how to compare current state with the dot-com analog.

## Why dot-com is the right analog

The 1996–2003 cycle is the only fully-concluded mega-bubble in tech where buyside (not retail) capex front-loaded the build-out. Today's AI cycle shares:

- Hyperscaler / industry capex >> hyperscaler revenue (the same supply-runs-ahead-of-demand setup)
- Vendor financing creeping in (CoreWeave debt, NVIDIA equity stakes in customers, Oracle's OCI lease structure)
- Story stocks trading on revenue multiples while burning FCF
- Concentration: 1999 = top-10 = 25% of S&P; 2025–2026 Mag 7 + AI majors = ~30%

Other analogs (1973 Nifty Fifty, 1989 Japan, 2007 housing, 2021 SPAC) help on specific dimensions but the **buyside capex cycle** is the closest match.

## The seven stages — diagnostic checklist

For each, what you should see in the data RIGHT NOW if we're in that stage:

### Stage 1 · 1996–1998 早期扩散 (early diffusion)
- New tech adoption is real but small share of GDP / capex
- Story stocks exist but valuations are merely high, not extreme
- Credit spreads tight, no signs of stress
- Hyperscaler capex growing 20–40% YoY, manageable
- Retail not yet euphoric

### Stage 2 · 1999 叙事和估值同步加速 (narrative + valuation co-acceleration)
- Capex YoY growth >50%, frequently revised UP mid-year
- Multiple expansion accelerates beyond earnings growth
- IPO window wide open, even unprofitable names
- Vendor financing visible on balance sheets
- Mag-7 / leaders contribution to index >70%
- Retail starts piling in (call buying, leveraged ETF flows)
- Public starts hearing story from non-finance friends

### Stage 3 · 2000Q1 顶部附近 (near-top)
- Insider selling accelerates
- Lockup expirations heavy
- Mega IPO supply visible (the 1999–2000 IPO wave dwarfed earnings); in modern: SpaceX, OpenAI, Anthropic IPO calendar
- Breadth deteriorates — fewer stocks make new highs even as index does
- Volatility curves invert (front-month VIX > deferred)
- Specific sector leaders break trend even as broad index pushes higher
- High-yield spreads stop tightening (or start widening) while equities still rally

### Stage 4 · 2000H2 订单和资本开支恶化 (orders & capex deterioration)
- Specific signals: GPU lead times shorten; HBM allocation slack appears; rental prices fall
- Hyperscaler capex guidance cut for first time in cycle (rare event — flag it loudly)
- Inventory days rising at NVIDIA / TSMC / suppliers
- AR days rising — customers paying slower
- Cloud GM beginning to decline despite revenue still growing
- Multiples compress 10–25% but earnings haven't broken yet
- Credit starts to widen meaningfully

### Stage 5 · 2001–2002 信用风险暴露 (credit risk surfaces)
- High-yield default rate rising
- AI-vendor debt credit spreads blowing out (CoreWeave, neoclouds first)
- Stranded capacity / impairments at hyperscalers
- Leveraged buyers of GPUs forced to liquidate
- Equity 30–50% drawdown from peak

### Stage 6 · 2003 后幸存者阶段 (post-crash survivor regime)
- Bottom-fishing in genuine cash-flow generators
- Capex collapsed to maintenance
- Survivor-cohort earnings beat low expectations
- 5–10 year basing pattern in indices

### Stage 7 (added) · 信用压力阶段 distinct from 5
Some weeks will have credit-spread widening without equity break — this is the early-warning regime. Score it separately.

## Scoring rubric — 11 dimensions × 0–5 each (max 55)

For each dimension below, a 0 score means "no concern, looks like 1996–1997"; 5 means "looks like 1999Q4 / 2000Q1 / 2000Q2 depending on dimension".

### 估值泡沫 (valuation)
- 0: market-cap-weighted forward P/E < 18x
- 3: 22–25x
- 5: >28x AND PEG > 2.0 broadly

Reference points: SPX fwd P/E peaked ~25x in March 2000.

### 资本开支过热 (capex overheat)
- 0: hyperscaler combined capex YoY < +20%
- 3: +40–60%
- 5: >+70% AND second consecutive year of upward guidance revisions

### 融资脆弱性 (funding fragility)
- 0: no vendor financing, no AI-debt issuance
- 3: visible vendor financing in 10-K disclosures, 1–2 large AI-debt issuances per quarter
- 5: AI-debt issuance >$50B/year + insider/secondary supply absorbed by retail

### 真实需求兑现 (demand realization)
Inverse: high score = demand NOT keeping up.
- 0: inference token revenue grows in line with capex
- 3: token revenue lags capex by 30–50%
- 5: token revenue / API revenue actually declining or flat while capex still climbing

### 供给过剩风险 (supply glut risk)
- 0: GPU lead times still long, HBM sold out, rental prices firm
- 3: lead times normalizing, rental prices flat
- 5: rental prices falling >20% in a quarter, hyperscalers reselling capacity

### 龙头盈利质量 (leader earnings quality)
Inverse logic.
- 0: NVDA / MSFT / GOOGL beats on GAAP earnings + clean cash conversion
- 3: beats accompanied by AR/inventory growing > revenue
- 5: misses + write-downs + non-GAAP-only beats

### 二三线公司脆弱性 (tier-2/3 fragility)
- 0: small-cap AI names trading on revenue, not stress
- 3: small-cap AI sector down 20% from highs
- 5: small-cap AI sector down 40%+ AND specific failures (CoreWeave-tier credit issues)

### 信用市场压力 (credit pressure)
- 0: HY OAS < 350 bps, tightening
- 3: 350–500 bps, flat
- 5: >550 bps, widening for 4+ consecutive weeks

### 市场宽度恶化 (breadth deterioration)
- 0: A/D line at new highs, 52w highs > 52w lows by wide margin
- 3: A/D diverging from index for 4+ weeks
- 5: A/D rolling over while index near highs (1999H2 setup)

### 监管和地缘风险 (regulatory / geopolitical)
- 0: status quo
- 3: meaningful new chip export controls / antitrust action announced
- 5: actual export halt or major-vendor antitrust enforcement

### Mega IPO 和私募抽水压力 (IPO + private supply absorption)
- 0: no large filings in pipeline
- 3: SpaceX / OpenAI / Anthropic public filings expected within 6 months
- 5: actual filings priced and trading + lockup expirations visible

## Score interpretation

- **0–15**: 1996–1997 早期。继续做多核心仓，仅观察。
- **16–25**: 1998 中期扩散。可加仓但开始建对冲底仓。
- **26–35**: 1999 加速期。仍可做多但严格执行 trailing stop，对冲比例 30–50%。
- **36–44**: 2000Q1 顶部区。减仓主升龙头，买长期 put，做空二三线。
- **45–55**: 2000H2–2001 破裂期。最高对冲，全仓 put / 直接做空 / 现金。

## Comparing weeks

The score's **direction of change** matters as much as the level. A move from 32 → 36 in a week is a regime signal even if 36 is not yet "top". Track week-over-week.

## Trade-action grammar (every recommendation)

For every action in section 6:

```
动作: [add / trim / hold / take_profit / stop / hedge / put / short / wait]
标的: [ticker or instrument]
原因: [一句话, 引用 section 3 或 4 的具体数据]
触发条件: [价格水平 / 数据发布 / 信用利差阈值 / 时间]
止损/失效条件: [反向价格水平 / 反向数据]
时间周期: [天 / 周 / 月]
```

If any of the six fields is missing, the action is incomplete — don't write it.

## Anti-patterns

- **"等待右侧确认"** without specifying what right-side confirmation looks like in numbers
- **"分批加仓"** without specifying the price grid
- **"控制仓位"** without specifying the cap
- **"保持谨慎"** — meaningless without action
- Recommending 5+ short positions in a 36-score week (score isn't high enough yet)
- Recommending 5+ long positions in a 45-score week (score is too high)
- Mixing scenarios (don't write "both add and trim NVDA" without a clear conditional)

## When in doubt

If the data is genuinely ambiguous, write "无法判断 / 数据不足" for that section. The user trusts an honest "I don't know" more than a fake answer.
