#!/usr/bin/env python3
"""
sync-quotes.py — 同步持仓 ticker 的最新收盘价到 docs/data/quotes.json

读 data/portfolio.json 的 portfolio[]，从 Yahoo Finance chart API（服务端无 CORS）
拉每个 ticker 的最新价和上一交易日收盘价，写到 docs/data/quotes.json。

被 daily-briefing.sh 在每个工作日早 07:00（中国时间）调用。
"""

import json
import sys
import time
import urllib.request
import urllib.error
from pathlib import Path
from datetime import datetime, timezone

REPO_ROOT = Path(__file__).resolve().parent.parent
PORTFOLIO_PATH = REPO_ROOT / "data" / "portfolio.json"
OUT_PATH = REPO_ROOT / "docs" / "data" / "quotes.json"

YAHOO_URL = "https://query1.finance.yahoo.com/v8/finance/chart/{ticker}?interval=1d&range=5d"
USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
TIMEOUT_SEC = 15


def load_tickers() -> list[str]:
    if not PORTFOLIO_PATH.exists():
        print(f"❌ 找不到 {PORTFOLIO_PATH}", file=sys.stderr)
        sys.exit(1)
    data = json.loads(PORTFOLIO_PATH.read_text(encoding="utf-8"))
    seen: set[str] = set()
    tickers: list[str] = []
    for row in data.get("portfolio", []):
        t = (row.get("ticker") or "").strip().upper()
        if t and t not in seen:
            seen.add(t)
            tickers.append(t)
    return tickers


def fetch_one(ticker: str) -> dict:
    req = urllib.request.Request(
        YAHOO_URL.format(ticker=ticker),
        headers={"User-Agent": USER_AGENT, "Accept": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=TIMEOUT_SEC) as resp:
        payload = json.loads(resp.read().decode("utf-8"))
    result = payload.get("chart", {}).get("result") or []
    if not result:
        raise RuntimeError("empty chart.result")
    meta = result[0].get("meta") or {}
    price = meta.get("regularMarketPrice")
    prev_close = meta.get("chartPreviousClose") or meta.get("previousClose")
    if price is None:
        raise RuntimeError("missing regularMarketPrice")
    ts = meta.get("regularMarketTime")
    market_time_iso = (
        datetime.fromtimestamp(ts, tz=timezone.utc).isoformat() if ts else None
    )
    return {
        "price": float(price),
        "prevClose": float(prev_close) if prev_close is not None else None,
        "currency": meta.get("currency") or "USD",
        "exchange": meta.get("exchangeName") or "",
        "marketState": meta.get("marketState") or "",
        "marketTime": market_time_iso,
    }


def main() -> int:
    tickers = load_tickers()
    if not tickers:
        print("⚠️  持仓为空，写一个空 quotes.json")
        result = {}
    else:
        print(f"📡 同步 {len(tickers)} 个 ticker: {', '.join(tickers)}")
        result: dict[str, dict] = {}
        failures: list[tuple[str, str]] = []
        for t in tickers:
            try:
                result[t] = fetch_one(t)
                print(f"  ✅ {t}: {result[t]['price']:.2f} {result[t]['currency']}")
            except (urllib.error.URLError, urllib.error.HTTPError, RuntimeError, ValueError) as e:
                failures.append((t, str(e)))
                print(f"  ❌ {t}: {e}")
            time.sleep(0.2)  # be polite to Yahoo
        if failures:
            print(f"⚠️  {len(failures)} 个失败：{[f[0] for f in failures]}", file=sys.stderr)

    out = {
        "fetchedAt": datetime.now(timezone.utc).isoformat(),
        "source": "yahoo-finance-chart",
        "quotes": result,
    }

    OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUT_PATH.write_text(json.dumps(out, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"💾 写入 {OUT_PATH.relative_to(REPO_ROOT)} ({len(result)}/{len(tickers)} 成功)")
    return 0 if result or not tickers else 1


if __name__ == "__main__":
    sys.exit(main())
