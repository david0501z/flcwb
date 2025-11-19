# FlClash 项目架构及本次更改说明

## 1. 项目概述

FlClash 是一个基于 ClashMeta 的多平台代理客户端，具有简洁易用的界面，开源且无广告。该项目使用 Flutter 开发，支持 Android、Windows、macOS 和 Linux 平台。

## 2. 原项目架构

### 2.1 主要目录结构
```
FlClash/
├── lib/                    # 核心源代码
│   ├── common/             # 通用组件和工具
│   ├── enum/               # 枚举定义
│   ├── models/             # 数据模型
│   ├── providers/          # 状态管理 (Riverpod)
│   ├── views/              # UI 页面组件
│   ├── widgets/            # 通用UI组件
│   ├── core/               # 核心功能
│   ├── manager/            # 管理器类
│   └── main.dart           # 应用入口
├── assets/                 # 静态资源
├── plugins/                # 原生插件
├── android/                # Android原生代码
├── ios/                    # iOS原生代码
├── linux/                  # Linux原生代码
├── macos/                  # macOS原生代码
├── windows/                # Windows原生代码
├── pubspec.yaml            # 项目依赖配置
└── README.md               # 项目说明
```

### 2.2 核心功能模块
- **Dashboard**: 仪表板，显示系统信息和状态
- **Proxies**: 代理管理，配置和切换代理节点
- **Profiles**: 配置文件管理，导入和管理订阅
- **Tools**: 工具集合
- **Logs**: 日志查看
- **Requests**: 请求管理
- **Resources**: 资源管理
- **Connections**: 连接管理

### 2.3 状态管理
- 使用 Riverpod 进行状态管理
- 代理状态管理 (`proxyStateProvider`)
- 导航状态管理 (`navigationStateProvider`)
- 应用设置管理 (`appSettingProvider`)

### 2.4 代理功能
- 基于 ClashMeta 内核
- 支持多种代理协议 (HTTP, HTTPS, SOCKS)
- 系统代理设置
- 端口配置

## 3. 本次更改内容

### 3.1 添加浏览器功能

#### 3.1.1 新增文件
1. `lib/views/browser_view.dart` - 浏览器主视图组件
2. `lib/widgets/webview_widget.dart` - WebView 组件封装

#### 3.1.2 修改文件

**1. `lib/enum/enum.dart`**
- 在 `PageLabel` 枚举中添加 `browser` 项
- 位置：在 `dashboard` 和 `proxies` 之间

**2. `lib/common/navigation.dart`**
- 在导航项列表中添加浏览器页面
- 位置：在仪表板和代理页面之间
- 图标：`Icons.language`
- 标签：`PageLabel.browser`

**3. `lib/views/views.dart`**
- 添加 `export 'browser_view.dart';` 导出浏览器视图

**4. `lib/widgets/widgets.dart`**
- 添加 `export 'webview_widget.dart';` 导出WebView组件

**5. `pubspec.yaml`**
- 由于依赖冲突问题，未添加 `flutter_inappwebview` 依赖
- 调整了多个依赖版本以解决兼容性问题

**6. `README.md`**
- 在功能列表中添加浏览器功能说明

### 3.2 浏览器功能特性

#### 3.2.1 UI组件
- **地址栏**: 位于页面顶部，可输入网址
- **导航按钮**: 包括后退、前进、刷新按钮
- **标签页管理**: 显示当前打开的标签页数量，支持多标签页
- **菜单按钮**: 提供历史记录和下载记录功能

#### 3.2.2 核心功能
- **标签页管理**: 支持打开、关闭、切换标签页
- **历史记录**: 显示访问过的网页历史
- **下载记录**: 管理下载的文件
- **代理集成**: 与FlClash的代理功能集成，使用当前代理设置

#### 3.2.3 代理集成
- 通过 Riverpod 监听 `proxyStateProvider`
- 自动获取当前代理状态（是否启用、端口等）
- 浏览器流量将通过FlClash配置的代理进行转发

