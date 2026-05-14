# Methodology — Daily Briefing

Pre-market checklist. Keep it short.

## Time conventions

- "昨夜美股" = last completed US session (regular hours close)
- 北京时间 07:00 Monday → check Friday's US close + weekend events
- 北京时间 07:00 Tue–Fri → check previous US session close
- All prices labeled with ET timestamp; convert to Beijing time only when relevant

## US holiday calendar (skip price recap)

Annually:
- New Year's Day (Jan 1, or observed)
- MLK Day (3rd Mon Jan)
- Presidents Day (3rd Mon Feb)
- Good Friday (varies)
- Memorial Day (last Mon May)
- Juneteenth (Jun 19)
- Independence Day (Jul 4)
- Labor Day (1st Mon Sep)
- Thanksgiving (4th Thu Nov)
- Christmas (Dec 25)

Half days (early close 1pm ET): Day after Thanksgiving, Christmas Eve, sometimes July 3.

When checking, also note half-days because the close print is at 1pm ET not 4pm ET.

## Where to search

### Index closes
- Bloomberg / Reuters / WSJ market wrap
- TradingView / Yahoo Finance for prices

### Pre-market
- CNBC pre-market movers
- Investing.com pre-market data

### Earnings calendar
- earningswhispers.com
- nasdaq.com earnings calendar
- yahoo finance calendar

### Macro data calendar
- forexfactory.com economic calendar (filter to USD high impact)
- US BLS / BEA release schedule

### AI-specific
- The Information AI section
- Stratechery (analysis, not price)
- SemiAnalysis
- Specific company IR pages

## What to skip

- Asia overnight in detail (only mention if **directly relevant** to your US positions — e.g. TSM, Samsung, ASML)
- European session (only mention if VS-related, e.g. ASML earnings)
- Crypto (unless > $50B move that suggests risk-off pressure on tech)
- Single-name analyst upgrades (noise)
- "what could happen next year" (this is daily)

## Pre-market gap heuristic

If a position name gaps > 3% pre-market, surface it. If < 3%, generally ignore.

Stop-distance flag: if current price within 5% of stop or current pre-market gap suggests the stop will trigger at open, flag prominently. The user needs to act before 09:30 ET.

## Reference: linkage to weekend review

Read the most recent `docs/reviews/<date>/index.html` (or remember from cache) for:
- Current "市场状态" (上涨 / 顶部震荡 / etc.)
- Current bubble score
- This week's 3 scenarios + trigger conditions

Daily briefing's job in section 6 is to **anchor** today's behavior against that thesis, not re-derive it. If yesterday's session triggered a scenario condition (e.g. NDX broke 50DMA), call it out — that may be a trigger from the weekend plan.

## Length discipline

- Section 1: max 1 table + 1 sentence
- Section 2: max 1 row per position, no commentary except flag tags
- Section 3: bullet list, max 8 items
- Section 4: 3-4 sentences, single most important point
- Section 5: only if real signal, max 3 items
- Section 6: 1 line

Total target: under 600 words. If pushing 800, cut.

## Anti-patterns

- Re-deriving market state every day (that's weekend's job)
- Adding new positions / new trade ideas (also weekend's job)
- "Wait and see" or "monitor closely" without specifying what to see
- Coverage of all 25 tickers in the watchlist (only flag if there's actual news/move)
- Bigger size = better. Smaller is better.
