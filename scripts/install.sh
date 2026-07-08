#!/usr/bin/env bash
# paper-buddy Skill installer
#
# 用法:
#   curl -sL https://raw.githubusercontent.com/Z4science/paper-buddy/main/scripts/install.sh | bash -s -- claude
#   curl -sL https://raw.githubusercontent.com/Z4science/paper-buddy/main/scripts/install.sh | bash -s -- codex
#   curl -sL https://raw.githubusercontent.com/Z4science/paper-buddy/main/scripts/install.sh | bash -s -- claude --project
#   curl -sL https://raw.githubusercontent.com/Z4science/paper-buddy/main/scripts/install.sh | bash -s -- codex --project
#
# 第一个参数:claude 或 codex
# 可选第二个参数:--project(装到当前目录下的项目级 skills 目录,而不是个人目录)

set -euo pipefail

REPO="Z4science/paper-buddy"
BRANCH="main"
TARGET_APP="${1:-}"
SCOPE="${2:-}"

if [[ "$TARGET_APP" != "claude" && "$TARGET_APP" != "codex" ]]; then
  echo "用法: install.sh <claude|codex> [--project]" >&2
  exit 1
fi

if [[ "$TARGET_APP" == "claude" ]]; then
  if [[ "$SCOPE" == "--project" ]]; then
    DEST="$(pwd)/.claude/skills"
  else
    DEST="$HOME/.claude/skills"
  fi
else
  if [[ "$SCOPE" == "--project" ]]; then
    DEST="$(pwd)/.codex/skills"
  else
    DEST="$HOME/.codex/skills"
  fi
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "下载 $REPO@$BRANCH ..."
curl -sL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" | tar -xz -C "$TMP"

SRC="$TMP/paper-buddy-$BRANCH/skill/paper-buddy"
if [[ ! -d "$SRC" ]]; then
  echo "错误:没有在下载的仓库里找到 skill/paper-buddy 目录,可能是分支名或仓库路径变了。" >&2
  exit 1
fi

mkdir -p "$DEST"
rm -rf "$DEST/paper-buddy"
cp -r "$SRC" "$DEST/paper-buddy"

echo "✅ 已安装到 $DEST/paper-buddy"
echo ""
if [[ "$TARGET_APP" == "claude" ]]; then
  echo "如果这是你第一次创建 skills 目录,重启一下 Claude Code 让它扫描到。"
else
  echo "如果 /skills 列表里暂时没看到,重启一下 Codex CLI 再试。"
fi
