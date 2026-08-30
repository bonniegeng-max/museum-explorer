# museum-explorer｜看展全链路助手

**行前策展卡 → 行中观展单 → 行后电子手帐 + 印章收集**

让每一次逛展留下一条可回顾、可分享、可复用的链路。不再"看完就忘"，而是：先看懂、再打卡、最后变成一册带印章的电子手帐。

---

## 三阶段工作流

1. **行前 `curations-card.md`**：展馆与展览信息交叉核验、重点展品清单、行前功课（纪录片/书籍）、来源核验表。
2. **行中 `on-site-checklist.md`**：按动线打卡，每展品预留「拍照位 + 感受槽」，支持现场问答追加。
3. **行后 `journal-template.html`**：统一生成电子手帐（A4 排版、可打印），包含：
   - 封面页
   - 展品页（两栏/页）
   - 集章册页
   - 来源核验表与尾页手记

所有印章遵循统一的 SVG 形制（双线圆框 + 环绕文字 + 中心纹样），中心纹样从展品本身抽象提取。

---

## 目录结构

```
museum-explorer/
├── SKILL.md                        # skill 主文档
├── README.md                       # 本文件
├── templates/
│   ├── curations-card.md
│   ├── on-site-checklist.md
│   └── journal-template.html       # 手帐模板，只改 JOURNAL_DATA
├── references/
│   ├── stamp-design-guide.md       # 印章形制规范
│   ├── source-verification.md      # 来源核验红线
│   ├── data-sources.md             # 上游数据源清单（官方源+抓取规则+同步流程，2026-08-30 实测）
│   └── exhibits.schema.json        # 展品数据 schema
├── data/                           # 知识库（{museum}.json=展品，{museum}-exhibitions.json=展览索引）
│   ├── yujian-angkor-2026.json     # 遇见吴哥窟展品库（真实案例）
│   ├── chnmuseum-exhibitions.json  # 国博展览索引（37 条目）
│   ├── dpm-exhibitions.json        # 故宫展览索引（50 条目：当期/常设专馆/外借展）
│   ├── shanghaimuseum-exhibitions.json  # 上博展览索引（50 条目，JSON API 同步）
│   ├── njmuseum-exhibitions.json   # 南博展览索引（23 条目，JSON API 同步）
│   ├── sxhm-exhibitions.json       # 陕历博展览索引（46 条目）
│   └── hnmuseum-exhibitions.json   # 湖博推介展索引（10 条目，输出型巡展库）
├── journal/                        # 每次观展会话目录
│   └── 2026-08-30-遇见吴哥窟/
│       ├── session.md              # 会话状态
│       ├── curations-card.md
│       ├── checklist.md
│       ├── journal.html            # 电子手帐
│       └── stamps/                 # 印章 SVG 文件
├── examples/                       # 给 skill 用户参考的真实示例
│   └── angkor-exhibition/
└── preview/                        # 手帐渲染预览图
```

---

## 快速开始

```bash
# 1. 安装 skill（假设你使用 openclaw）
openclaw skills install @bonniegeng-max/museum-explorer

# 2. 使用：直接让 AI 帮你做一场展览的三件套
"我要去看 遇见博物馆 的吴哥窟展，帮我生成策展卡"
"我在现场，诃里诃罗为什么断臂？"
"我已经看完了，生成电子手帐"
```

---

## 真实案例：遇见吴哥窟

- **展览**：「遇见吴哥窟——柬埔寨国家博物馆文物特展」
- **地点**：北京 · 遇见博物馆 798 馆
- **展期**：2026-05-01 ~ 2026-08-30
- **故事**：用户在闭展日现场连续向 AI 提出 6 个展品问题——从湿婆与南迪、诃里诃罗断臂、塞建陀骑孔雀，到穆卡林加像帽子、湿婆善恶、扶南骑象等级。本 skill 将这些真实问答整理进「行中观展单」，并为 8 件重点展品生成统一印章与电子手帐。
- **查看完整产物**：[examples/angkor-exhibition/](examples/angkor-exhibition/)
- **手帐预览**：
  - 封面：[`preview/angkor-cover.png`](preview/angkor-cover.png)
  - 展品页：[`preview/angkor-exhibits.png`](preview/angkor-exhibits.png)
  - 集章页：[`preview/angkor-stampwall.png`](preview/angkor-stampwall.png)
  - 来源核验与尾页：[`preview/angkor-sources.png`](preview/angkor-sources.png)

