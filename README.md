# 📊 AI Investment Weekly · macOS 版

每周两期自动产出投资研究网页：

| 产出 | 触发 | 焦点 |
|---|---|---|
| **AI 产业链转折点周报** | 每周一 09:00 | 中长期 1–24 月，新能力 / 新瓶颈 / 谁付钱 / 未定价资产 |
| **市场周度复盘** | 每周六 10:00 | 即将一周，AI 泡沫阶段评分 / 持仓处理 / 三种情景计划 / 8 条行动 / 10 个转折点 |

**完全免费** —— 用你已有的 Claude Code Pro 订阅在本机生成内容，不需要 API key、不需要服务器，前端通过 GitHub Pages 永久托管。

---

## 🎯 整体工作原理

```
你的 Mac（每周一 9:00 + 每周六 10:00 自动唤醒）
    │
    ├─ 周一：调 claude --print → skill ai-turning-points  → 产业链周报
    ├─ 周六：调 claude --print → skill weekly-market-review → 市场复盘
    │           ↓
    │   skill 联网搜数据，按方法论生成 HTML，写入 docs/{reports|reviews}/<日期>/
    │   并更新 docs/index.html 的归档列表
    │           ↓
    └─ git push → GitHub Pages 自动更新
                     │
                     ▼
              访问固定网址查看
              https://你的GitHub用户名.github.io/ai-investment-weekly/
```

**为什么用 macOS launchd 而不是 GitHub Actions：** 因为 Claude Code Pro 订阅认证在你本地 Mac 上，云端 Actions 没法用你的订阅。launchd 是 macOS 原生的"cron 替代品"，比 cron 更可靠：电脑睡眠时跳过的任务，唤醒后会自动补跑。

---

## 📦 部署步骤（约 15 分钟）

### 第 0 步：前提检查

打开**终端**（Spotlight 搜 Terminal），逐条运行：

```bash
which claude     # 应输出 claude 路径
claude --version # 应输出版本号
git --version    # 应输出 git 版本
```

如果 `claude` 找不到：

```bash
npm install -g @anthropic-ai/claude-code
claude login   # 用你的 Pro 账号登录（一次性）
```

### 第 1 步：放置项目

把项目文件夹放到你想要的位置（推荐 `~/Documents/CC/ai-investment-weekly` 或 `~/ai-investment-weekly`）：

```bash
cd ~/Documents/CC/ai-investment-weekly   # 切到项目根目录
```

> **路径无关**：脚本和 launchd plist 都用占位符（`__PROJECT_DIR__`），install 时自动按当前位置填充。把整个文件夹移到任何路径都行，只要重新跑 `bash install-launchd.sh install` 即可。

### 第 2 步：在 GitHub 上创建仓库

