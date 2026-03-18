#!/usr/bin/env bash
# 将 ai-generic 规则与文档同步到指定工程根目录。
# 用法: ./sync-to-project.sh /path/to/project

set -e
SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="${1:?用法: $0 <工程根目录>}"
if [[ ! -d "$DEST" ]]; then
  echo "错误: 目录不存在: $DEST" >&2
  exit 1
fi
mkdir -p "$DEST/.cursor/rules" "$DEST/Docs/Guides" "$DEST/.claude/skills"
cp "$SRC/rules/"*.mdc "$DEST/.cursor/rules/"
cp "$SRC/docs/IOS_DEVELOPMENT_BASE.md" "$DEST/Docs/Guides/"
cp "$SRC/docs/CHANGELOG_AND_DOCUMENTATION_GUIDE.md" "$DEST/Docs/Guides/"
# 工程内 .claude 入口：路径指向 Docs/Guides（与仓库内一致）
cat > "$DEST/.claude/skills/changelog-documentation-guide.md" << 'INNER'
# Changelog 与文档规范（发版/写说明时启用）

## 何时使用

- 编写或整理 **CHANGELOG**、**Release Notes**、**发版说明**、**对外 API 文档** 时。
- 日常功能开发、改业务代码**不必**默认套用全文；需要时用本 Skill 唤起。

## 怎么做

1. 打开并遵循 **`Docs/Guides/CHANGELOG_AND_DOCUMENTATION_GUIDE.md`**（由 `Doc/ai-generic` 同步）。
2. 与 antd 类规范对齐时：API 命名、组件文档结构等以 **项目自有 Wiki** 为准。

## Rule 与 Skill 分工

- **Skill（本页）**：承载「何时用 + 指向完整规范」。  
- **Rule**：仅需一句「发版更新 CHANGELOG，格式见上述 Guide」即可。
INNER
echo "已同步到: $DEST"
