# ai-generic（通用 Rule + Skill）

## 目录

```
ai-generic/
├── rules/           # Cursor generic-*.mdc（含 iOS 目录/栈/Flutter 集成等）
├── docs/            # IOS_DEVELOPMENT_BASE、CHANGELOG 规范（纯 MD）
├── skills/          # 按需 SKILL.md（changelog、crash、ASO、图标、迁移等）
└── sync-to-project.sh   # 可选：传入工程根路径即可同步规则与 Guides
```

### rules 一览（节选）

| 文件 | 说明 |
|------|------|
| generic-agent-interaction.mdc | 中文交互、注释与输出体量 |
| generic-code-quality.mdc | 提前返回、坏味道、重构边界 |
| generic-ios-directory-structure.mdc | Feature-first 推荐目录 |
| generic-ios-forbidden-testability.mdc | 禁止项 + 可测试性 |
| generic-ios-swift-stack.mdc | SnapKit / Alamofire / Combine（按工程选用） |
| generic-ios-objc-stack.mdc | Masonry / SDWebImage 等 OC 约定 |
| generic-flutter-ios-integration.mdc | Flutter Module 嵌入 iOS |

### skills 一览

| 目录 | 用途 |
|------|------|
| changelog-documentation | CHANGELOG / Release Notes |
| crash-analyzer | 崩溃日志分析 |
| bury-point-analyzer | 埋点对比与对齐 |
| appstore-info-generator | 商店文案与 ASO |
| app-icon-resizer-xcode | App Icon 多尺寸与 Contents.json |
| oc-to-swift-migrator | OC → Swift 迁移 |
| alamofire-service-generator | 网络 Service/Repository 模板 |
| flutter-platform-channel-helper | Pigeon / Channel |
| swiftui-component-generator | SwiftUI + ViewModel 组件 |

同步规则后，Skills 需按需拷贝到本机 Cursor（示例）：

```bash
for d in changelog-documentation crash-analyzer bury-point-analyzer appstore-info-generator \
  app-icon-resizer-xcode oc-to-swift-migrator alamofire-service-generator \
  flutter-platform-channel-helper swiftui-component-generator; do
  mkdir -p ~/.cursor/skills-cursor/$d
  cp skills/$d/SKILL.md ~/.cursor/skills-cursor/$d/
done
```

## 同步到业务仓库

**方式一**：目标业务仓库根目录已放置 `Scripts/sync-generic-ai-from-doc.sh` 时，在该根目录执行：

```bash
./Scripts/sync-generic-ai-from-doc.sh
```

环境变量 **`AI_GENERIC_DOC`** 指向本 `ai-generic` 目录；未设置时以脚本内默认值为准。

**方式二**：不依赖业务仓内脚本时，直接指定工程根路径：

```bash
export AI_GENERIC_DOC="/path/to/Doc/ai-generic"
/path/to/Doc/ai-generic/sync-to-project.sh /path/to/业务仓库
```

## 同步到 Cursor 用户级 Skills（可选）

```bash
mkdir -p ~/.cursor/skills-cursor/changelog-documentation
cp skills/changelog-documentation/SKILL.md ~/.cursor/skills-cursor/changelog-documentation/
```

## 修改流程

1. 只编辑 **本目录**下文件。  
2. 在依赖该通用的各工程中 **运行同步脚本** 后提交。

## 可执行权限

若 `sync-to-project.sh` 无法直接执行，请：`chmod +x sync-to-project.sh`
