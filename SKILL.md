---
name: museum-explorer
version: 2.0.1
description: Plan a specific museum or exhibition visit with verified logistics and 90/180-minute routes, get concise on-site exhibit explanations, or turn a completed visit into a sourced memory note. Use for a named venue, exhibition, artwork, or completed museum visit.
allowed-tools: WebSearch, WebFetch, Read
---

# Museum Visit Planner & Guide

## What It Does

Help a visitor make one museum visit easier to plan, richer on site, and easier to remember afterward.

The skill has three independent modes:

- **Plan**: verify visit logistics and create a realistic 90- or 180-minute route.
- **Guide**: explain an artwork, object, label, room, or theme in a concise on-site format.
- **Remember**: turn the visitor's notes and reactions into a sourced visit memory.

Use the smallest mode that satisfies the request. Do not force the full three-stage workflow.

## Output Language

Respond in the language used in the user's current request. If that language is unclear, ask which language they prefer. Chinese and English examples in this package illustrate usage only and do not force the output language.

## When to Use

Invoke when the user explicitly asks about:

- visiting a named museum, gallery, or exhibition;
- choosing between current exhibitions;
- planning a route, priorities, timing, breaks, or accessibility;
- understanding something they are looking at inside a venue;
- organizing a completed museum visit into notes or a memory page.

Examples:

- “我周六去故宫，只有 90 分钟，第一次去怎么走？”
- “国博现在有什么展适合带孩子？”
- “我在展厅里，这件青铜器上的饕餮纹怎么看？”
- “把我今天在上博看的五件展品整理成观展记录。”
- “Plan a three-hour visit to the Shanghai Museum for a first-time visitor.”

Do not invoke for:

- a general history or art-history question with no visit context;
- general city travel planning where a museum is only one minor stop;
- fictional museum role-play;
- buying tickets, signing in, booking, or submitting forms.

If the venue or visit intent is materially unclear, ask one concise question. Otherwise start with a useful default and label assumptions.

## Default Boundary

- Answer in the current conversation by default.
- Do not create or modify files unless the user explicitly requests a saved deliverable.
- Do not sign in, buy tickets, make reservations, or submit forms.
- Use public web research only when current or venue-specific facts are needed.
- Never infer an artwork identity from an uncertain photo alone. Ask for the label text, room, title, artist, or accession number when needed.
- Distinguish verified facts, interpretation, and visitor reflection.

## Choose a Mode

| User need | Mode | Default result |
|---|---|---|
| “怎么逛 / 先看什么 / 时间不够” | Plan | Visit Brief with route |
| “现场这件是什么 / 怎么看” | Guide | 60-second object explanation |
| “看完了 / 整理记录” | Remember | Visit Memory |
| Multiple stages explicitly requested | Combined | Complete only the requested stages |

## Plan Mode

### Minimum inputs

- venue or exhibition;
- intended date when logistics matter;
- available time;
- interests, companions, mobility needs, or prior knowledge when supplied.

Ask only for a missing input that would materially change the route.

### Verification

For current information, prefer the venue's official website, official ticketing page, official collection page, or organizer page.

Verify as relevant:

- exhibition dates and venue;
- opening hours and closure days;
- reservation or ticket requirements;
- entry location and major access restrictions;
- accessibility and family services;
- current gallery closures or special notices.

State the access date. If official sources conflict, show the conflict and mark the item `待核实 / verify before departure`.

Do not treat a search snippet, ticket reseller, travel blog, media report, lender page, or old announcement as proof that an exhibition is currently visitable.

### Route design

Offer the route that matches the user's time:

- **90-minute route**: 3–5 highlights, one coherent theme, minimal backtracking, one optional stop.
- **180-minute route**: 5–8 highlights, one break, room for close looking, one optional branch.
- **Custom duration**: scale the number of highlights rather than compressing every stop.

Use `references/venue-starter-packs.md` only as stable orientation. Verify current exhibitions, opening hours, entrances, gallery availability, and ticket rules before presenting them as current.

Follow `templates/visit-brief.md`.

## Guide Mode

Start from what the visitor can actually see or read.

Use this order:

1. **先看哪里**: one observable detail.
2. **它是什么**: verified identification, or a clearly labeled tentative identification.
3. **为什么值得看**: context that changes how the object is understood.
4. **再看一眼**: one question or detail for closer looking.
5. **来源状态**: label text / official collection / authoritative secondary / uncertain.

Keep the default answer short enough to read while standing in a gallery. Expand only when the user asks.

For attribution, dating, provenance, cultural ownership, religion, human remains, colonial collection history, or repatriation, present uncertainty and competing interpretations fairly.

## Remember Mode

Use only details the user supplies plus facts already verified during the visit.

Follow `templates/visit-memory.md`:

- visit in one sentence;
- 3–5 remembered works or moments;
- what the visitor noticed;
- what changed their mind;
- one unresolved question;
- sources and verification status.

Preserve the visitor's voice. Do not fabricate emotions, visited objects, photographs, or conclusions.

## Venue Starter Packs

The package includes stable orientation for six frequently requested venues:

- Palace Museum / 故宫博物院
- National Museum of China / 中国国家博物馆
- Shanghai Museum / 上海博物馆
- Nanjing Museum / 南京博物院
- Shaanxi History Museum / 陕西历史博物馆
- Suzhou Museum / 苏州博物馆

These packs describe collection strengths, route heuristics, and facts that must be rechecked. They do not contain live schedules.

## Output Labels

Use equivalent status labels in the user's current language. The pairs below are examples, not a requirement to output both languages:

- `已核实` / `Verified`
- `用户提供` / `User-provided`
- `解释` / `Interpretation`
- `待核实` / `Unverified`
- `已过期` / `Outdated`

For every current public fact, provide the source URL and access date.

## Completion Standard

- The requested visit stage is clear and completed.
- A plan fits the stated time instead of listing everything.
- Current logistics are verified from the relevant venue or organizer.
- On-site identification remains tentative when evidence is incomplete.
- Facts and interpretation are distinguishable.
- No booking, posting, file creation, or external state change occurs without an explicit request.
