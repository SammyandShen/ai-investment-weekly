#!/bin/bash
# install-launchd.sh
# 一键安装 macOS 定时任务（每周一 9:00 自动出本周报告）
#
# 用法：
#   bash install-launchd.sh        # 安装
#   bash install-launchd.sh test   # 立即手动跑一次
#   bash install-launchd.sh status # 查看状态
#   bash install-launchd.sh remove # 卸载

set -e

USERNAME=$(whoami)
PROJECT_DIR="$HOME/ai-investment-weekly"
PLIST_NAME="com.user.ai-weekly"
PLIST_SOURCE="$PROJECT_DIR/launchd/$PLIST_NAME.plist"
PLIST_DEST="$HOME/Library/LaunchAgents/$PLIST_NAME.plist"

case "${1:-install}" in
    install)
        echo "📦 安装定时任务（每周一 09:00 自动跑）..."

        if [ ! -d "$PROJECT_DIR" ]; then
            echo "❌ 找不到项目目录 $PROJECT_DIR"
            echo "   请先把项目克隆/复制到 $HOME/ai-investment-weekly"
            exit 1
        fi

        mkdir -p "$HOME/Library/LaunchAgents"
        sed "s|USERNAME|$USERNAME|g" "$PLIST_SOURCE" > "$PLIST_DEST"
        echo "✅ 已生成 $PLIST_DEST"

        chmod +x "$PROJECT_DIR/weekly-update.sh"

        launchctl unload "$PLIST_DEST" 2>/dev/null || true
        launchctl load "$PLIST_DEST"
        echo "✅ 定时任务已加载"

        echo ""
        echo "📋 下一步："
        echo "  1. 跑一次测试：bash install-launchd.sh test"
        echo "  2. 查看状态：  bash install-launchd.sh status"
        echo "  3. 看日志：    tail -f $PROJECT_DIR/logs/\$(date +%Y-%m-%d).log"
        echo ""
        echo "⏰ 每周一 09:00 自动跑（电脑那时在睡眠的话，唤醒后会补跑）"
        ;;

    test)
        echo "🧪 立即手动跑一次..."
        cd "$PROJECT_DIR"
        bash weekly-update.sh
        ;;

    status)
        echo "📊 任务状态："
        if launchctl list | grep -q "$PLIST_NAME"; then
            launchctl list | grep "$PLIST_NAME"
            echo ""
            echo "✅ 任务已加载"
            echo ""
            echo "最近一次执行日志："
            LATEST_LOG=$(ls -t "$PROJECT_DIR/logs/"*.log 2>/dev/null | head -1)
            if [ -n "$LATEST_LOG" ]; then
                echo "($LATEST_LOG)"
                tail -20 "$LATEST_LOG"
            else
                echo "（还没有日志，下个周一 9:00 后查看）"
            fi
        else
            echo "❌ 任务未加载，运行 'bash install-launchd.sh install' 安装"
        fi
        ;;

    remove)
        echo "🗑 卸载定时任务..."
        launchctl unload "$PLIST_DEST" 2>/dev/null && echo "✅ 已卸载" || echo "ℹ️ 任务未在运行"
        rm -f "$PLIST_DEST"
        echo "✅ 已删除 $PLIST_DEST"
        echo "项目文件夹和日志保留：rm -rf $PROJECT_DIR 才会彻底删除"
        ;;

    *)
        echo "用法："
        echo "  bash install-launchd.sh         # 安装定时任务"
        echo "  bash install-launchd.sh test    # 立即手动跑一次"
        echo "  bash install-launchd.sh status  # 查看运行状态"
        echo "  bash install-launchd.sh remove  # 卸载"
        exit 1
        ;;
esac
