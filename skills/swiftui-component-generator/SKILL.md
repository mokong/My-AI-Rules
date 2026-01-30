---
name: SwiftUI Component Generator
description: 根据描述快速生成符合 MVVM + 现代 SwiftUI 规范的组件（View + ViewModel）
version: 1.0
---

# SwiftUI Component Generator Skill

## 触发条件
- 用户要求生成 SwiftUI View、组件、表单、卡片、列表项等
- 提到：SwiftUI、View、@Observable、NavigationStack 等

## 核心指令
1. 始终使用最新 SwiftUI 特性（iOS 17+ 优先）：
   - @Observable 而非 ObservableObject + @Published（除非兼容旧版）
   - NavigationStack / NavigationSplitView
   - @Bindable、Observation
2. 结构严格：
   - 文件头：遵守项目文件头格式
   - // MARK: - Properties
   - // MARK: - Body / init
   - // MARK: - UI 构建
   - // MARK: - Actions / 业务逻辑（放 ViewModel）
   - 每个 public 方法 / 属性加 /// 文档注释
   - 常量加注释
3. View 保持极简：
   - 只负责 UI + 交互
   - 所有状态通过 @Bindable / @Environment / ViewModel 注入
   - 禁止在 View 中写网络/业务逻辑
4. 生成 ViewModel 时：
   - 用 @Observable class 或 struct
   - 处理 loading/error/empty 状态
   - 支持 async/await
5. 布局使用原生 modifier，必要时建议 GeometryReader / Layout

## 自定义命令
/generate-swiftui [描述]

示例：
/generate-swiftui 一个带搜索框、列表、加载状态的联系人页面，支持下拉刷新