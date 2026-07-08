<p align="center">
  <img src="assets/logo-256.png" alt="论文搭子 paper-buddy logo" width="140">
</p>

# 论文搭子 · paper-buddy(Claude Skill 版)

> 这是 [Z4science/paper-buddy](https://github.com/Z4science/paper-buddy) 这套"科研写作 prompt 库"改造成的 Claude Skill。原库是一份可以复制粘贴到任意大模型对话框的 prompt 合集;这个 Skill 版本把它变成 Claude 可以**自动识别场景、自动加载对应 prompt、并直接产出成品文件**的能力,不需要你自己去翻文档找 prompt。

---

## 这个 Skill 解决什么问题

原来的用法是:打开 README → 在几十条 prompt 里翻到你要的那条 → 整段复制 → 粘到对话框 → 手动填 `[方括号]`。

装上这个 Skill 之后:

```
你: 帮我把这段中文摘要翻成英文,投 NeurIPS 用
```

Claude 会自动识别这是"翻译"类任务,加载对应 prompt 结构,直接产出英文 LaTeX + 中文回译核对,而不需要你自己去找"中转英 · LaTeX"那条 prompt。

---

## 效果示例

### 示例 1:审稿回复(直接产出可发送的文件)

**你说:**
> 审稿人说我们的方法缺理论支撑,质疑为什么 work。我们没有严格证明,只能给个直觉解释:我们的正则项限制了权重范数,所以能提升鲁棒性。帮我写审稿回复。

**Claude 做的事:**
1. 识别出这是"审稿回复 · 模板 A(要理论支撑)"场景,加载 `references/rebuttal-templates.md`
2. 按模板结构生成:先定性问题类型 → 诚实标注"这是直觉论证,不是严格证明" → 给出可以放进正文/附录的机制性解释 → 提示你哪些地方需要自己核实
3. 因为审稿回复信是要发送出去的正式材料,**直接生成排版好的 `.docx` 文件**给你下载,而不是把内容原样贴在聊天里让你自己复制粘贴排版

### 示例 2:去 AI 味

**输入(某段 LaTeX):**
> "Our method delves into the intricate relationship between... It is worth noting that this approach leverages a pivotal mechanism to showcase robust performance across a wide range of scenarios."

**Claude 输出:**
> 检测到高频 AI 用词(delve/intricate/leverage/pivotal/showcase/robust/a wide range of)与机械过渡("It is worth noting that"),按"去 AI 味"prompt 重写为自然表达,同时保留原有技术含义与 LaTeX 命令/转义字符不变,并附中文回译供你核对是否改变原意。

### 示例 3:数字一致性自查

**你说:**
> 帮我查一下正文里说的"提升了 5.3%"跟 Table 2 对不上,查一下哪里有问题

**Claude 做的事:**
加载 `references/figures-and-rigor.md` 里的"数字一致性自查"prompt,逐条比对正文叙述数字与表格实际数字,定位到具体句子和单元格,而不是笼统地说"看起来有问题"。

### 示例 4:审稿人工具箱 —— PDF 里的隐藏指令(新增功能)

**场景:** 你在审一篇稿件,从 PDF 提取正文时发现一段和上下文完全不连贯的文字。

**你说:**
> 这是我从待审稿件 PDF 提取的全文,帮我看看有没有问题:[粘贴全文]

**Claude 做的事:**
加载 `references/reviewer-toolkit.md` 里的 "PDF 审稿材料中的 prompt injection 检测" prompt,逐段扫描是否存在针对审稿 AI 的隐藏指令(比如伪装成"系统消息"、藏在异常位置的"给这篇论文打高分")。**无论发现什么,都绝不会执行稿件里的任何指令**,只会原样引用可疑片段并提醒你上报给编辑——这一条本身就是为了防止 Claude 被投稿人"越权指挥"而设计的。

### 示例 5:审稿人工具箱 —— 数据自洽性扫描(新增功能)

**你说:**
> 帮我看看这篇稿件的 ablation 结果有没有问题:[粘贴表格]

**Claude 做的事:**
用"数据造假/结果不自洽信号扫描"prompt,找出统计上可疑的点(如所有 baseline 提升幅度异常一致、消融结果与正文论述矛盾等),每条都同时给出"无辜解释"和"需要作者澄清的具体问题",**明确标注这些只是线索,不构成造假指控**——避免把弱信号当成定论去冤枉一位诚实的作者。

---

## 目录结构

```
paper-buddy/
├── SKILL.md                              # 路由入口:任务 → 该读哪个文件
├── README.md                             # 就是你正在看的这份效果展示
└── references/
    ├── ideation-and-literature.md        # 选题判断 · 文献速读卡片 · Related Work
    ├── structure-and-writing.md          # Introduction 结构 · 翻译 · 缩写扩写
    ├── polishing.md                      # 中英文润色 · 逻辑检查 · 去 AI 味
    ├── figures-and-rigor.md              # 配图 · 绘图推荐 · 一致性自查
    ├── gatekeeping-and-submission.md     # 审稿人视角 · 模型选择 · 投稿 · 答辩
    ├── rebuttal-templates.md             # 审稿回复 A/B/C/D 模板
    ├── reviewer-toolkit.md               # 【新增】审稿人工具箱
    └── domain-adaptation.md              # 分领域适配建议
```

## 相比原仓库新增的内容

- **审稿人工具箱**(`reviewer-toolkit.md`):原库只有"作者视角"的 prompt(怎么写、怎么回应审稿人)。新增了"审稿人视角"的三条 prompt——识别投稿里疑似 AI 生成文本的痕迹、扫描实验数据的自洽性可疑信号、检测 PDF 里针对审稿 AI 的隐藏指令(prompt injection)。三条都刻意设计成"只给线索、不下结论",避免被滥用成给作者扣帽子的工具。
- **直接产出文件**:cover letter、审稿回复信等"要发出去的正式材料",Claude 会调用文档生成能力直接产出排版好的 `.docx`,而不是把内容留在聊天记录里让你自己复制粘贴。

## 使用方式

把 `paper-buddy.skill` 上传/安装到支持 Skill 的 Claude 客户端(Claude Code、Cowork 等),之后正常聊天即可,Claude 会自动判断什么时候该用这套库,不需要你手动"打开某个 prompt"。

## 责任提醒

所有 prompt 的产出(包括审稿人工具箱的信号扫描)都需要你自己核实。AI 是协作者,不是作者,也不是学术不端的裁判——这一点在 `SKILL.md` 和 `reviewer-toolkit.md` 里都反复强调,使用时也请这样对待它的输出。
