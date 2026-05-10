# Methodology — AI Turning Points Research

Long-form companion to SKILL.md. Read this when you need more depth on framework, source priorities, or the questions every candidate must answer.

## What is a "turning point"?

A turning point is **not** a hot topic. It must satisfy several of:

1. A new AI capability has shifted some category from "optional spend" to "rigid demand".
2. The bottleneck has migrated (training → inference, GPU → HBM, HBM → network, network → power, cloud → edge, digital → physical).
3. Real buyers are paying — orders, capex revisions, prices, lead times, inventory, capacity utilization show measurable change.
4. Beneficiaries' revenue / margin / FCF / valuation logic could change.
5. Market is not yet pricing it — stock, multiples, EPS revisions, analyst notes, IV, positioning, news heat lag the data.
6. There is a tradeable security with sufficient liquidity.

If a thesis fails on (3) or (5), it is a watchlist item, not a trade.

## First-principles questions every candidate must answer

1. What is the essence — what does AI's current stage actually lack?
2. Who pays — cloud / enterprise / consumer / pharma / auto / robot OEM / government / industrial?
3. Where does the money come from — new capex / IT budget reallocation / ad budget / R&D / cost savings (labor, energy, logistics) / capital markets?
4. Direct beneficiaries — whose revenue expands?
5. Indirect beneficiaries — upstream materials / equipment / components / software / services?
6. Who loses — old tech, displaced suppliers, low-efficiency incumbents?
7. Where does profit pool — which link has pricing power vs. pass-through?
8. Moat — capacity / IP / certification / ecosystem / data / cost / scale / channel / regulatory / supply-chain lock-in?
9. Substitution risk — large-customer in-house, open-source, low-cost competitors, alternative tech path?
10. Growth driver — units, ASP, share, margin, multiple re-rating?
11. Risks — supply over-build, price decline, demand falsification, regulation, tech path switch, customer concentration, capex slowdown, already over-priced?

## Source priority list

Use these in roughly this order of authority:

### Tier 1: company / regulatory filings
- 10-K, 10-Q, 8-K, S-1, prospectuses
- Earnings call transcripts (verbatim)
- Investor day materials
- Exchange filings (SEC, HKEX, KRX, TWSE, TSE, SSE/SZSE)

### Tier 2: industry data houses
- IDC, Gartner, TrendForce, Omdia, Counterpoint
- SEMI, SIA, Yole, Dell'Oro, LightCounting, DRAMeXchange, IC Insights, WSTS
- IEA, EIA, regional grid / utility data, FERC

### Tier 3: financial / industry press
- Reuters, Bloomberg, Financial Times, WSJ, Nikkei, CNBC, The Information, TechCrunch, Digitimes, EE Times, SemiAnalysis

### Tier 4: market data
- Stock price, volume, options IV, short interest, institutional ownership
- Analyst EPS / revenue / GM / capex estimate revisions

### Tier 5: supply-chain signals
- Order books, backlogs, lead times, prices, inventory, capacity expansion, equipment purchases, hiring, customer qualifications, new-product launch dates

If the only source is a Reddit post, an unsigned blog, or an aggregator with no original reporting, do NOT cite it as evidence.

## Theme scan checklist (with current-cycle examples)

### Training compute
- NVIDIA: next-gen architecture timing (e.g. Blackwell Ultra → Rubin), shipments, mix
- AMD: MI series traction at hyperscalers
- Hyperscaler ASICs: Google TPU, AWS Trainium, Meta MTIA, Microsoft Maia
- Advanced node: TSMC capacity at 3nm / 2nm
- Advanced packaging: CoWoS-L, panel-level

### Inference compute
- Token cost per million (input vs output)
- Inference vs training capex split
- Edge NPU shipments

### Memory
- HBM (3, 3E, 4, 4E) capacity allocation by supplier
- DRAM and NAND contract price by quarter (TrendForce)
- Wafer-level pricing
- Long-term agreements (LTAs)
- Lead times

### Networking
- 800G / 1.6T optical module shipments
- EML laser supply
- CPO adoption timing — NVIDIA Quantum-X, Spectrum-X, Broadcom Bailly
- Switch ASIC progression

