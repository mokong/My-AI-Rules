---
title: "Rules、Skills、Subagents、MCP 是什么"
date: 2026-01-29
tags: [iOS, 分享]
---

## 背景

起初是打算写一篇 Rules 相关的备份文章，写着写着，想到自己虽然天天使用 AI 编程工具，包括Cursor、Kiro、Angravity、Trae、Codebuddy 等等，但是对于 这些工具中 相关的 Rules、Skills、Subagents、MCP的概念并不清楚；使用也仅限于了在 Agent 中发送一句，让 AI 执行；有时候好多重复的限定条件的指定还单独用记事本保存，怎么说呢，只用到了 这些工具 1% 的功能。。。

所以我写的过程中也在结合自己的实际情况，分析如何更好的使用 AI 开发工具。

<!--more-->

看完这篇文章，会对Rules、Skills、Subagents、MCP有基本的了解，知道都是什么，分别合适在什么时候用，以及怎么用。

Ps：作为一个 iOS 开发，语言有 OC、Swift、SwiftUI、Flutter，所以 Rules 也是偏向这些的；下面文章中使用 Cursor 来说明如何设置，其他的工具都大致一样。


## 开始

### Rules

#### Rules 是什么，为什么要用 Rules？

Rules 就是给 AI 设计的标准，可以理解为 AI 需要遵守的规则；

为什么需要设置 Rules？如果没有 Rules，AI 回复可能就不那么准确，每次回复的可能不一致；通过设置 Rules 让 Agent 会更“听话”、更懂规矩，生成代码质量和一致性提升。

#### Rules的有哪些

知道了 Rules 是什么，再来看 Rules 的类型，Rules 有 Project Rules、User Rules、Team Rules，区别是什么？

