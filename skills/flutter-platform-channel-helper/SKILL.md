---
name: Flutter Platform Channel Helper
description: 生成 Flutter 与 iOS 原生的 Platform Channel 代码（Pigeon 优先），确保类型安全、边界清晰
version: 1.0
---

# Flutter Platform Channel Helper Skill

## 触发条件
- 涉及 Flutter 与 iOS 通信、MethodChannel、Pigeon、平台通道
- 提到：Flutter、channel、MethodChannel、Pigeon、原生调用

## 核心指令
1. 优先使用 Pigeon（类型安全、自动生成代码）
2. 通道命名：com.yourcompany.app/feature/method
3. 生成结构：
   - Pigeon .proto 文件（消息定义）
   - Flutter 侧 HostApi / FlutterApi
   - iOS 侧 FlutterMethodChannel + Pigeon 生成的实现
4. 处理错误：FlutterError / NSError 统一
5. 支持异步（Future/Result）
6. 禁止硬编码路径、bundle ID
7. 强调边界：Flutter 不直接访问原生文件/Keychain，必须通过通道

## 自定义命令
/generate-channel [功能描述]

示例：
/generate-channel 从 Flutter 调用原生获取设备 token 并返回给 Flutter