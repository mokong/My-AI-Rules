# Doc

本目录存放 **跨项目通用** 的 AI 规则（Cursor `.mdc`）与 Skill，供各业务工程通过脚本同步。

| 路径 | 说明 |
|------|------|
| **`ai-generic/`** | 通用规则 + 通用文档 + Changelog Skill；**修改请以这里为准** |
| **`ai-generic/README.md`** | 目录说明与同步命令 |

同步到业务工程（示例）：

```bash
export AI_GENERIC_DOC="/path/to/Doc/ai-generic"
cd /path/to/业务仓库 && ./Scripts/sync-generic-ai-from-doc.sh
```
