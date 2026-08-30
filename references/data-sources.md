# 上游数据源清单 data-sources.md

> 本地库 `data/{museum}.json` 的数据从哪里来、怎么保持新鲜。所有源均在 2026-08-30 实测验证，标注了抓取方式与当前状态。
> 使用顺序：**先读本地库 → 命中则复检易变信息 → 未命中按本清单从上往下找**。来源可信级（A/B/C/D）定义见 `source-verification.md`。

## 一、快速索引表

| 数据源 | 级别 | 拿什么 | 实测状态（2026-08-30） |
|---|---|---|---|
| 国博官网·展览频道 | A | 在展/常设/巡展清单、展期、展厅 | ✅ 可直连，静态可解析（45 条目） |
| 国博官网·展览详情页 | A | 展览结构、单元划分、参展单位、文物数量 | ✅ 正文完整可提取 |
| 国博官网·要闻流"国博展讯" | A | 开展/闭展预告（时效最强，精确到天） | ✅ 可直连 |
| 国博官网·藏品库 | A | 藏品著录（名称/年代/描述） | ✅ 可直连，静态 HTML 无 API |
| 馆方微信公众号文章 | A | 展讯推送、预约公告、临展导览 | ✅ mp.weixin.qq.com 直链可抓；**链接靠通用搜索引擎发现** |
| 故宫官网·展览检索接口 | A | 当期展（含常设专馆）、外借展清单 | ✅ **接口已破解**（`/searchs/exhibition.html`，需 `tpl_file` 参数，见 3.1） |
| 上博官网·展览数据接口 | A | 全量线下展（中英成对，含展期展厅） | ✅ **原生 JSON API**（见 3.2） |
| 南博官网·展览接口 | A | 当期展清单（含展期展厅票价） | ✅ **原生 JSON API**（见 3.3） |
| 陕历博官网·临时展览栏目 | A | 临展全量列表（含展期展厅，5 页） | ✅ 静态 HTML 可解析（见 3.4） |
| 湖南博物院官网·展览推介 | A | 馆方推介展（**多为输出型巡展库**） | ✅ 静态可解析；⚠️ 本馆在展索引需公众号核实（见 3.5） |
| 三星堆博物馆官网 | A | 展览/开放信息 | ⚠️ 纯 Vue SPA 无公开接口，需浏览器渲染 |
| Met Museum API | A | 海外馆藏中国文物/吴哥等亚洲文物著录+公版图 | ✅ 真·公开 REST API，无需密钥 |
| 卢浮宫线上馆藏 | A | 同上 | ✅ 可直连 |
| Wikidata / SPARQL | C | 跨库实体对齐、别名、年代补充 | ❌ 沙箱网络被拦（用户本地环境通常可用） |
| 聚合展讯公众号（如"北航美育中心"月度汇总） | D | 多馆展览发现线索 + 各馆官方推文直链 | ✅ 经搜索引擎可索引；**只作线索，不作事实来源** |
| 搜狗微信搜索 | — | 公众号内容发现 | ❌ 反爬（antispider），弃用 |

## 二、国博（中国国家博物馆）四层结构

国博是本 skill 的重点馆，官网 `www.chnmuseum.cn` 直连稳定，四层数据互为补充：

### 2.1 展览频道 `/zl/` —— 在展总览（第一入口）

静态 HTML，无需渲染。每个展览条目在 `<li class="scale_imgs">` 块内：

```html
<a href="./lszl/lswh/202604/t20260409_278920.shtml">          <!-- 详情页链接 -->
<div class="hide_title">李静训和她的时代</div>                  <!-- 展览名 -->
<div class="hide_box"><p>展期</p><p>2026/4/3—10/8</p></div>    <!-- 展期原始文本 -->
<div class="hide_box"><p>地点</p><p>南6、南7展厅</p></div>      <!-- 展厅 -->
```

- URL 规律：`/zl/{栏目}/{YYYYMM}/t{YYYYMMDD}_{id}.shtml`，栏目含 `lszl/lswh`（历史文化）、`lszl/gjjl`（国际交流）、`lszl/zdzt`（重大主题）、`lszl/yscx`（艺术创新）、`ztcl`（专题陈列=常设）、`zzzc`（基本陈列）、`zlhg`（展览回顾=已闭展）、`gbxz`（国博巡展=外地巡展）
- **巡展条目（gbxz）的"地点"是外地承接馆**，如"华彩万象"地点为淄博陶瓷琉璃博物馆，行前功课别把巡展当北京本馆在展
- 相对链接 `./` 需替换为 `https://www.chnmuseum.cn/zl/`

