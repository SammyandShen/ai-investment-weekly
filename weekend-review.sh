#!/bin/bash
# weekend-review.sh
# 每周六 10:00（中国时间）跑一次：调 Claude Code skill 出本周市场复盘 → push 到 GitHub
# 使用 skill weekly-market-review，读 data/portfolio.json，写到 docs/reviews/<日期>/

set -e

# ============================================
# 配置区
# ============================================
# PROJECT_DIR 自动从脚本位置推断 — 项目无论放哪都能跑
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CLAUDE_CMD="claude"
GIT_BRANCH="main"

# ============================================
# 不需要改
# ============================================
LOG_DIR="$PROJECT_DIR/logs"
TODAY=$(date +%Y-%m-%d)
LOG_FILE="$LOG_DIR/$TODAY-review.log"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "================================================"
echo "📊 Weekend Review · $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "================================================"

cd "$PROJECT_DIR"

# 加载 PATH
source "$HOME/.zshrc" 2>/dev/null || true
source "$HOME/.bash_profile" 2>/dev/null || true
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo ""
echo "📋 检查依赖..."
if ! command -v "$CLAUDE_CMD" &> /dev/null; then
    echo "❌ 找不到 claude 命令"
    exit 1
fi
if ! command -v git &> /dev/null; then
    echo "❌ 找不到 git"
    exit 1
fi
echo "✅ claude: $(which $CLAUDE_CMD)"
echo "✅ git:    $(which git)"

# 检查 portfolio.json 是否存在
if [ ! -f "data/portfolio.json" ]; then
    echo "⚠️ data/portfolio.json 不存在 — skill 会按空持仓跑"
fi

# Step 1: 调 skill 跑复盘
echo ""
echo "🤖 Step 1/2: 调用 skill weekly-market-review 出本周复盘..."
echo "（用 Claude Pro 订阅，不消耗 API 额度，预计 5–15 分钟）"

"$CLAUDE_CMD" --print --permission-mode bypassPermissions "请按当前项目根目录下 skill-market-review/SKILL.md 的指引，执行本周（$TODAY）的市场周度复盘任务。要求：

1. 这是 HTML publish 模式 — 输出到 docs/reviews/$TODAY/index.html，使用 skill-market-review/assets/template.html 作为模板。
2. 必须先读 data/portfolio.json — 用 portfolio[] 填【4. 我的持仓周度处理】，用 watchlist.* 决定扫描范围。
3. 联网搜索本周（过去 7 天）的真实数据：指数 / 波动率 / 利率信用 / 市场宽度 / AI capex / AI 供应链 / AI 需求 / 单位经济 / 融资 IPO / 监管地缘。每个关键数字必须有来源 + 发布日期。
4. 输出 7 段：本周总判断 / 真正重要 5 件事 / 泡沫评分模型 / 持仓周度处理 / 三种情景计划 / 交易行动清单（最多 8 条）/ 转折点清单（最多 10 条）。
5. 每个交易建议都必须有 触发条件 / 失效条件 / 时间周期 三件套。
6. 同时更新 docs/index.html 的复盘归档列表（在 <!-- REVIEW-ARCHIVE-START --> 和 <!-- REVIEW-ARCHIVE-END --> 之间，最新一期插在最上面）。
7. 完成后简短报告写到了哪个文件。"

# Step 2: push
echo ""
echo "📤 Step 2/2: 推送到 GitHub..."
if [[ -n $(git status --porcelain docs/) ]]; then
    git add docs/
    git commit -m "📊 Weekend review: $TODAY"
    git push origin "$GIT_BRANCH"
    echo "✅ 推送成功，GitHub Pages 将在 1-2 分钟后更新"
else
    echo "ℹ️ docs/ 没有变化，跳过提交"
fi

echo ""
echo "🎉 完成！日志：$LOG_FILE"

osascript -e "display notification \"本周复盘已更新\" with title \"📊 Weekend Review\" sound name \"Glass\"" 2>/dev/null || true
