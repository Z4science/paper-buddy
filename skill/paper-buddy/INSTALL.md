# 怎么在 Claude Code / Codex CLI 里用这个 Skill

这个 `.skill` 文件本质就是一个 zip 包,里面是一个标准的 `paper-buddy/` 文件夹(`SKILL.md` + `references/*.md`)。不同的 agent 工具都是靠"把这个文件夹放到它会扫描的目录里"来识别 Skill 的,区别只是放哪个目录、要不要重启。

---

## 一、Claude Code

Claude Code 会自动扫描两类目录里的 Skill,不需要额外配置,识别到就会在合适的时机自动使用。

### 装成"个人 Skill"(所有项目里都能用)

```bash
mkdir -p ~/.claude/skills
unzip paper-buddy.skill -d ~/.claude/skills/
```

装完应该是这样的结构:

```
~/.claude/skills/paper-buddy/
├── SKILL.md
├── README.md
└── references/
    └── ...
```

### 装成"项目 Skill"(只在这个仓库里生效,可以随仓库一起提交给协作者)

在你的论文/项目仓库根目录下:

```bash
mkdir -p .claude/skills
unzip paper-buddy.skill -d .claude/skills/
```

这样团队里其他人 clone 这个仓库、用 Claude Code 打开时,也会自动拥有这个 Skill,不需要每人单独装一次。

### 怎么触发

不需要任何特殊语法,正常聊天就行,Claude Code 会根据 `SKILL.md` 里的 `description` 自动判断要不要用。比如直接说:

```
帮我把这段中文摘要翻译成英文投 NeurIPS
帮我看看这段审稿意见,写个回复
```

如果想明确指定("我知道我要用这个 Skill,别让它自己猜"),可以直接说:

```
用 paper-buddy 这个 skill,帮我写投稿 cover letter
```

### 注意事项

- **改动 `SKILL.md` 里的文字**(比如你自己调整了某条 prompt),同一个 Claude Code 会话里马上生效,不用重启。
- 但如果是**第一次新建** `~/.claude/skills/` 或 `.claude/skills/` 这个顶层目录(之前完全没有),需要重启 Claude Code 才能被扫描到。
- 用 `/plugin` 之类的机制安装的是"插件里打包的 Skill",这个不是插件,直接放文件夹就行,不用走 `/plugin install`。

---

## 二、Codex CLI(OpenAI)

Codex 对 Skill 的支持和 Claude Code 是同一套开放规范(agentskills.io 定义的 SKILL.md 格式),所以文件夹内容完全不用改,只是放的目录名不同。

### 装成"个人 Skill"

```bash
mkdir -p ~/.codex/skills
unzip paper-buddy.skill -d ~/.codex/skills/
```

### 装成"项目 Skill"

在项目根目录:

```bash
mkdir -p .codex/skills
unzip paper-buddy.skill -d .codex/skills/
```

### 怎么触发

- **隐式触发**:正常提问,Codex 会根据 `SKILL.md` 的 description 自动判断是否要用,和 Claude Code 一样。
- **显式触发**:在 CLI 里输入 `$` 可以唤出 Skill 选择,或者直接 `/skills` 查看已安装的 Skill 列表,手动选 `paper-buddy`。

### 注意事项

- Codex **检测到新安装的 Skill 通常是自动的**;如果装完之后 `/skills` 列表里没看到,重启一次 Codex 再试。
- 如果你用的 Codex 版本比较早,可能需要加 `--enable skills` 参数启动才能开启 Skill 功能(这是早期实验阶段的开关,新版本大多已经不需要了),比如:
  ```bash
  codex --enable skills
  ```
  具体以你本地 `codex --help` 里的说明为准,Codex 的 Skill 功能还在比较快的迭代期。
- Codex CLI 支持一个额外的可选文件 `agents/openai.yaml`,可以给 Skill 加 UI 名称、图标、声明依赖的 MCP 工具——这是 Codex 专属的,这个包里没有加,不影响使用,纯粹是可选的锦上添花。

---

## 三、两边都要用怎么办

不用复制两份、也不用改内容,直接在两个目录各放一份就行(或者用软链接省一份磁盘空间):

```bash
mkdir -p ~/.claude/skills ~/.codex/skills
unzip paper-buddy.skill -d ~/.claude/skills/
cp -r ~/.claude/skills/paper-buddy ~/.codex/skills/paper-buddy
# 或者用软链接,改一份两边同步:
# ln -s ~/.claude/skills/paper-buddy ~/.codex/skills/paper-buddy
```

`SKILL.md` 的格式在两边是完全一样的,不需要为了兼容某一方而改内容。

---

## 四、claude.ai 网页版/App(不需要命令行)

如果你只是想在 claude.ai 网页版或桌面/手机 App 里用,不涉及 Claude Code/Codex 这种命令行工具:

1. 打开 claude.ai,进入 **设置(Settings) → Features**
2. 找到 "Custom Skills" 或类似入口,上传 `paper-buddy.skill` 这个 zip 文件
3. 需要账号开启了 Code execution 功能,且是 Pro/Max/Team/Enterprise 计划

这个入口的具体位置和名称可能随版本更新变化,如果找不到,可以在设置里搜索"skill"关键词,或参考 Claude 帮助中心当时的最新说明。