### 2.2 展览详情页 —— 深度信息（第二层）

正文为 TRS CMS 静态渲染，剥掉标签即得纯文本。可靠字段：展览分几个单元、主办/支持单位、参展文物数量与来源、"X月X日对公众展出"。例（李静训展）：四个单元名、240 余件馆藏 + 10 余家外借单位 150 余件——策展卡的"为什么值得看"素材直接取自这里。

### 2.3 要闻流 `/zx/gbxw/` —— 时效核验（易变信息专用）

"国博展讯｜xxx 将于 X月X日惜别观众"系列推文是**闭展信息的最快来源**，常早于展览频道列表页更新。规律：标题含"惜别观众"= 闭展预告；含"对公众展出/启幕"= 开展。做行前功课时，凡策展卡上展期临近结束的展览，必查此流确认是否延期/闭幕。

### 2.4 藏品库 `/zp/`（分类 `/zpml/*`）—— 展品级著录

静态 HTML 大页（384KB+），无公开 API。适合"积累展品"时核对官方名称与年代表述；按分类浏览（精品/各时代文物等）。单件展品入库时，这里是 A 级第一来源。

### 2.5 微信公众号"中国国家博物馆" —— 官方推送的发现与抓取

公众号在微信生态内，但正文页是公开网页：

1. **发现**：用通用搜索引擎（WebSearch）检索，如 `site:mp.weixin.qq.com 中国国家博物馆 展讯`——实测能命中官方推送正文并给出 `mp.weixin.qq.com/s/xxx` 直链；也可直接搜展览名+馆名，命中馆方推送概率高
2. **抓取**：拿到直链后直接访问（域名实测可直连），正文在 `js_content` 容器内；标题取 `og:title` meta
3. **限制**：搜狗微信搜索（weixin.sogou.com）反爬严重，不要用；公众号历史列表页无法翻页抓取，只能按需单篇发现
4. **判定**：认准账号主体"中国国家博物馆"；聚合类展讯号（高校美育中心、媒体号）即使内容详实也只算 D 级线索，其中罗列的各馆官方推文链接可顺藤摸瓜核验

## 三、其他大馆官网实测抓取规则（2026-08-30 全部实测）

> 六馆索引已程序化入库 `data/*-exhibitions.json`（国博/故宫/上博/南博/陕历博/湖博，合计 216 条）。以下规则供下次同步直接复用。

### 3.1 故宫博物院——展览检索接口（已破解，无需浏览器）

`shows.html` 列表页是 JS 动态渲染，但其背后的检索接口可直接 GET（需带 `tpl_file` 模板参数，否则返回"类型错误"）：

```
当期展（含常设专馆）：
GET https://www.dpm.org.cn/searchs/exhibition.html?tpl_file=shows_temporary2_2&pagesize=30&showstype=301&category_id=301&order=1
请求头：X-Requested-With: XMLHttpRequest, Referer: https://www.dpm.org.cn/shows.html
→ 返回 HTML 片段：<div class="item" title="{展览名}"> 含详情链接、<p>展览地点：{展厅}</p>、部分条目带 <span class="ti">YYYY/MM/DD - YYYY/MM/DD</span>

外借展（故宫参展的外地展，"展出"标签=进行中）：
GET https://www.dpm.org.cn/searchs/exhibition.html?tpl_file=shows_temporary6&notshow2=1&showstype=53&category_id=53&pagesize=20
→ 条目结构：<a class="nolink">{展名}</a> + <p>{外地场馆}</p> + <span class="ti">{展期}</span>
```

- 常设专馆（珍宝馆/钟表馆/陶瓷馆等）无展期字段，按 `permanent` 处理
- **注意滞后**：当期接口里偶有展期已过但未下架的条目（实测 5 条），入库时按展期判 `past` 并在 notes 标注数据冲突
- 详情页 `/show/{id}.html` 静态可抓；首页要闻流含新展预告

### 3.2 上海博物馆——原生 JSON API（数据质量最高）

```
GET https://www.shanghaimuseum.net/mu/frontend/pg/display/search-exhibit?exhibitTypeCode=OFFLINE_EXHIBITION&langCode=CHINESE&page=1&limit=300
→ {"code":0,"count":257,"data":[{name, subtitle, exhibitDateRange:"2026-07-09 - 2027-11-14",
    exhibitPlace, code:"E00004244", issueTime, bannerPath, picPath}, ...]}
```

