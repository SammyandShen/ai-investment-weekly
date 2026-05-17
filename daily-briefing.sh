#!/bin/bash
# daily-briefing.sh
# 每个工作日早 07:00（中国时间）跑一次：调 Claude Code skill daily-briefing
# 输出昨夜美股 + 今日 catalysts → docs/briefings/<日期>/

set -e

# PROJECT_DIR 自动从脚本位置推断 — 项目无论放哪都能跑
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CLAUDE_CMD="claude"
GIT_BRANCH="main"

LOG_DIR="$PROJECT_DIR/logs"
TODAY=$(date +%Y-%m-%d)
LOG_FILE="$LOG_DIR/$TODAY-briefing.log"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "================================================"
echo "🌅 Daily Briefing · $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "================================================"

# 周末跳过（launchd 已经只配工作日，但脚本里再保险一道）
DOW=$(date +%u)   # 1=Mon, 7=Sun
if [ "$DOW" -ge 6 ]; then
    echo "今天是周末（DOW=$DOW），不出简报。"
    exit 0
fi

cd "$PROJECT_DIR"
source "$HOME/.zshrc" 2>/dev/null || true
source "$HOME/.bash_profile" 2>/dev/null || true
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

if ! command -v "$CLAUDE_CMD" &> /dev/null; then
    echo "❌ 找不到 claude"; exit 1
fi
if ! command -v git &> /dev/null; then
    echo "❌ 找不到 git"; exit 1
fi
echo "✅ claude / git OK"

echo ""
echo "🤖 调用 skill daily-briefing..."
"$CLAUDE_CMD" --print --permission-mode acceptEdits "请按当前项目根目录下 skill-daily-briefing/SKILL.md 的指引，出今天（$TODAY）的盘前简报。要求：

1. 这是 HTML publish 模式 — 输出到 docs/briefings/$TODAY/index.html，使用 skill-daily-briefing/assets/template.html 作为模板。
2. 必须先读 data/portfolio.json 的 portfolio[] — 用来填【2. 持仓 gap 状态】。如果持仓为空，按模板里的说明渲染。
3. 必须先确认今天不是美股休市日（US market holiday）。如果昨夜美股因假日休市，明确说明并跳过价格摘要。
4. 联网搜索昨夜美股收盘数据（SPX/NDX/SOX/IWM/VIX 收盘+当日%）、Mag 7 关键单股、今日 ET 时间的财报和宏观数据。每个数字要有 timestamp。
5. 内容控制在 600 字以内 — 这是盘前简报，不是周度复盘。不要写新的交易建议（那是周度复盘的活）。
6. 第 6 段引用最近一份 docs/reviews/ 下的周度复盘里的"市场状态"（如有）作为今日立场不变量。
7. 同时更新 docs/index.html 的盘前简报归档列表（<!-- BRIEFING-ARCHIVE-START --> 和 <!-- BRIEFING-ARCHIVE-END --> 之间，最新一期插在最上面）。
8. 完成后简短报告写到了哪个文件。"

echo ""
echo "📤 推送到 GitHub..."
if [[ -n $(git status --porcelain docs/) ]]; then
    git add docs/
    git commit -m "🌅 Daily briefing: $TODAY"
    git push origin "$GIT_BRANCH"
    echo "✅ 推送成功"
else
    echo "ℹ️ docs/ 没有变化，跳过提交"
fi

echo ""
echo "🎉 完成！日志：$LOG_FILE"

osascript -e "display notification \"今日盘前简报已就绪\" with title \"🌅 Daily Briefing\" sound name \"Glass\"" 2>/dev/null || true