| 类型          | 存放位置                        | 作用范围       | 是否版本控制   | 优先级 | 适合放什么内容                                             | 典型使用场景                               |
| ------------- | ------------------------------- | -------------- | -------------- | ------ | ---------------------------------------------------------- | ------------------------------------------ |
| Team Rules    | Cursor Dashboard                | 整个团队/组织  | 否（云端）     | 最高   | 公司级强制规范、安全要求、统一架构原则                     | 大中型团队、企业必须统一风格、安全合规     |
| Project Rules | 项目根目录(.cusror/rules/*.mdc) | 当前 git 仓库  | 是（git 共享） | 中等   | 项目专属架构、目录结构、技术栈约束、命名规范、特定文件规则 | 几乎所有中大型项目、monorepo、多人协作项目 |
| User Rules    | Cursor 设置-> Rules             | 你本机所有项目 | 否（个人）     | 最低   | 个人写作风格、回复语气、通用偏好（简洁/中文/英文等）       | 个人习惯、跨项目通用的小偏好               |

通过上图可以知道，Team Rules 只有管理员有权限，而且是在云端设置，所以不需要考虑；我们要同步的 Rules 其实应该是属于 User Rules 和 Project Rules；而且大部分是 User Rules即我们编程中的个人习惯和偏好；Project Rules 也可以部分同步，比如同类型的项目（比如：都是Swift 开发的 iOS 项目）。

所以我的设置大部分内容在 User Rules，Project Rules 拆分不同文件来约束，如下图：

![](https://raw.githubusercontent.com/mokong/BlogImages/main/img/20260129175335855.png)

与（范海伦乐队合同里“禁止棕色M&M巧克力豆”条款用来检查场地是否遵守了合同里的安全标准。要是有棕色M&M巧克力豆，那就是他们没遵守的标志）这个同理。怎么判断 AI 没有按照 Rules 生成，在 Rules 里添加一个每次完成输出指定的短语的规则，如果某次调用没有输出，说明 AI 本次没有按照 Rules 输出，可能是上下文太长该另起一个窗口了。

比如我设置的是“报告长官，我已遵守所有规则，请查验“

如下图：

![](https://raw.githubusercontent.com/mokong/BlogImages/main/img/20260129175235214.png)


#### Rules的使用

所有设置放在[My AI Ruels](https://github.com/mokong/My-AI-Rules)下，使用方式如下：

Cursor:
设置 ProjectRules：在 Finder 上右键，选择前往文件夹，输入`~/.cursor/`，在文件夹下新建 rules 文件夹，然后把 project_rules 的内容拷贝进去；
设置 UserRules：选择 Cursor -> 设置 -> Cursor Settings（如下图），然后选择`Rules, Skills, Subagents`，在 Rules 下点击新增，把user_rules.mdc中内容拷贝进去即可。

![](https://raw.githubusercontent.com/mokong/BlogImages/main/img/20260129202939921.png)
![](https://raw.githubusercontent.com/mokong/BlogImages/main/img/20260129203039192.png)

每次看到下面的文字，就知道 AI 遵守了规则
![](https://raw.githubusercontent.com/mokong/BlogImages/main/img/20260130141433211.png)


### Skills

#### Skills 是什么？

Cursor 的 Skills 是 Agent 模式（Composer 的 Agent tab，或直接用 @agent /cmd + . 调用）下的一个强大扩展机制。它允许你给 AI Agent 赋予特定领域的专业知识、工作流、自定义命令或脚本，让它在处理特定任务时更专注、更高效。
Skills 不是全局规则（不像 Rules 那样每次都强制加载），而是动态加载：只有当 Agent 认为当前任务相关时，才会自动或手动触发 Skills。

#### Skills 的主要作用

- 封装领域专精：如“iOS 崩溃日志分析专家”、“SwiftUI → UIKit 迁移助手”、“单元测试生成器”等。
- 支持自定义命令：在 Agent 输入框用 / 触发，比如 /analyze-crash 或 /generate-tests。
- 可以包含提示词模板 + 可执行脚本（如 bash、Python 小工具）。
- 便于复用和分享：Skills 可以放在项目里的 .cursor/skills/ 目录下，随 git 共享

#### 为什么封装成 Skills？

- 重复性强：某些频繁使用 的 Prompt 描述了固定的工作流（如 OC → Swift 迁移、埋点检查、逻辑同步），Skills 可以打包提示词 + 规范，确保每次执行都遵守项目 Rules（MVVM、SnapKit、网络层等）。
- 与 Rules 互补：Skills 专注“如何执行特定任务”，而 Rules 是全局约束。
- 使用便利：在 Agent 中用 /命令 或自然语言触发，避免每次手动复制 Prompt。

#### 什么时候开始用 Skills？
- Rules 已经很完善，但某些任务总是需要反复写长提示 → 封装成 Skill。
- 想让 Agent 在特定领域（如崩溃、测试、迁移）更专业 → Skills。
- 项目团队多人协作，想统一某些工作流 → 把 Skills 放进 git。

以我个人来说，我在慢慢把 OC 的项目改为 Swift 的项目，需要迁移很多类，之前的写法是，每次都是一长串 Prompt，大致如下：

```

请把Modules/Profile/SubModules/Business/View内容用Swift实现，如果有用到的model用Swift重新实现，放在SwiftModules下；要求类名不能冲突，UI一致，逻辑不能丢失，架构用MVVM，布局用Snapkit，接口使用Swift版本的NetworkService；跳转子界面优先使用对应的Swift类

```

由于我是一个文件夹一个文件夹来的，所以每次都需要输入上面的一串 Prompt，这样的就可以定义成 一个Skill，如下：

```
---
name: migrate-oc
description: 将 Objective-C 代码迁移到 Swift，保持 UI 一致、逻辑完整，架构用 MVVM，布局 SnapKit，网络用 Swift NetworkService，类名不冲突，跳转优先 Swift 类
version: 1.0
---

# OC to Swift Migrator Skill

## 触发条件
- 用户提供 OC 代码路径（如 Modules/Profile/SubModules/Business/View）或片段
- 提到：OC → Swift 迁移、重写、转换、Swift 实现

## 核心指令（必须严格遵守项目 Rules）
1. 分析 OC 代码：提取 UI（布局、控件）、逻辑（业务、网络、交互）、Model（数据结构）。
2. 生成 Swift 版本：
   - 放在 SwiftModules/ 对应路径下（e.g., SwiftModules/Profile/SubModules/Business/View）
   - 类名避免冲突：加 "Swift" 前缀或后缀（如 BusinessViewSwift），如果已有同名，询问用户
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
/migrate-oc Modules/Profile/SubModules/Business/View 内容

```

使用如下，简单明了

```

/migrate-oc Modules/Profile/SubModules/Business/View

```

![埋点Skills](https://raw.githubusercontent.com/mokong/BlogImages/main/img/20260129212849415.png)

#### 管理与分享 Skills

项目内 Skills：放在 .cursor/skills/
- 每个 Skill 是一个独立的子文件夹
- 子文件夹名字建议用英文、kebab-case 或 snake_case，便于阅读和排序。
- 每个子文件夹里至少有一个 SKILL.md 文件（这是 Cursor 识别 Skill 的核心文件）。
- 可以有多个文件，如下图
  
  ![](https://raw.githubusercontent.com/mokong/BlogImages/main/img/20260129210905938.png)

添加之后，重启 Cursor，在 Cursor 的设置中能看到，如下图：

![](https://raw.githubusercontent.com/mokong/BlogImages/main/img/20260129211257115.png)


### Subagents

#### 什么是 Subagents

Subagents 是 Cursor 中 Agent 模式（也就是 Composer 的 Agent tab，或者用 @agent 调用的那个 AI）里面的一种分工协作机制。
简单来说：
当一个任务比较复杂、涉及多个专业领域、需要不同视角反复校验，或者单纯靠一个 AI 容易遗忘/混淆细节时，
主 Agent 可以临时创建多个子 Agent（SubAgents），每个子 Agent 专注于一个特定角色或子任务，最后再由主 Agent 汇总结果。

#### SubAgents 的核心特点

| 项目 | 说明 | 
| ------------- | ------------------------------- | 
| 谁创建 | 通常由主 Agent 自己决定创建（也可以由用户手动指定） | 
| 存在时间 | 只存在于当前会话（关闭 Composer 或新开会话就没了） | 
| 能力范围 | 每个 SubAgent 继承主 Agent 的全部上下文（Rules、Skills、打开的文件等），但可以被赋予不同的“人格/指令” | 
| 通信方式 | 主 Agent ↔ SubAgent 通过消息传递（类似群聊） | 
| 典型数量 | 2～6 个（太多会 token 爆炸，效果反而下降） | 
| 手动还是自动 | 两者都支持（用户可以直接说“创建三个 SubAgent：架构师、安全专家、测试专家”） | 

与 Skills 的区别：
Skills：静态的“能力包/提示模板”，适合重复任务。
SubAgents：动态的“临时团队成员”，适合复杂、多阶段、需要多视角的任务。

#### 什么时候应该使用 SubAgents？

| 场景类型 | 是否推荐用 SubAgents | 为什么用它比单 Agent 好 | 不用 SubAgents 的替代方案 | 
| ------------- | ------------------------------- | ---------------- | ---------------- |
| 非常复杂的重构/迁移任务 | 强烈推荐 | 可以分阶段、分角色把控质量，避免遗漏 | 多次手动提示 + 反复检查
| 需要多角度审查的代码 | 强烈推荐 | 安全、性能、可读性、规范性可以分别交给不同专家 | 自己写长提示要求多轮自审
| 架构设计 + 实现 + 测试全流程 | 推荐 | 架构师先出方案 → 实现者写代码 → 测试者写用例 → 架构师再 review | 分多次对话，容易上下文丢失
| 简单写代码、改 bug | 不推荐 | 没必要 | 单 Agent 更快 | 直接用 Rules + Skills
| 日常小任务 | 不推荐 | 增加复杂度，反而慢 | —

举例来说，我的 OC -> Swift 项目迁移，想要使用 Subagent 的话就需要如下指令：
> 请把整个 Modules/Profile 模块迁移到 SwiftModules/Profile，要求 UI 一致、逻辑完整、埋点不能丢失、用 MVVM + SnapKit + NetworkService。请使用 SubAgents 协作完成。


当然也可以指定创建几个 Subagent，比如：

```

请创建以下三个 SubAgents 来迁移 Modules/A 模块到 SwiftModules/B，确保 UI 完全一致、逻辑不丢失、埋点不缺失，使用 MVVM + SnapKit + NetworkService。

1. Planner SubAgent：分析结构、规划文件映射、风险评估。
2. Converter SubAgent：逐文件转换代码。
3. Reviewer SubAgent：检查一致性、完整性、规范。

所有 SubAgents 并行运行，使用 worktrees 隔离变更。

```

而如果不通过 Subagent，在迁移后，就会手动让 AI 再 check 逻辑和埋点是否有丢失。。。这也是为什么会有上面的那个埋点 skill（😂）

### MCP

#### MCP 到底是什么？（简单一句话）

在 Cursor（以及其他支持该协议的编辑器）中，MCP 代表 Model Context Protocol（模型上下文协议）。
简单来说，它是一种开放标准，旨在让 AI 模型能够安全、统一地访问外部数据和工具。你可以把它想象成 AI 的“USB 接口”或“插件系统”。

| 机制 | 主要作用 | 示例 | 
| ---- | -------- | -------- | 
| Rules | 强制/指导 AI 的行为风格、规范、禁止事项 | 必须 MVVM、禁止 force unwrap |
| Skills | 给 AI 特定角色/工作流（提示词模板）| “崩溃日志分析师 Skill” |
| Subagents | 会话内临时分工（主 Agent 调用子 Agent）| 主 Agent → 安全子 Agent |
| MCP | 连接外部真实世界工具/数据（数据库、API、文件系统等）| 查询数据库、读 Sentry 日志、改 GitHub issue |

#### MCP 是什么时候用？

当你希望 AI 不只是聊天/生成代码，而是能主动访问实时数据、执行操作时，就用 MCP。
典型触发词：数据库查询、实时日志分析、外部 API 调用、项目结构自动理解、企业工具集成。
不需要 MCP 的场景：纯代码规范、风格约束、架构指导 → 还是靠 Rules + Skills。


说起来 MCP 其实在 X 上是被提到功能最强大的，但是对于我个人来说，在写这篇之前，没有主动去配置 MCP 实现某个功能，所以在这里我仔细想了一下，作为一个移动端开发，有哪些功能是可以通过 MCP 实现的？

首先公司项目中，被动触发的，比如修改某个问题时，一直改不好，直接告诉 agent，请搜索后回答，就会触发搜索（算是使用到了 MCP）。
然后是个人开发 APP 时，有哪些功能是可以通过 MCP 来实现：
我想到的有下面两个场景，
1. 开发的 APP，生成商店描述和关键词时（我每次是让 AI 分析 APP 功能，结合商店同类型 APP，给出建议的商店描述和关键词）；所以这一步需要搜索网络上的数据，可以通过配置 MCP 来实现。
2. 开发的 APP，图标的处理（每次是生成一个 1024 的图标，然后在线找一个裁剪网站，裁剪下载，拖拽到项目里）；这一步也是需要外部工具处理的，也可以通过配置 MCP 来实现。

下面就以 APP 图标的处理为例，说下 MCP 的配置和使用：

打开 Cursor 的设置，找到 Tools & MCP，然后点击添加 MCP Server，如下图

![](https://raw.githubusercontent.com/mokong/BlogImages/main/img/20260130161534148.png)

跳转到了mcp.json 的编辑界面，添加如下MCP Server：

> 通过 @modelcontextprotocol/server-filesystem，AI 可以读取你的 1024px 原图，调用系统命令进行裁剪，并直接把生成的图片写入到 Xcode 的 .appiconset 文件夹中。

``` 

{
  "mcpServers": {
    "filesystem": {
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "."
      ],
      "command": "npx"
    }
  }
}

```

然后配置 Cursor Skill，为了一键生成，增加一个 Skill，让 AI 知道裁剪的标准，Skill 内容如下：

``` markdown
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

```

然后我打开了一个本地的 Mac APP 项目，删除了 Assets 的图标，把 1024 的图片放到桌面，然后 Cursor 执行，输入指令，一键检测当前项目，生成了所需的所有图标，如下图：

![](https://raw.githubusercontent.com/mokong/BlogImages/main/img/20260130160115874.png)


## 总结

到这里，对 Rules、Skills、Subagents、MCP 应该都有了初步的理解，这里再来总结回顾下：

- Rules是基准，必需品，建议都要设置，如果说不设置 Rules，那说明你还不会使用 AI 开发工具。
  - Rules 有三种Team Rules、Project Rules、User Rules；
  - Team Rules优先级最高，在云端设置；一般人设置不了。
  - Project Rules，在`~/.cursor/rules`下，是项目专属架构、目录结构、技术栈约束、命名规范、特定文件规则
  - User Rules，在 Cursor Settings中设置，是个人的习惯、偏好、风格。（注意范海伦乐队合同里“禁止棕色M&M巧克力豆”规则的使用）
- Skills 是封装可复用的提示词模板，或者领域专精模板；简单的说，都 AI 时代了，每次还一段一段重复的提示词输入，说明用的不专业。。。
- Subagents，如果说 Skills 是单个领域专精，那么 Subagents 就是找多个领域专家协同，（待确认实际效果，我还未真正使用过）
- MCP，项目访问外部工具或数据时使用。至于具体用来做什么，要结合实际。

### 写在最后

前几天听播客，听到一个观点，现在 AI 这么发达了，什么样的事情适合让 AI来做？采访者的回答是，工作或生活中，一周重复 5 次以上的事情，就应该尝试通过 AI 来处理，或者部分处理。

再结合我自己，开发不同 APP 的过程中，商店名字生成、商店描述生成、APP图标处理，这些都是重复做的，所以可以试着交给 AI 来处理。处理公司项目的过程中，从 OC迁移每个模块到 Swift、排查埋点问题、排查崩溃问题，这些需要一直做的，也应该交给 AI 来处理。

AI 把我们从繁杂的、重复的劳动中释放出来，不仅仅是一句空话。


