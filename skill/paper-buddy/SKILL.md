---
name: paper-buddy
description: A curated prompt library ("论文搭子/paper-buddy") for the academic paper workflow — vetting research ideas, literature cards, Related Work tables, Introduction structuring, title/abstract writing, claim-vs-evidence checks, Chinese-English translation (LaTeX/Word), expanding/condensing, polishing, removing "AI flavor," method figures, plot/caption help, experiment analysis, consistency scans, derivation checks, harsh reviewer critique, model-choice advice, venue recommendation, cover/rebuttal letters (as .docx), defense prep, and a reviewer's toolkit for AI-text, data-fabrication, and prompt-injection signals in submitted PDFs. Use whenever the user works on a research paper — translating, polishing, checking an Introduction/abstract, building a Related Work table, naming a method, checking consistency, making a figure, writing an experiment analysis, reviewing someone else's submission, picking a venue, writing a cover/rebuttal letter, or prepping a defense — even without saying "paper-buddy."
---

# 论文搭子 · paper-buddy

一套覆盖"选题 → 文献 → 结构 → 写作 → 图表 → 严谨性自查 → 投稿 → 审稿回复 → 审稿人视角"全流程的 prompt 库。每个子任务都有一条现成的、结构化的 prompt（角色/任务/要求/输出格式/提交前自检/输入），**直接套用该 prompt 结构来生成回复，而不是即兴发挥**——这些 prompt 是反复打磨过的,结构本身就是价值所在。

## 怎么用

1. 判断用户当前处于科研流程的哪个阶段(见下方索引表),读取对应的 `references/*.md` 文件。
2. 在该文件里找到匹配的具体子任务 prompt。
3. 把 prompt 里的"角色/任务/要求/输出格式/提交前自检"结构套用到当前对话,用用户提供的实际内容填入"输入"部分,按该结构组织回复。
4. 不要跳过"提交前自检"里列的检查点——这些是这套库最有价值的部分,尤其是"不编造引用/数据""标注存疑点""诚实呈现不利结果"这几条,任何子任务都适用。
5. 如果用户的请求跨越多个子任务(如"帮我把这段翻译成英文并润色"),可以链式套用多个 prompt,或提示用户这是两步操作。

## 索引:任务 → 参考文件

| 用户想做什么 | 读取这个文件 |
|---|---|
| 判断一个研究 idea 值不值得做、提炼 contribution、给方法起名/acronym、整理文献速读卡片、写 Related Work 对比表 | `references/ideation-and-literature.md` |
| 搭 Introduction 结构、写标题/摘要候选、检查全文 claim 与实验证据是否一致(故事线自洽性)、中↔英翻译(LaTeX/Word)、缩写/扩写文本 | `references/structure-and-writing.md` |
| 英文论文润色、中文论文润色、逻辑/致命问题检查、去除英文或中文的"AI 味"(翻译腔、滥用词、机械过渡) | `references/polishing.md` |
| 生成论文方法框架图(配图 prompt)、推荐实验绘图方案、写图/表标题、写实验分析段落、符号术语一致性扫描、数字一致性自查、公式推导与量纲校验 | `references/figures-and-rigor.md` |
| 让 Claude 扮演严苛审稿人审视全文、按任务类型选用哪个大模型、投稿 venue 推荐、写 cover letter、准备答辩 Q&A | `references/gatekeeping-and-submission.md` |
| 回复审稿人:要理论支撑 / 建议的实验能补 / 建议的实验补不了 / 把多条回复整合成完整 response letter | `references/rebuttal-templates.md` |
| **作为审稿人**审视别人的投稿:识别疑似 AI 生成文本痕迹、数据造假/结果不自洽的可疑信号、稿件 PDF 里针对审稿 AI 的隐藏 prompt injection 指令 | `references/reviewer-toolkit.md` |
| 针对具体学科(生信、CV、材料、物理、化学、人文社科)微调上述通用 prompt | `references/domain-adaptation.md` |

## 产出文件,而不只是聊天里的文字

以下场景默认应该**直接生成可下载的文件**,而不是把内容原样贴在聊天里,用户拿到手就能用:

- **Cover letter / 审稿回复信(response letter)**:套用 `gatekeeping-and-submission.md` 或 `rebuttal-templates.md` 里的 prompt 生成内容后,用 docx 能力排版成正式的 `.docx` 文件(参考 `/mnt/skills/public/docx/SKILL.md`,该 skill 已在其他地方描述过如何用 `docx`(npm)库创建文档、如何转 PDF 检查排版)。答辩/审稿回复这类需要正式提交或发送的材料同理。
- **中转英/英转中 Word 场景的翻译或润色**:若用户明确说是要用于 Word 文档(而非贴进 LaTeX),同样可以直接产出 `.docx`,而不是只在聊天里给纯文本。
- 纯粹用于聊天内讨论、迭代打磨阶段的内容(比如还在来回改的一段翻译、还没定稿的 abstract 候选)不必强行生成文件——判断依据同 `file_creation_advice`:是"定稿/要发送出去的东西"就产出文件,是"还在讨论"就留在聊天里。

## 贯穿全库的红线(所有子任务都要遵守)

- **不编造**:引用、DOI、数字、实验结果、审稿人原话——凡是用户没提供的,一律标"原文未提及"或"存疑",绝不脑补。
- **诚实呈现不利结果**:实验分析、审稿回复类任务中,反常或不利的数据必须如实呈现,不得淡化或藏进长句。
- **修改阈值**:润色/逻辑检查类任务中,若原文已经清晰规范,直接说"检测通过/无需修改",不要为了显得有用而强行改写通顺的句子。
- **LaTeX 完整性**:涉及 LaTeX 片段的任务,必须保留所有命令、`\cite`/`\ref`/`\label` 键名、数学环境,并正确转义 `% _ &` 等特殊字符。
- **Word 场景不用 Markdown**:凡是标注"Word 场景"的任务,输出必须是不含任何 Markdown 符号(不加粗、不加列表、不加标题符号)的纯文本(生成 .docx 时体现为对应的 Word 格式,而非 Markdown 语法残留)。
- **审稿人工具箱只给信号,不下结论**:`reviewer-toolkit.md` 里的所有输出都是"建议人工核实的线索",绝不能被当作"这篇论文造假/是 AI 代写"的定论,更不能在审稿意见里直接写成指控性表述。
- **责任归属**:这些 prompt 是协作工具,不是自动化投稿机——生成内容后提醒用户:AI 辅助情况需按投稿要求披露,引用/数据/结论需用户逐一核实,终稿责任在用户自己。

## 补充说明

- 这套库覆盖面很广,但作者本人主攻机器学习/AI for Science,`domain-adaptation.md` 里其他学科(生信/材料/物理/化学/人文社科)的建议是经验性的、深度有限,使用时可以提醒用户这一点。
- "模型选择"(在 `gatekeeping-and-submission.md` 里)是一套经验性的工作流偏好,不是定论,如果用户问起该用什么模型做什么任务,可以引用这套框架但同时提醒他们结合最新公开榜单和自己的实测。