### Data center power
- Gas turbine backlog (GE Vernova, Siemens Energy, Mitsubishi Heavy)
- Reciprocating engines (Caterpillar, Cummins, Wartsila)
- Power transformer lead times (LPT, GSU)
- Nuclear / SMR PPAs (Constellation, Vistra, Talen, Oklo, X-energy)
- Uranium spot price (Cameco)

### Cooling
- Direct-to-chip vs immersion adoption
- Rack density transition (>30 kW)
- Vertiv backlog growth

### Robotics / embodied
- Humanoid roadmap timing (Tesla Optimus, Figure, Unitree, Apptronik)
- Actuator / harmonic drive / servo motor orders (Sanhua, Tuopu, Green Harmonic, Harmonic Drive Systems)
- Tactile / force sensor capacity

### Edge devices
- AI glasses unit shipments (Meta Ray-Ban, Apple)
- AI PC / phone share of total
- On-device LLM penetration

### AI agents / software
- Enterprise ACV growth (Palantir, ServiceNow, Salesforce)
- Token consumption per workflow
- Agent-vs-seat pricing transitions

### AI medicine
- Clinical milestone read-outs (Schrödinger, Recursion, Tempus)
- AI-designed molecule pipeline expansion

### Auto / robotaxi
- Waymo miles / unit economics
- Tesla FSD / robotaxi commercial milestones
- Mobileye design wins

## Scoring details

For each candidate trade:

```
Demand inflection (0–20):
  - Is the new spend genuinely incremental (not a rebrand of existing)? +10 max
  - Is it durable (multi-quarter, multi-year)? +5 max
  - Does it change procurement budget categories? +5 max

Hard evidence (0–15):
  - Orders, contracts, capex revisions: +5 max
  - Prices, lead times, inventory: +5 max
  - Management guidance shift: +5 max

Profit pool quality (0–15):
  - Pricing power evidence: +5 max
  - GM expansion or scarce capacity: +5 max
  - Moat depth (certification, IP, scale): +5 max

Mispricing (0–20):
  - Stock has not fully run: +5 max
  - Multiple is reasonable vs history / peers: +5 max
  - Analyst estimates still lagging: +5 max
  - Positioning not crowded: +5 max

Catalyst clarity (0–10):
  - Specific datable events in the next 1–12 months: 0–10

Tradability (0–10):
  - Liquidity, options chains, shortability: 0–10

Risk control (0–10):
  - Clear invalidation, hedge availability: 0–10
```

Always show the score components if pressed; the headline number alone is opaque.

## Trade expression menu

For each high-scoring idea, propose at least one of:

- Long stock outright
- Short displaced asset
- Pair (long winner / short loser in same theme)
- Call options or call spreads (when IV is reasonable and catalyst is dated)
- Thematic ETF or basket
- Cross-market handoff (US capex → TW/JP/KR/CN supply chain mid-tier names)
- Watchlist-only with explicit trigger

For each, state: **left-side (anticipating)** vs **right-side (confirming)**, and which sizing band fits — observation / probe / confirmation.

## Common failure modes

- **Concept-chasing**: a stock pops on news; we declare a turning point. Wait for hard evidence in step 5.
- **Single-source citation**: one tweet ≠ proof. Triangulate.
- **Stale numbers**: training data is months / years behind. Always re-search.
- **Vague catalysts**: "future earnings" is not a catalyst. "May 28 NVDA Q1 FY27 print" is.
- **Forgetting the loser**: if X benefits, who is displaced? That short / pair sharpens the thesis.
- **No invalidation**: if you cannot say what would prove you wrong, you do not have a thesis.
- **Pretending precision**: "+47% upside in 6 months" is fake. Use scenario ranges and label them as scenarios.

## Quality bar before publishing

- [ ] Today's date is in the report header
- [ ] Every number has a source link
- [ ] Top 3 turning points each have hard evidence
- [ ] At least one short / pair / displaced-asset call
- [ ] At least one cross-market trade idea
- [ ] Data gaps section honestly lists what is unknown
- [ ] No section is pure narrative
- [ ] HTML file passes a quick "view in browser" check (no broken markup)