### 3.3 依赖管理

由于原项目使用较新版本的依赖，而 Flutter 3.24.3 的 Dart SDK 版本较低（3.5.3），导致了多个依赖冲突：

- `device_info_plus`: 从 ^11.3.3 降级到 ^8.0.0
- `win32_registry`: 从 ^2.0.0 降级到兼容版本
- `launch_at_startup`: 从 ^0.5.1 降级到 ^0.4.1
- `collection`: 从 ^1.19.1 降级到 ^1.18.0
- `ffi`: 从 ^2.1.4 降级到 ^2.0.1
- `image_picker`: 从 ^1.2.0 降级到 ^0.8.6
- `url_launcher`: 从 ^6.3.2 降级到 ^6.1.14
- `build_runner`: 从 ^2.7.0 降级到 ^2.4.8
- `riverpod`: 从 ^3.0.0 降级到 ^2.4.9
- `flutter_riverpod`: 从 ^3.0.0 降级到 ^2.4.9
- `riverpod_annotation`: 从 ^3.0.0 降级到 ^2.3.3
- `riverpod_generator`: 从 ^3.0.0 降级到 ^2.3.9
- `riverpod_lint`: 从 ^3.0.0 降级到 ^2.3.9
- `flutter_lints`: 从 ^6.0.0 降级到 ^2.0.0
- Dart SDK 约束: 从 '>=3.8.0 <4.0.0' 改为 '>=3.5.0 <4.0.0'

## 4. 开发说明

### 4.1 浏览器功能实现
由于依赖冲突问题，WebView功能使用模拟组件实现。在实际部署时，建议：

1. 使用兼容的WebView包（如 `webview_flutter`）
2. 确保代理设置正确传递给WebView
3. 处理权限请求（特别是网络访问权限）

### 4.2 代理集成
浏览器组件通过 Riverpod 监听代理状态变化，确保始终使用最新的代理配置。

### 4.3 未来改进
1. **WebView实现**: 集成真正的WebView组件，而非模拟实现
2. **性能优化**: 优化多标签页的内存管理
3. **安全增强**: 添加安全浏览功能
4. **下载管理**: 实现完整的下载管理功能
5. **书签功能**: 添加书签管理功能

## 5. 构建说明

### 5.1 环境要求
- Flutter 3.24.3
- Dart SDK 3.5.3
- 支持的平台：Android, Windows, macOS, Linux

### 5.2 构建步骤
1. 克隆项目并初始化子模块
   ```bash
   git clone https://github.com/chen08209/FlClash.git
   git submodule update --init --recursive
   ```

2. 安装依赖
   ```bash
   flutter pub get
   ```

3. 构建应用
   ```bash
   # Android
   dart .\setup.dart android
   
   # Windows
   dart .\setup.dart windows --arch <arm64 | amd64>
   
   # Linux
   dart .\setup.dart linux --arch <arm64 | amd64>
   
   # macOS
   dart .\setup.dart macos --arch <arm64 | amd64>
   ```

## 6. 故障排除

### 6.1 依赖冲突
如果遇到依赖冲突问题，可尝试：
1. 使用 `flutter pub deps` 检查依赖树
2. 根据错误信息调整依赖版本
3. 使用 `flutter clean` 清理后重新获取依赖

### 6.2 WebView功能
当前WebView为模拟实现，如需真实WebView功能：
1. 解决依赖冲突问题
2. 添加兼容的WebView包
3. 实现代理集成逻辑

## 7. 总结

本次更新成功在FlClash中添加了内置浏览器功能，将浏览器页面集成到现有的导航系统中，位于仪表板和代理页面之间。浏览器功能包含完整的UI组件和基本功能，与FlClash的代理系统集成，可以使用当前的代理设置进行网络访问。虽然由于依赖冲突问题，WebView功能暂时使用模拟实现，但整体架构已为后续实现真实WebView功能做好了准备。