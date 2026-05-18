#!/bin/bash
# install-launchd.sh
# 安装/卸载/测试 macOS 定时任务。支持三个任务：
#   daily    = 工作日 07:00 出盘前简报（skill: daily-briefing）
#   weekly   = 周一 09:00 出 AI 产业链转折点周报（skill: ai-turning-points）
#   weekend  = 周六 10:00 出市场周度复盘（skill: weekly-market-review）
#   all      = 同时操作三个（默认）
#
# 用法：
#   bash install-launchd.sh [install|test|status|remove] [daily|weekly|weekend|all]
#
# 示例：
#   bash install-launchd.sh                    # = install all
#   bash install-launchd.sh install daily      # 只装盘前简报
#   bash install-launchd.sh test weekend       # 立即跑一次周末复盘
#   bash install-launchd.sh status             # 查看三个任务状态
#   bash install-launchd.sh remove weekly      # 只卸载周一任务

set -e

USERNAME=$(whoami)
# PROJECT_DIR 自动从脚本位置推断 — 项目无论放哪都能跑
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# task -> (plist file basename, label inside plist, script name, desc)
# 注意：PLIST_NAME 是文件名（用于 plist 文件路径）
# LABEL 是 plist 内部的 Label key（launchctl bootstrap/bootout 用）
# 两者可能不同 — 当 launchd 把某个 label 缓存为 fail state 时，
# 我们换 label（如 com.user.ai-weekly-v2）绕过缓存，但 plist 文件名可以保留
declare_task() {
    case "$1" in
        daily)
            PLIST_NAME="com.user.ai-daily-briefing"
            LABEL="com.user.ai-daily-briefing-v2"
            SCRIPT="daily-briefing.sh"
            DESC="工作日 07:00 · 盘前简报"
            ;;
        weekly)
            PLIST_NAME="com.user.ai-weekly"
            LABEL="com.user.ai-weekly-v2"
            SCRIPT="weekly-update.sh"
            DESC="周一 09:00 · AI 产业链转折点周报"
            ;;
        weekend)
            PLIST_NAME="com.user.ai-weekend-review"
            LABEL="com.user.ai-weekend-review"
            SCRIPT="weekend-review.sh"
            DESC="周六 10:00 · 市场周度复盘"
            ;;
        *)
            echo "❌ 未知任务名: $1（应为 daily / weekly / weekend）" >&2
            exit 1
            ;;
    esac
    PLIST_SOURCE="$PROJECT_DIR/launchd/$PLIST_NAME.plist"
    PLIST_DEST="$HOME/Library/LaunchAgents/$PLIST_NAME.plist"
    SCRIPT_PATH="$PROJECT_DIR/$SCRIPT"
}

install_one() {
    declare_task "$1"
    echo ""
    echo "📦 安装：$DESC"

    if [ ! -f "$PLIST_SOURCE" ]; then echo "❌ 找不到模板 $PLIST_SOURCE"; exit 1; fi
    if [ ! -f "$SCRIPT_PATH" ]; then echo "❌ 找不到脚本 $SCRIPT_PATH"; exit 1; fi

    mkdir -p "$HOME/Library/LaunchAgents"
    sed -e "s|__PROJECT_DIR__|$PROJECT_DIR|g" \
        -e "s|__HOME__|$HOME|g" \
        "$PLIST_SOURCE" > "$PLIST_DEST"
    chmod +x "$SCRIPT_PATH"

    # 用 bootout/bootstrap（不用旧的 unload/load）— 在 macOS 13+ 上前者会进入 daemon context
    # 导致 TCC 检查 daemon entitlement，给 user binary 加 FDA 也不生效
    launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
    launchctl bootstrap "gui/$(id -u)" "$PLIST_DEST"
    echo "✅ 已加载：$PLIST_DEST"
}

remove_one() {
    declare_task "$1"
    echo ""
    echo "🗑 卸载：$DESC"
    if [ -f "$PLIST_DEST" ]; then
        launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null && echo "✅ 已卸载" || echo "ℹ️ 任务未在运行"
        rm -f "$PLIST_DEST"
    else
        echo "ℹ️ 没有这个任务的 plist"
    fi
}

test_one() {
    declare_task "$1"
    echo ""
    echo "🧪 立即跑一次：$DESC"
    cd "$PROJECT_DIR"
    bash "$SCRIPT"
}

status_one() {
    declare_task "$1"
    echo ""
    echo "── $DESC ──"
    if launchctl list | grep -q "$LABEL"; then
        launchctl list | grep "$LABEL"
        echo "✅ 已加载"
    else
        echo "❌ 未加载（运行 'bash install-launchd.sh install $1' 安装）"
    fi
}

ACTION="${1:-install}"
TARGET="${2:-all}"

# 校验 action
case "$ACTION" in install|test|status|remove) ;; *)
    echo "❌ 未知动作: $ACTION"
    echo "用法: bash install-launchd.sh [install|test|status|remove] [weekly|weekend|all]"
    exit 1
    ;;
esac

# 校验 target
case "$TARGET" in
    daily|weekly|weekend) TASKS="$TARGET" ;;
    all) TASKS="daily weekly weekend" ;;
    *) echo "❌ 未知任务: $TARGET（应为 daily / weekly / weekend / all）" >&2; exit 1 ;;
esac

# test 不允许 all
if [ "$ACTION" = "test" ] && [ "$TARGET" = "all" ]; then
    echo "⚠️ test 模式只能跑一个任务，请指定 daily / weekly / weekend"
    exit 1
fi

case "$ACTION" in
    install)
        for t in $TASKS; do install_one "$t"; done
        echo ""
        echo "📋 下一步："
        echo "  · 立即跑一次：  bash install-launchd.sh test daily"
        echo "                  bash install-launchd.sh test weekly"
        echo "                  bash install-launchd.sh test weekend"
        echo "  · 查看状态：    bash install-launchd.sh status"
        echo "  · 看日志：      tail -f $PROJECT_DIR/logs/\$(date +%Y-%m-%d)-briefing.log"
        echo "                  tail -f $PROJECT_DIR/logs/\$(date +%Y-%m-%d).log"
        echo "                  tail -f $PROJECT_DIR/logs/\$(date +%Y-%m-%d)-review.log"
        ;;
    remove)
        for t in $TASKS; do remove_one "$t"; done
        echo ""
        echo "项目文件夹和日志保留：rm -rf $PROJECT_DIR 才会彻底删除"
        ;;
    test)
        test_one "$TASKS"
        ;;
    status)
        for t in $TASKS; do status_one "$t"; done
        echo ""
        echo "最近一次执行日志："
        LATEST_LOG=$(ls -t "$PROJECT_DIR/logs/"*.log 2>/dev/null | head -1)
        if [ -n "$LATEST_LOG" ]; then
            echo "($LATEST_LOG)"
            tail -10 "$LATEST_LOG"
        else
            echo "（还没有日志）"
        fi
        ;;
esac