- **中英双语成对录入**：同一展览有中英两条记录（code 相邻），按 `name` 含中文字符过滤即得纯净中文索引（257 条 → 172 条）
- `langCode` 参数实测不生效，无需纠结取值；`offlineExhibitionType`（PRESENT/FUTURE/PAST）实测也被忽略——**一次拉全量，本地按 `exhibitDateRange` 判状态**
- 展期字段是标准 `YYYY-MM-DD - YYYY-MM-DD` 格式，解析零歧义
- 无展期的条目多为长期陈列，入库标 current 并加【建议核实】notes

### 3.3 南京博物院——原生 JSON API

```
GET https://www.njmuseum.com/api/exhibition/list?page=1&pageSize=50
→ {"code":0,"data":{"list":[{id, title, timedesc:"2026.8.15 - 2026.11.15",
    position:"特展馆三楼11号展厅", price, describe, isVirtual, ...}, ...]}}
```

- 官网首页是 Vue SPA 壳，但此 API 直接可用（参数 `page/pageSize` 即可，type 等参数可省）
- `timedesc` 格式混杂（`2026.8.15 - 2026.11.15` / `2026年7月15日开幕` / `2026年2月开幕`），解析时兼容三种；只含开幕日期的按开展处理
- `isVirtual: true` 为 VR/数字展，category 单独标"虚拟/数字展"
- 23 条即全部当期展，无分页

### 3.4 陕西历史博物馆——静态 HTML（列表页自带展期展厅）

```
临时展览列表：https://www.sxhm.com/Temporary.html（第 N 页 /Temporary/p/N.html，共 5 页）
条目结构（<div id="datalist"> 内）：
  <a class="t1" href="/Temporary/detail/{id}.html">{标题}</a>
  <div class="p">时间：2026年7月6日至10月11日</div>
  <div class="p">地点：陕西历史博物馆第五展厅</div>
```

- **列表页直接含展期+展厅，无需抓详情页**；分页 URL 规律 `/Temporary/p/{N}.html`
- 列表是历史全量临展（2024-2026），按展期判状态；**只有开始日期无结束日期的近期新展按在展处理并标注【待核实闭展时间】**
- 常设展在 `basic_display.html`（介绍页非列表页），常设陈列作整体条目入库
- 相关栏目：`special_exhibtion.html` 专题展览、`temporary_exhibition.html` 交流展览
- 列表页标题超长会截断（"精品..."），需按详情页补全

### 3.5 湖南博物院——可抓但注意数据性质

```
展览推介：https://www.hnmuseum.com/zh-hans/zhanlan_tuijie（静态 Drupal 页面）
条目链接：/zh-hans/content/{URL编码的展览全名}
```

- **"展览推介"栏目多为馆方输出型巡展库**（详情页字段是展品数量/展厅面积/策展人——即可外借项目），不是本馆在展索引
- 本馆当日在展清单官网未提供结构化页面，**需经馆方微信公众号"湖南博物院"或现场信息核实**
- 导航中的"当前展览－基本"路径实测 404（Drupal 路径别名问题）
- 新版藏品数据库 `de.hnmuseum.com/collection/`（试运行）

### 3.6 三星堆博物馆——需浏览器渲染

官网 `www.sxd.cn` 为纯 Vue SPA（`#app` 空壳），数据走腾讯云 COS 与自有接口，主 JS 1.6MB 未发现公开可复用的展览端点。同步此馆时用浏览器自动化渲染，或经馆方公众号。

### 3.7 其他补充

| 馆 | 入口 | 抓取要点 |
|---|---|---|
| 中国美术馆 | `www.namoc.org` | 聚合号高频引用，展讯更新快 |
| 湖南博物院新版藏品库 | `de.hnmuseum.com/collection/` | 试运行阶段 |

> 未覆盖的馆：先 WebSearch `{馆名} 官网 展览`，找到 A 级入口后按"列表页→详情页→数据接口"三层探测（先看页面 JS 里的 `$.get`/`fetch` 调用与 `api`/`search`/`json` 关键词，很多"SPA 壳"馆都有可用接口）；实在无接口再用浏览器自动化。

## 四、海外馆藏（跨境特展与海外中国文物场景）

### 4.1 Met Museum 公开 API（无需密钥，黄金标准）

```
检索：GET https://collectionapi.metmuseum.org/public/collection/v1/search?q={关键词}&departmentId=6
      → {"total":269,"objectIDs":[45180,...]}
详情：GET https://collectionapi.metmuseum.org/public/collection/v1/objects/{objectID}
      → title/period/dynasty/medium/dimensions/creditLine/isPublicDomain/primaryImage
```

