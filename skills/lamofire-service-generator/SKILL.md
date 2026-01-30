---
name: Alamofire Service Generator
description: 根据 API 需求快速生成符合项目规范的 Alamofire + Combine 的网络 Service 层代码（Repository 风格）
version: 1.2
---

# Alamofire Service Generator Skill

## 触发条件
- 用户提供 API 文档、接口描述、URL、参数、响应模型等
- 提到：Alamofire、Combine、网络请求、Service、Repository、API client
- 需要生成：网络层代码、请求封装、错误处理、响应解析

## 项目规范约束（必须严格遵守）
- 使用 Alamofire 5.x+
- 响应式编程必须使用 Combine（Publisher / AnyPublisher）
- 统一错误处理：使用自定义 AppError enum（符合 Error & LocalizedError）
- 所有请求封装在 Repository / Service 类中
- ViewModel / View 禁止直接调用 Alamofire
- 支持 mock（通过 protocol + dependency injection）
- 必须有单元测试友好设计（可注入 URLSession / Session）
- 文件头、MARK 分段、注释、常量注释、无棕色M&M 测试 全部遵守 User Rules & Project Rules

## 生成代码结构（强制顺序）
1. 文件头（遵守项目格式）
   //
   //  XXXService.swift
   //  TargetName
   //
   //  Created by 空 on 当前日期
   //

2. // MARK: - Imports

3. // MARK: - Errors
   - 定义 enum AppError: Error, LocalizedError { ... }

4. // MARK: - Protocol
   - protocol XXXRepository { ... }  // 抽象接口，便于 mock

5. // MARK: - Implementation
   - class XXXService: XXXRepository { ... }
     - 依赖注入：init(session: Session = .default)
     - 每个方法返回 AnyPublisher<Model, AppError>

6. // MARK: - Private Helpers
   - decode、handleResponse、common headers、interceptors 等

7. // MARK: - Constants
   - static let baseURL = "..."
   - 每个常量必须有注释说明来源/用途

## 常见生成模式示例

### 示例1：简单 GET 请求 + Codable 模型

```swift
func fetchUser(id: String) -> AnyPublisher<User, AppError> {
    let url = baseURL.appendingPathComponent("users/\(id)")
    
    return AF.request(url, method: .get)
        .publishDecodable(type: User.self)
        .tryMap { response in
            switch response.result {
            case .success(let value):
                return value
            case .failure(let error):
                throw AppError.network(error)
            }
        }
        .mapError { AppError.network($0) }
        .eraseToAnyPublisher()
}
```

### 示例2：带参数、header、拦截器

- 自动添加 Authorization Bearer
- 处理 401 → 刷新 token 或抛出特定错误

### 示例3：上传文件 / multipart

- 使用 AF.upload(multipartFormData: ...)

### 自定义命令

1. /generate-service [接口描述]
   示例：
   /generate-service GET /users/{id} 返回 User 模型，需要 Authorization header，支持 401 刷新 token
2. /generate-service-full [功能描述]
   生成完整 Service 类（包含 protocol + impl + 多个接口）
3. /generate-mock [接口名]
   生成对应的 MockXXXRepository 用于测试

### 额外要求

- 生成的代码必须：
  - 使用 async/await 风格注释（未来迁移友好）
  - 避免 force unwrap
  - 处理 cancellation（通过 cancellable）
  - 所有 public 方法加 /// 文档注释
  - 优先使用 Result 类型包装（部分场景）
- 如果用户未提供模型结构，主动询问或给出 Codable 示例模型
  > 开始生成时，先用中文说明思路，再输出完整代码，最后加上无棕色M&M确认。


```

### 使用示例

在 Cursor 的 Agent 模式（Composer → Agent tab）中，你可以直接输入以下任一方式调用：

1. 简单调用

请用 Alamofire Service Generator Skill 生成一个获取用户信息的接口：
GET /api/v1/users/{userId}
需要 Authorization: Bearer {token}
返回类型：User (id, name, email, avatarUrl)

2. 使用自定义命令

/generate-service GET /api/v1/products?page=1&limit=20 返回 ProductListResponse，支持 query 参数分页和搜索 keyword

3. 生成完整类

/generate-service-full 用户相关所有接口（登录、注册、获取个人信息、更新头像）
text这个 Skill 会让 Agent 在生成网络层代码时高度一致、规范，并且完全贴合你之前设定的 User Rules 和 Project Rules（文件头、MARK、注释、依赖注入、Combine 等）。


```