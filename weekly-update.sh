#!/bin/bash
# weekly-update.sh
# 每周跑一次：调 Claude Code skill 出新一期报告 → push 到 GitHub
# 仿照 daily-news-mac 的部署模式：用本地 Claude Code Pro 订阅生成内容，
# git push 后由 GitHub Pages 自动发布。

set -e

# ============================================
# 配置区（按需改）
# ============================================
PROJECT_DIR="$HOME/ai-investment-weekly"   # 项目放在哪
CLAUDE_CMD="claude"                         # Claude Code 命令名
GIT_BRANCH="main"                           # push 到哪个分支

# ============================================
# 不需要改
# ============================================
LOG_DIR="$PROJECT_DIR/logs"
TODAY=$(date +%Y-%m-%d)
LOG_FILE="$LOG_DIR/$TODAY.log"

mkdir -p "$LOG_DIR"

# 同时输出到日志和终端
exec > >(tee -a "$LOG_FILE") 2>&1

echo "================================================"
echo "📊 AI Investment Weekly · $(date '+%Y-%m-%d %H:%M:%S')"
echo "================================================"

cd "$PROJECT_DIR"

# 加载 PATH（launchd 启动时 PATH 极简，需要补全 claude / git）
source "$HOME/.zshrc" 2>/dev/null || true
source "$HOME/.bash_profile" 2>/dev/null || true
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

# 检查依赖
echo ""
echo "📋 检查依赖..."
if ! command -v "$CLAUDE_CMD" &> /dev/null; then
    echo "❌ 找不到 claude 命令"
    echo "   npm install -g @anthropic-ai/claude-code && claude login"
    exit 1
fi
if ! command -v git &> /dev/null; then
    echo "❌ 找不到 git"
    exit 1
fi
echo "✅ claude: $(which $CLAUDE_CMD)"
echo "✅ git:    $(which git)"

# Step 1: 调 Claude Code 调研 + 生成 HTML
echo ""
echo "🤖 Step 1/2: 调用 Claude Code skill 出本周调研..."
echo "（用你的 Claude Pro 订阅，不消耗 API 额度）"

# --print 模式：非交互、单次执行、stdout 输出最终消息
# skill 会读 skill/SKILL.md，按方法论联网搜索，写到 docs/reports/<TODAY>/index.html
"$CLAUDE_CMD" --print --permission-mode acceptEdits "请按当前项目根目录下 skill/SKILL.md 的指引，出本周（$TODAY）的 AI 投资调研报告。要求：
1. 联网搜索最新数据（capex、内存合约价、燃机 backlog、订单、估值、机构持仓等），不允许只用训练数据。
2. 输出到 docs/reports/$TODAY/index.html，使用 skill/assets/template.html 作为模板。
3. 同时更新 docs/index.html 的归档列表（在 <!-- ARCHIVE-START --> 和 <!-- ARCHIVE-END --> 之间，最新一期插在最上面）。
4. 所有关键事实必须有来源链接。
5. 完成后简短报告写到了哪个文件。"

# Step 2: 提交并推送
echo ""
echo "📤 Step 2/2: 推送到 GitHub..."
if [[ -n $(git status --porcelain docs/) ]]; then
    git add docs/
    git commit -m "📊 Weekly report: $TODAY"
    git push origin "$GIT_BRANCH"
    echo "✅ 推送成功，GitHub Pages 将在 1-2 分钟后更新"
else
    echo "ℹ️ docs/ 没有变化，跳过提交（skill 可能没生成新文件，检查日志）"
fi

echo ""
echo "🎉 完成！日志保存在 $LOG_FILE"

# macOS 通知
osascript -e "display notification \"第 $(ls -1 docs/reports 2>/dev/null | wc -l | tr -d ' ') 期已更新\" with title \"📊 AI Investment Weekly\" sound name \"Glass\"" 2>/dev/null || true
