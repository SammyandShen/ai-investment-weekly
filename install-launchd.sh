#!/bin/bash
# install-launchd.sh
# 安装/卸载/测试 macOS 定时任务。支持两个任务：
#   weekly   = 周一 09:00 出 AI 产业链转折点周报（skill: ai-turning-points）
#   weekend  = 周六 10:00 出市场周度复盘（skill: weekly-market-review）
#   all      = 同时操作两个（默认）
#
# 用法：
#   bash install-launchd.sh [install|test|status|remove] [weekly|weekend|all]
#
# 示例：
#   bash install-launchd.sh                    # = install all
#   bash install-launchd.sh install weekend    # 只装周末复盘
#   bash install-launchd.sh test weekend       # 立即跑一次周末复盘
#   bash install-launchd.sh status             # 查看两个任务状态
#   bash install-launchd.sh remove weekly      # 只卸载周一任务

set -e

USERNAME=$(whoami)
PROJECT_DIR="$HOME/ai-investment-weekly"

# task -> (plist name, script name, desc)
declare_task() {
    case "$1" in
        weekly)
            PLIST_NAME="com.user.ai-weekly"
            SCRIPT="weekly-update.sh"
            DESC="周一 09:00 · AI 产业链转折点周报"
            ;;
        weekend)
            PLIST_NAME="com.user.ai-weekend-review"
            SCRIPT="weekend-review.sh"
            DESC="周六 10:00 · 市场周度复盘"
            ;;
        *)
            echo "❌ 未知任务名: $1（应为 weekly / weekend）" >&2
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
    sed "s|USERNAME|$USERNAME|g" "$PLIST_SOURCE" > "$PLIST_DEST"
    chmod +x "$SCRIPT_PATH"

    launchctl unload "$PLIST_DEST" 2>/dev/null || true
    launchctl load "$PLIST_DEST"
    echo "✅ 已加载：$PLIST_DEST"
}

remove_one() {
    declare_task "$1"
    echo ""
    echo "🗑 卸载：$DESC"
    if [ -f "$PLIST_DEST" ]; then
        launchctl unload "$PLIST_DEST" 2>/dev/null && echo "✅ 已卸载" || echo "ℹ️ 任务未在运行"
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
    if launchctl list | grep -q "$PLIST_NAME"; then
        launchctl list | grep "$PLIST_NAME"
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
    weekly|weekend) TASKS="$TARGET" ;;
    all) TASKS="weekly weekend" ;;
    *) echo "❌ 未知任务: $TARGET（应为 weekly / weekend / all）" >&2; exit 1 ;;
esac

# test 不允许 all
if [ "$ACTION" = "test" ] && [ "$TARGET" = "all" ]; then
    echo "⚠️ test 模式只能跑一个任务，请指定 weekly 或 weekend"
    exit 1
fi

case "$ACTION" in
    install)
        for t in $TASKS; do install_one "$t"; done
        echo ""
        echo "📋 下一步："
        echo "  · 立即跑一次：  bash install-launchd.sh test weekly"
        echo "                  bash install-launchd.sh test weekend"
        echo "  · 查看状态：    bash install-launchd.sh status"
        echo "  · 看日志：      tail -f $PROJECT_DIR/logs/\$(date +%Y-%m-%d).log"
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
