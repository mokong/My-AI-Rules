---
name: App Icon Resizer & Xcode Importer
description: 将 1024x1024 App Icon 裁剪成 Xcode 所需的所有尺寸，并指导添加到 Assets.xcassets
version: 1.0
---

# App Icon Resizer & Xcode Importer Skill

## 触发条件
- 用户提到：App Icon 裁剪、图标尺寸、1024x1024 转 Xcode、添加到 Assets.xcassets
- 提供了 1024×1024 的原图（或描述要处理）

## Path Resolution
- 首先，检查当前对话上下文或询问用户项目根路径。
- 如果用户输入了路径，请将该路径作为 `filesystem` 操作的 base 目录。

## 核心指令（必须严格遵守）
1. **Prepare**: 确认原图路径。
2. Xcode App Icon 标准尺寸（iOS 2026 年最新规范，包含所有常见 slot）：
   - 1024x1024 (App Store)
   - 180x180, 120x120, 152x152, 167x167 (iPad)
   - 60x60@3x (180x180), 60x60@2x (120x120) 等
   - 完整列表（必须全部生成命令）：
     1024x1024, 512x512, 256x256, 180x180, 167x167, 152x152, 120x120, 80x80, 76x76, 58x58, 40x40, 29x29, 20x20
     （含 @2x / @3x 变体）

3. 处理步骤：
   - 假设原图路径为：Assets/AppIcon-1024.png（用户可替换）
   - 使用 macOS 自带 sips 命令（无需额外安装）批量裁剪
   - 或生成 ImageMagick 命令（如果用户已安装）
   - 输出所有尺寸的裁剪命令
   - 文件命名规范：icon_20x2x.png, icon_60x3x.png 等。

4. 输出并保存：
   - 调用 `filesystem` MCP 将图片保存到 `Assets.xcassets/AppIcon.appiconset/` 目录下。
   - **核心步骤**：自动重写该目录下的 `Contents.json` 文件，确保 JSON 里的 "filename" 与生成的图片名称一一对应。

## Constraints
- 必须保持图片比例，不能拉伸。
- 必须确保 Contents.json 格式正确，否则 Xcode 会报错。

## 自定义命令

执行图标处理 Skill。路径是：xxx/Assets.xcassets/AppIcon.appiconset ，原图是桌面的 1024.png。

## 示例输出（Agent 参考）
**所需尺寸表格：**

| 尺寸       | 倍率 | 建议文件名                  | 用途              |
|------------|------|-----------------------------|-------------------|
| 1024×1024  | 1x   | AppIcon-1024.png            | App Store         |
| 180×180    | @3x  | AppIcon-60x60@3x.png        | iPhone 主图标     |
| 120×120    | @2x  | AppIcon-60x60@2x.png        | iPhone Spotlight  |
| ...        | ...  | ...                         | ...               |