1. 登录 [github.com](https://github.com) → New repository
2. 仓库名：`ai-investment-weekly`（**用这个名**，否则后面网址会乱）
3. 选 **Public**
4. **不要**勾选 "Initialize with README"
5. Create

### 第 3 步：把项目推到 GitHub

```bash
cd ~/Documents/CC/ai-investment-weekly
git init
git add .
git commit -m "Initial commit: AI investment weekly skeleton + issue 1"

# 把 YOUR_USERNAME 换成你的 GitHub 用户名
git remote add origin https://github.com/YOUR_USERNAME/ai-investment-weekly.git
git branch -M main
git push -u origin main
```

第一次推送可能需要登录授权（Mac 弹窗会引导你完成）。

### 第 4 步：启用 GitHub Pages

1. GitHub 仓库页 → **Settings** → 左侧 **Pages**
2. **Source** 选 `Deploy from a branch`
3. **Branch** 选 `main`，文件夹选 `/docs`
4. **Save**
5. 等 1–2 分钟，刷新页面，会显示一个网址：
   `https://YOUR_USERNAME.github.io/ai-investment-weekly/`

**这就是你的应用永久访问地址。** Mac/iPhone 浏览器都能开，加到主屏幕即可像 App 一样用。

### 第 5 步：手动跑一次测试

```bash
cd ~/Documents/CC/ai-investment-weekly
bash weekly-update.sh
```

第一次跑预计 3–8 分钟（联网搜索+生成 HTML+git push）。看到 "🎉 完成" 就成了。

常见错误：
- **claude 命令找不到** → 看第 0 步
- **git push 失败** → 检查 GitHub 仓库地址和登录状态
- **skill 没找到 docs/** → 确认你在 `~/Documents/CC/ai-investment-weekly` 目录里跑的脚本

### 第 6 步：填持仓（周末复盘需要）

打开 `https://YOUR_USERNAME.github.io/ai-investment-weekly/portfolio.html`：

1. 第一次：点 **选择 data 目录** → 弹窗里定位到 `~/Documents/CC/ai-investment-weekly/data/` → 选中授权。
2. 编辑表格（增/删持仓行、改观察清单）。
3. 点 **保存到文件** → 浏览器直接写到本地 `data/portfolio.json`。
4. 完。下次进网页浏览器会记住授权，再次保存时点一下系统弹窗确认即可。

**隐私 — 真实持仓永远不进 git：**
- `data/portfolio.json` 已加入 `.gitignore`，本地文件不会被 push 到 GitHub。
- 浏览器用 File System Access API 直接写本地磁盘，不经过任何服务器。
- 仓库可以放心保持 public。
- 提交到 git 的只有 `data/portfolio.example.json`（占位模板，无真实数据）。

**支持的浏览器：** Chrome / Edge / Arc / Brave。Safari/Firefox 暂不支持 FS Access API，会自动降级到"导出 JSON → 手动覆盖文件"的旧流程。

> 换 Mac / 重装的话：因为持仓不在 git，需要手动重填一次（或从老 Mac 拷贝 `data/portfolio.json`）。

### 第 7 步：安装定时任务（两个）

```bash
bash install-launchd.sh                  # 一次性装两个任务
# 等价于：
#   bash install-launchd.sh install all
```

输出两个 "✅ 已加载" 即成功。从此：
- 每周一 09:00 自动出**产业链周报**
- 每周六 10:00 自动出**市场周度复盘**

只想要其中一个的话：

```bash
bash install-launchd.sh install weekly    # 只装周一
bash install-launchd.sh install weekend   # 只装周六
```

---

## 🛠 日常运维

```bash
cd ~/Documents/CC/ai-investment-weekly

# 立即手动跑一次（必须指定哪个任务）
bash install-launchd.sh test weekly       # 跑产业链周报
bash install-launchd.sh test weekend      # 跑市场复盘

# 查看两个任务状态 + 最近日志
bash install-launchd.sh status

# 看最新日志
tail -f logs/$(date +%Y-%m-%d).log         # 周一任务
tail -f logs/$(date +%Y-%m-%d)-review.log  # 周六任务

# 卸载定时任务
bash install-launchd.sh remove            # 全部
bash install-launchd.sh remove weekend    # 只删周六
```

---

## 🧠 让 skill 在任何会话里全局可用

部署完后，可以让 Claude Code 在任何会话里识别这两个 skill：

```bash
mkdir -p ~/.claude/skills
ln -s ~/Documents/CC/ai-investment-weekly/skill                ~/.claude/skills/ai-turning-points
ln -s ~/Documents/CC/ai-investment-weekly/skill-market-review  ~/.claude/skills/weekly-market-review
```

这样在任意目录开 Claude Code 会话，说：

- "出一份 AI 产业链调研" → 触发 ai-turning-points（默认终端 markdown，要 HTML 就说"写到 docs/"）
- "做一下本周复盘" → 触发 weekly-market-review（默认终端 markdown）

---

## ⚙️ 自定义

### 改运行时间 / 频率

- 周一周报：编辑 `launchd/com.user.ai-weekly.plist`
- 周六复盘：编辑 `launchd/com.user.ai-weekend-review.plist`

```xml
<key>StartCalendarInterval</key>
<dict>
    <key>Weekday</key>
    <integer>1</integer>      <!-- 0/7=周日, 1=周一, ..., 6=周六 -->
    <key>Hour</key>
    <integer>9</integer>      <!-- 24 小时制 -->
    <key>Minute</key>
    <integer>0</integer>
</dict>
```

改完重装：

```bash
bash install-launchd.sh remove all
bash install-launchd.sh install all
```

### 改研究方向 / 主题

- **产业链周报**：编辑 `skill/SKILL.md` 的 "Step 2 — Scan for new capability" 表格；深度参数在 `skill/references/methodology.md`。
- **市场复盘**：编辑 `skill-market-review/SKILL.md` 的 "Weekly checklist"；评分细则在 `skill-market-review/references/methodology.md`。
- **持仓和观察清单**：在 `docs/portfolio.html` 网页编辑（推荐），或直接 vim `data/portfolio.json`。

### 改报告样式

编辑 `docs/assets/styles.css`。所有当期与历史报告 + 首页 + 持仓页共享同一份样式。

### 改 HTML 模板结构

- 产业链周报模板：`skill/assets/template.html`
- 市场复盘模板：`skill-market-review/assets/template.html`

模板里 `<!-- FILL: ... -->` 是占位符，skill 在生成时会替换。

---

## 🐛 常见问题

**Q: 周一 9:00 时电脑在睡眠，会漏跑吗？**
A: 不会。`launchd` 在唤醒后会自动补跑（这是它比 cron 强的地方）。

**Q: 周一全天都在关机怎么办？**
A: 那确实会漏。次日开机后手动 `bash install-launchd.sh test` 即可。或在系统设置 → 节能里开"插电时不睡眠"。

**Q: Pro 订阅每周用一次会不会触发限流？**
A: 一次调研约 30–80 个 web 搜索 + 一次大文档生成。Pro 套餐每 5 小时窗口对此完全够用。

**Q: 我手机上想看怎么办？**
A: Safari 打开 `https://YOUR_USERNAME.github.io/ai-investment-weekly/` → 分享 → "添加到主屏幕"。

**Q: 上一期报告内容不满意，怎么重跑？**
A: 删掉 `docs/reports/<日期>/` 目录，再 `bash install-launchd.sh test`。注意首页 `docs/index.html` 的归档列表里那条也要手动删一下，否则会重复。

**Q: skill 偶尔没生成报告就 push 了空 commit？**
A: 不会。`weekly-update.sh` 会检查 `docs/` 是否真的有改动，没改动会跳过 commit。如果 skill 跑挂了（网络/限流），看 `logs/<日期>.log` 排查。

**Q: 我笔记本带去外地用，会有问题吗？**
A: 不会，只要联网+开机，定时任务正常跑。

**Q: 我想要回测/检索过去某期的数据怎么办？**
A: 报告本身就是 HTML，从 git 历史能完整恢复。如果以后想要 JSON 形式的结构化数据，可以在 skill 里加输出 `report.json` 的步骤（README 末尾"下一步"里有提）。

---

## 📂 文件结构

```
ai-investment-weekly/
├── README.md                                   # 本文件
├── .gitignore
├── weekly-update.sh                            # 主脚本 · 周一 09:00 跑（产业链周报）
├── weekend-review.sh                           # 主脚本 · 周六 10:00 跑（市场复盘）
├── install-launchd.sh                          # 双任务定时安装/卸载/测试
├── launchd/
│   ├── com.user.ai-weekly.plist                # 周一任务模板
│   └── com.user.ai-weekend-review.plist        # 周六任务模板
├── logs/                                       # 运行日志（不进 git）
├── data/
│   └── portfolio.json                          # 持仓 + 观察清单（真源；docs/ 之外）
├── skill/                                      # skill: ai-turning-points
│   ├── SKILL.md
│   ├── references/methodology.md
│   └── assets/template.html
├── skill-market-review/                        # skill: weekly-market-review
│   ├── SKILL.md
│   ├── references/methodology.md
│   └── assets/template.html
└── docs/                                       # → GitHub Pages 部署目录
    ├── index.html                              # 网站首页（导航 + 两个归档）
    ├── portfolio.html                          # 持仓编辑器（client-side）
    ├── assets/
    │   └── styles.css                          # 共享样式
    ├── reports/                                # 产业链周报历史
    │   └── 2026-05-10/index.html
    └── reviews/                                # 市场复盘历史（首期由 cron 产出）
```

---

## 🧠 设计选择

- **静态 HTML，不用框架。** 这是研究简报不是 Web app；少依赖 = 少维护，10 年后还能打开。
- **样式集中在 `docs/assets/styles.css`。** 改一次设计全站统一。
- **首页归档用 `<!-- ARCHIVE-START / END -->` 和 `<!-- REVIEW-ARCHIVE-START / END -->` 注释做锚点。** 让 skill 能精确插入新期，不会覆盖首页其他内容。
- **持仓数据放 `data/`，不放 `docs/`。** GitHub Pages 只服务 `docs/`，所以持仓不会被网站公开（但 git 仓库本身仍可被看到，介意就用 private repo）。
- **持仓编辑器纯 client-side。** 改完导出 JSON，手动覆盖文件——简单、可靠、不需要后端。
- **报告之间不互相依赖。** 删掉某一期不会影响其他期。
- **本地跑而非 cloud Actions。** 因为 Claude Pro 订阅在本地，cloud 跑不了；而且本地跑更省（不消耗 API 额度）。
- **周报 + 复盘双轨制。** 周一周报看产业链中长期；周六复盘看自己持仓和下周计划。两份独立，焦点不同。

---

## 🚀 下一步可以加什么（按优先级）

1. **跨期 diff 视图**：让首页除了归档列表外，再展示"这周 vs 上周"评分变动榜。
2. **简单 RSS 输出**：方便订阅器接入。
3. **图表化**：评分分布、主题热度时间序列（需引入 d3 或 echarts，权衡复杂度）。
4. **JSON 数据层**：每期同时输出 `report.json`，便于回测 / 检索。
5. **多研究员视角**：同一周分别用「保守」「激进」「宏观」三种视角各跑一份。

但只在你真的想要这些之前再做。MVP 已经够用。

---

## 📝 License

MIT