- `departmentId=6` = Asian Art；实测"angkor wat"命中 6 件、"shang dynasty bronze"命中 269 件
- `isPublicDomain: true` 的展品有 `primaryImage` 高清公版图链接（印章参考纹样可用，注意仅限公有领域作品）
- 用途：看海外特展（如吴哥艺术）或"流失海外的中国文物"主题功课时的 B/A 级来源

### 4.2 卢浮宫线上馆藏

`collections.louvre.fr` 可直连，提供检索界面与作品著录（法语/英语）。无全文公开 API，按网页抓取处理。

### 4.3 Wikidata

`www.wikidata.org/wiki/Special:EntityData/{QID}.json` 及 SPARQL 端点。**沙箱网络实测被拦（HTTP 000），用户本地环境通常可用**。定位：跨库对齐与结构化补充（别名、年代、馆藏地），C 级补充源，不单独支撑关键事实。

## 五、上游同步 → 本地库更新流程

**触发时机**：a) 用户要求"更新 xx 馆数据/看看最近有什么展"；b) 新展会话开始且本地索引超过 30 天；c) 行前复检时发现上游已有变更。

**同步步骤**：

1. 拉上游：按本清单第二/三节规则抓取该馆展览数据（国博 `/zl/` 静态页、故宫检索接口、上博/南博 JSON API、陕历博列表页），解析出 `title / url / 展期原文 / 展厅 / 栏目分类`
2. 判状态：对照当前日期，分入 `current`（在展）/ `upcoming`（未开展）/ `past`（已闭展）；展期原文是权威表述，**解析后的起止日期存 `dateStart/dateEnd`，原文照抄进 `dateText`，两者并存**
3. 增量合并进 `data/{museum}-exhibitions.json`（结构见第六节）：URL 为唯一键，已存在则更新字段并追加 `history`；新条目 `verification: "pending"`（A 级单源）——供策展卡引用时仍需第二来源，除非详情页+要闻流双确认后升 `verified`
4. 跨日闭展：闭展信息优先采信要闻流/公众号"惜别观众"推文（带日期），与列表页冲突时以推文为准并记录冲突
5. 告知：同步完成后向用户简报——新增 X 展、闭展 Y 展、Z 条目升为 verified；不做静默写入

**频率与限度**：单馆一次同步只抓列表页 + 至多 2-3 个详情页，不做全站爬取；对上游站点保持礼貌（串行请求、不重复抓已缓存页面）。

## 六、展览索引文件结构（`data/{museum}-exhibitions.json`）

```json
{
  "museum": "中国国家博物馆",
  "upstream": "https://www.chnmuseum.cn/zl/",
  "lastSynced": "2026-08-30",
  "syncSource": "馆方官网展览频道（A 级单源）",
  "exhibitions": [
    {
      "title": "李静训和她的时代",
      "url": "https://www.chnmuseum.cn/zl/lszl/lswh/202604/t20260409_278920.shtml",
      "category": "临时展览·历史文化",
      "status": "current",
      "dateText": "2026/4/3—10/8",
      "dateStart": "2026-04-03",
      "dateEnd": "2026-10-08",
      "venue": "南6、南7展厅",
      "verification": "pending",
      "sources": ["馆方官网展览频道 2026-08-30 抓取"],
      "history": [{"date": "2026-08-30", "change": "首次入库"}]
    }
  ]
}
```

- 展品级数据仍按 `exhibits.schema.json` 入 `data/{museum}.json`；本索引只管"什么展、展到何时、在哪"
- `dateEnd` 解析不了的（如"展期3个月"）留空并在 `dateText` 保留原文，输出时按【待核实】展示
- `status` 只在同步时刻有意义，读取时以当前日期重新判断

## 七、反模式（禁止事项）

1. 禁止把聚合展讯号/媒体汇总当事实来源——只用于发现官方原文链接
2. 禁止在策展卡里引用"沙箱实测不可达"的源（如 Wikidata）却声称已核验——没抓到就是没核验
3. 禁止把巡展条目（国博 gbxz / 故宫外借展）计为本馆在展
4. 禁止静默批量重写本地库——每次同步都要向用户简报变更摘要
5. 展期"原文/解析"双字段缺一不可——只存解析值会在格式歧义（"8/18/"这类尾缀）时丢失纠错线索
6. 禁止把湖博"展览推介"栏目（输出型巡展库）当成本馆在展索引引用
7. 上博数据是中英成对录入——入库前必须过滤英文重复条目，否则同一展览出现两次