---

## 核心设计原则

- **模板驱动**：三阶段产出严格使用模板，禁止现场发挥，保证跨会话风格一致。
- **来源核验**：关键事实 ≥2 独立来源；存疑标【待核实】。
- **会话状态**：每次展览创建独立目录，跨天继续时先读 `session.md` 恢复上下文。
- **版权红线**：古代文物纹样可抽象提取；当代艺术品只取元素，不复制原作。

---

## 更新日志

- **v1.4.0** (2026-08-30)：六馆展览索引体系——上游同步从国博单馆扩展到故宫/上博/南博/陕历博/湖博共六馆（合计 216 条目，全部 A 级馆方源 2026-08-30 实测同步）；关键突破：故宫 `/searchs/exhibition.html` 检索接口破解（`tpl_file` 模板参数，列表页 SPA 无需浏览器）、上博 `search-exhibit` 原生 JSON API（发现中英成对录入规律并过滤）、南博 `/api/exhibition/list` JSON API、陕历博静态列表页自带展期展厅、湖博"展览推介"栏目定性为输出型巡展库（如实标注数据边界）；`data-sources.md` 第三节重写为六馆逐馆抓取规则（接口 URL/参数/条目结构/状态判定细则），新增反模式 3 条（巡展库误用/上博英文重复/SPA 接口探测方法论）。
- **v1.3.0** (2026-08-30)：上游数据源体系——新增 `references/data-sources.md`（全部源 2026-08-30 沙箱实测：国博官网展览频道/详情页/要闻流/藏品库四层抓取规则、微信公众号"搜索引擎发现+直链抓取"路径、故宫等 7 家国内大馆、Met Museum 公开 API、卢浮宫；标注搜狗微信反爬与 Wikidata 网络受限等实测结论）；定义 `data/{museum}-exhibitions.json` 展览索引结构与同步流程（URL 为唯一键增量合并、展期原文/解析双字段、同步后必须简报）；实战产出 `data/chnmuseum-exhibitions.json`（国博 37 条目：8 在展 / 9 常设 / 17 已闭 / 3 巡展，闭展信息经要闻流二次佐证）；SKILL.md 阶段1 增加"同步上游展览索引"步骤与闭展复检要求。
- **v1.2.2** (2026-08-30)：安全加固——手帐模板 `makeStamp()` 新增 `sanitizeCenter()` SVG 白名单过滤（剥除脚本/事件/引用类标签与属性，防数据块注入）；README 推送指引改为 `gh auth login` 认证与 `--force-with-lease`，移除 token-in-URL 与默认 `--force`；SKILL.md 增加本地数据告知与照片隐私提示；观展单模板写入 `session.md` 时向用户说明，不静默写入。
- **v1.2.1** (2026-08-30)：移除 skill 包内附带的 `publish.sh` 脚本，改为 README 中给出手动推送命令；修复 SkillSpector 因"附带发布脚本"导致的 `suspicious` 安全评级。
- **v1.2.0** (2026-08-30)：新增「遇见吴哥窟」真实案例；完整 pilot 产出 8 件展品数据库、7 页电子手帐、8 枚印章 SVG；强化了【待核实】的诚实标注示例。
- **v1.1.0**：加入 `session.md` 会话状态机制，明确来源核验为强制栏目。
- **v1.0.0**：基础三阶段模板与印章形制规范。

## 手动推送到 GitHub（仓库维护者）

本 skill 包不附带任何发布脚本。如果你是仓库维护者，需要把更新同步到 GitHub，推荐使用 GitHub CLI 认证（凭证不落 shell 历史）：

```bash
gh auth login            # 浏览器授权，凭证由 gh 安全托管
cd museum-explorer
git remote add origin https://github.com/bonniegeng-max/museum-explorer.git
git push -u origin main
```

- 若推送被拒（远程有旧历史）：先 `git pull --rebase origin main`；确需替换历史时用 `git push --force-with-lease`，并知悉**这会覆盖远程已有提交，覆盖前请确认远程没有他人协作内容**。
- 如需使用 Personal Access Token，请通过 `gh auth login` 或 git 凭证助手（`git config --global credential.helper store`）输入，**不要把令牌写进 URL 命令行**——令牌会留在 shell 历史与进程列表中造成泄露风险。

---

## 作者

- **ClawHub**：`@bonniegeng-max/museum-explorer`
- **GitHub**：`bonniegeng-max/museum-explorer`
- **License**：MIT
