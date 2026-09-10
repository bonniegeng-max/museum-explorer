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
│   ├── hnmuseum-exhibitions.json   # 湖博推介展索引（10 条目，输出型巡展库）
│   ├── gdmuseum-exhibitions.json   # 广东省博物馆展览索引（9 条目，WebFetch 通道）
│   ├── szmuseum-exhibitions.json   # 苏州博物馆展览索引（8 条目）
│   ├── chnmus-exhibitions.json     # 河南博物院展览索引（17 条目，资讯流核地点）
│   └── namoc-exhibitions.json      # 中国美术馆展览索引（11 条目）
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

- **v1.6.4** (2026-09-06)：扫描第二轮收尾（SkillSpector 会话确认 gate + T09 字面量序列化）——SkillSpector 认可了 v1.6.3 的能力边界（SDI-2/SQP-2 降为 expected），但要求"会话级显式确认 gate"落地到每个落盘指令与 data 合并处：① `references/data-sources.md` 合并步骤新增"先展示变更摘要、征得用户同意再写入"硬 gate（默认不自动静默更新）；SKILL.md 阶段1 同步、能力边界表 data 行同步加确认 gate；② 观展单主模板与 examples 副本的 `session.md` 指令均加"写入前展示内容并征得同意"；③ T09 升级：三个手帐 HTML 的 JOURNAL_DATA 头注释 + SKILL.md 阶段3 从"仅防 `</script>`"升级为完整 **JS 字符串字面量安全序列化**约束（双引号转义 `\"` / 反斜杠 `\\` / 禁 `</script` / 外部文本先清洗 / 禁止原样粘贴）。
- **v1.6.3** (2026-09-06)：安全修复完整性收尾（T09 全量排查 + SkillSpector 能力边界）——① 全库排查发现 `journal/2026-08-30-遇见吴哥窟/journal.html` 历史副本漏修（v1.6.1/v1.6.2 仅覆盖主模板与 examples 副本），同步 esc() 引号转义与 makeStamp 数值钳制；② 新增 `</script>` 解析期逃逸防线：三个手帐 HTML 的 JOURNAL_DATA 头注释与 SKILL.md 阶段3 均加入填写安全红线（数据值内 `</script` 必须写作 `<\/script`），堵住"渲染期转义保护不到解析期闭合"的缺口；③ 针对 SkillSpector「Context-Inappropriate Capability」（Medium, 88%）finding：SKILL.md 新增**文件写入能力边界（硬约束）**声明——写入路径白名单（session.md / journal / stamps / data 索引）+ 覆盖删除前须确认 + 白名单外零写入 + "不用会话文件"退出选项 + 敏感信息数据最小化，观展单模板同步收紧。
- **v1.6.2** (2026-09-06)：扫描收尾修复（SDI-4 + T09 残留）——① `data/sxhm-exhibitions.json` 溯源元数据如实化：此前声称仅同步自官网临时展览栏目，实际含 2 条 permanent 条目（url 指向 basic_display.html 基本陈列页），syncSource 改为混合源标注（44 临展 + 2 常设，按 url/status 区分）；② `examples/angkor-exhibition/journal.html` 历史副本同步 v1.6.1 的 esc() 引号转义与 makeStamp 数值钳制，消除扫描器报告的"shipped copies retain weaker escaping"。
- **v1.6.1** (2026-09-06)：安全修复（ClawHub 扫描 T09）——`journal-template.html` 的 `esc()` 此前不转义引号，而多处将 `${esc(...)}` 嵌入双引号 HTML 属性（`aria-label`/`alt`/`src` 等），带引号的数据可逃出属性注入事件处理器；现补齐 `"`→`&quot;`、`'`→`&#39;` 转义，并对 `makeStamp()` 的 `size`/`rot` 增加数值钳制（防 CSS 注入）。
- **v1.6.0** (2026-09-06)：第十一馆——中华世纪坛艺术馆。新增 `data/worldartmuseum-exhibitions.json`（5 条目：百年芳心·奥地利美景宫花绘真迹展 / 苍穹记忆·南天门计划 / 我们·看见中华 / 北京摄影周2026 / 大音·和鸣），官网 worldartmuseum.cn 双通道不可达（curl TLS 握手失败 + WebFetch fetch-failed），建立「多源替代链」抓取规则（文物局月度展讯 + 市政府门户展览日历 + 官方公众号 + 新闻媒体，B/D 级源逐条标注）；SKILL.md 阶段1 同步更新为十一馆规则。本馆定位为临展高频+商业特展购票制场馆，与既有免费预约馆形成互补。
- **v1.5.1** (2026-09-02)：数据质量修正——ClawHub 安全扫描（SDI-4）发现国博索引两处 `fullTitle` 错位（[23] 帕拉第奥展、[28] 抗战展被误填为「了不起的汉字」全称），经馆方官网详情页核实后修正，重新发布后 scan findings 清空。
- **v1.5.0** (2026-09-02)：十馆索引体系 + 闭展倒计时——新增粤博/苏博/河南博物院/中国美术馆四馆索引（合计 261 条目）；`data-sources.md` 三至十馆抓取规则重写：粤博 TLS 阻断走 WebFetch 通道（多源交叉核展期）、苏博静态列表自带展期展厅、河南博物院"展览资讯"混合流须逐条核地点、中国美术馆域名纠正为 namoc.cn；SKILL.md 阶段1 新增**闭展倒计时**规则（≤7 天 ⚠️ / 8-30 天 ⏳ / 已闭改荐 / 无 dateEnd 标常设），策展卡头与观展单头各加展期状态行。
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
