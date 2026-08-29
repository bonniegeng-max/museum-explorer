# 印章设计规范 stamp-design-guide.md

> 核心原则：**形制统一，纹样变化**。外壳（双线圆框 + 环绕文字 + 年代底注）永远一致，
> 只有中心纹样随展品变化——这样集齐一册才有"官方集章册"的秩序感，而不是一堆风格各异的图。
> 形制已固化为标准 SVG 结构，生成印章时**只替换中心纹样与文字**，禁止改动形制参数。

## 一、色板（仅四色，缺省朱砂）

| 代号 | 名称 | 色值 | 适用 |
|---|---|---|---|
| `cinnabar` | 朱砂 | `#C03A2B` | 缺省色，青铜/陶器/传统器物 |
| `indigo` | 黛青 | `#2F4B6E` | 书画/文书/冷调展品 |
| `ochre` | 赭石 | `#9C5333` | 木质/建筑构件/暖调展品 |
| `ink` | 玄墨 | `#2B2620` | 手稿/文献/黑白展品 |

一次展览内混用色板是允许的（像不同展区的章），但同一展品集内**不建议超过两色**。

## 二、形制参数（标准 SVG）

- 画布：`viewBox="0 0 200 200"`
- 外框：`circle r=95, stroke-width=4`；内框：`circle r=86, stroke-width=1.2`，均无填充
- 上弧文字（展品名）：沿半径 74 的上弧，`font-size 15`，字距加宽，居中
- 下弧文字（年代·馆藏地）：沿半径 74 的下弧（反向路径保证正立可读），`font-size 9.5`，居中
- 中心纹样区：圆心 (100,100)，**半径 56 以内**，传入纹样 SVG 片段（viewBox 0 0 112 112，缩放放置于 44,44）
- 字体：`font-family="'Kaiti SC','STKaiti','KaiTi',serif"`，`letter-spacing 2`
- 做旧滤镜：整体 `g` 套用"微扰 + 斑驳"双滤镜（见参考实现），使边缘不完美、印泥不均匀
- 盖章感：使用时容器加随机微旋转（-6° ~ 6°）与 88% 不透明度

## 三、参考实现（标准形制，直接复用）

```svg
<svg viewBox="0 0 200 200" width="180" height="180" role="img" aria-label="{展品名}印章">
  <defs>
    <path id="arcTop" d="M 26,100 A 74,74 0 0 1 174,100"/>
    <path id="arcBot" d="M 26,100 A 74,74 0 0 0 174,100"/>
    <!-- 下弧路径保持逆时针，使底部文字正立可读 -->
    <filter id="rough">
      <feTurbulence type="fractalNoise" baseFrequency="0.045" numOctaves="2" seed="7" result="n"/>
      <feDisplacementMap in="SourceGraphic" in2="n" scale="2.2"/>
    </filter>
    <filter id="mottle">
      <feTurbulence type="fractalNoise" baseFrequency="0.55" numOctaves="3" seed="11" result="noise"/>
      <feColorMatrix in="noise" type="matrix"
        values="0 0 0 0 1  0 0 0 0 1  0 0 0 0 1  0 0 0 1.4 -0.15" result="alphaNoise"/>
      <feComposite in="SourceGraphic" in2="alphaNoise" operator="in"/>
    </filter>
  </defs>
  <g filter="url(#rough) url(#mottle)" fill="#C03A2B">
    <circle cx="100" cy="100" r="95" fill="none" stroke="#C03A2B" stroke-width="4"/>
    <circle cx="100" cy="100" r="86" fill="none" stroke="#C03A2B" stroke-width="1.2"/>
    <text font-size="15" letter-spacing="2" font-family="'Kaiti SC','STKaiti','KaiTi',serif">
      <textPath href="#arcTop" startOffset="50%" text-anchor="middle">{展品名}</textPath>
    </text>
    <text font-size="9.5" letter-spacing="1.5" font-family="'Kaiti SC','STKaiti','KaiTi',serif">
      <textPath href="#arcBot" startOffset="50%" text-anchor="middle">{年代} · {馆藏地}</textPath>
    </text>
    <!-- 中心纹样：替换此区块，viewBox 0 0 112 112，置于 (44,44) -->
    <g transform="translate(44,44)">
      <!-- {中心纹样 SVG 片段} -->
    </g>
  </g>
</svg>
```

注意：多枚印章同页时，`id`（arcTop/arcBot/rough/mottle）必须加唯一后缀避免冲突。

## 四、中心纹样提取规则

中心纹样是印章的灵魂，从 `pattern_elements` 字段生成，规则：

1. **古物（版权安全）**：提取标志性纹样做几何化/线条化再创作——饕餮纹兽面、缠枝莲、云雷纹、线圈螺旋、齿轮辐条。用粗细一致的线条（stroke-width 4-7）表达，**宁简勿繁**：一个视觉焦点，不超过 3 层结构。
2. **当代艺术品（版权红线）**：只允许提取"元素"（色彩关系、构图骨架、材料质感），禁止复制原作形象。拿不准就抽象到"意象"级别。
3. **文字类展品**（碑帖/手稿）：取单字放大或笔画骨架。
4. 技术类展品（如电气装置）：结构示意图风格最出效果——线圈、磁力线、电路符号。

## 五、写实图像增强路线（可选，非主路线）

仅当环境具备图像生成工具**且用户明确要求写实印章**时：

1. 仍用本规范的 SVG 外壳（框+环绕文字不变）；
2. 图像生成只产出**中心纹样区**（方形图，建议提示词含"single motif, centered, plain background, ink stamp style, {pattern_elements}"）；
3. 生成图以 `<image>` 嵌入中心区，`clip-path` 裁圆，`opacity 0.9`，色相调整为色板色；
4. 生成失败或风格漂移时，自动回退 SVG 路线。

## 六、存放与命名

- 每展品一枚：`journal/{会话}/stamps/{exhibit-id}.svg`
- 印章是手帐数据的一部分，最终以字符串注入 `JOURNAL_DATA.stamps[]`（见 journal-template.html）
