---
name: OC to Swift Migrator
description: 将 Objective-C 代码迁移到 Swift，保持 UI 一致、逻辑完整，架构用 MVVM，布局 SnapKit，网络用 Swift NetworkService，类名不冲突，跳转优先 Swift 类
version: 1.0
---

# OC to Swift Migrator Skill

## 触发条件
- 用户提供 OC 代码路径（如 Modules/Profile/SubModules/Task/View）或片段
- 提到：OC → Swift 迁移、重写、转换、Swift 实现

## 核心指令（必须严格遵守项目 Rules）
1. 分析 OC 代码：提取 UI（布局、控件）、逻辑（业务、网络、交互）、Model（数据结构）。
2. 生成 Swift 版本：
   - 放在 SwiftModules/ 对应路径下
   - 类名避免冲突：加 "Swift" 前缀或后缀（如 TaskViewSwift），如果已有同名，询问用户
   - 架构：MVVM（View 轻量，ViewModel 处理逻辑，Model 纯数据 + Codable）
   - 布局：必须用 SnapKit（代码布局，禁止 Storyboard/Xib）
   - 网络：用 Swift 版本的 NetworkService（假设是 Alamofire + Combine 封装），返回 AnyPublisher
   - 跳转：优先使用对应的 Swift 类（e.g., push 到 SwiftViewController 而非 OC）
   - Model：如果有用到 OC Model，用 Swift struct/enum 重写，优先 immutable
3. 保持一致性：
   - UI 视觉/交互 100% 一致（尺寸、颜色、动画）
   - 逻辑不能丢失：delegate → closure/async、NSError → Error/Result
   - 添加防护：guard let、try-catch、避免 force unwrap
4. 输出格式：
   - 先中文解释改动点（新增/优化/潜在风险）
   - 给出完整 Swift 代码（文件头、MARK 分段、注释、常量注释）
   - 最后 diff 对比 OC 和 Swift
5. 生成新文件时：遵守文件头、添加到 Xcode 提醒、单个类 per 文件

## 自定义命令
/migrate-oc [OC 路径或代码描述]

示例：
/migrate-oc Modules/Profile/SubModules/Task/View 内容