# 如何在 Vidra Player 中使用 Sentry 监控

## ✅ 已实现：Vidra Player 内部监控

**好消息！** 现在 `vidra_player` 包已经支持可选的性能监控接口，可以自动监控内部所有操作。

### 核心设计

1. ✅ **在 `vidra_player` 中添加了监控接口**（不依赖 Sentry）
2. ✅ **在主应用中实现 Sentry 监控**
3. ✅ **保持向后兼容**（现有代码无需修改）

---

## 快速开始

### 步骤 1：在主应用中使用监控

```dart
import 'package:vidra/src/core/monitoring/sentry_player_monitor.dart';

// 创建 PlayerController 时传入监控器
_controller = PlayerController(
  config: config,
  video: _mapMetadata(video),
  episodes: episodes,
  player: VideoPlayerAdapter(),
  windowDelegate: BitsdojoWindowDelegate(),
  mediaRepository: VidraMediaRepository(ref.read(videoRepositoryProvider)),
  performanceMonitor: SentryPlayerMonitor(), // 添加这一行
);
```

### 步骤 2：就这样！

所有操作会自动被监控：
- ✅ Play, Pause, Seek
- ✅ Episode switching
- ✅ Quality switching
- ✅ Buffering events
- ✅ Errors

---

## 监控的操作

### 自动监控的方法

**播放控制**：
- `play()` - 播放操作
- `pause()` - 暂停操作
- `seek()` - 跳转操作（包含起始和目标位置）

**剧集管理**：
- `switchEpisode()` - 剧集切换（包含源和目标剧集）
- `playNextEpisode()` - 下一集
- `playPreviousEpisode()` - 上一集

**质量管理**：
- `switchQuality()` - 质量切换（包含源和目标质量）

**事件**：
- Buffering 开始/结束
- 播放完成
- 错误

---

## 工作原理

### 1. Vidra Player 接口

`vidra_player` 包定义了抽象接口：

```dart
abstract class PlayerPerformanceMonitor {
  Future<T> trackPlay<T>(Future<T> Function() operation, ...);
  Future<T> trackPause<T>(Future<T> Function() operation, ...);
  Future<T> trackSeek<T>(Future<T> Function() operation, ...);
  // ... 其他方法
}
```

### 2. Sentry 实现

主应用实现了这个接口：

```dart
class SentryPlayerMonitor implements PlayerPerformanceMonitor {
  @override
  Future<T> trackPlay<T>(Future<T> Function() operation, ...) async {
    return await VideoPerformanceMonitor.trackPlayback(
      operation: operation,
      currentPosition: currentPositionMs,
    );
  }
  // ... 其他实现
}
```

### 3. 自动包装

`PlayerController` 内部自动包装所有操作：

```dart
Future<void> play() async {
  if (performanceMonitor != null) {
    return await performanceMonitor!.trackPlay(
      () => playbackManager.play(),
      currentPositionMs: _position.position.inMilliseconds,
    );
  }
  await playbackManager.play();
}
```

---

## 优势

### 对比之前的方案

| 特性 | 之前（手动监听） | 现在（自动监控） |
|------|-----------------|-----------------|
| 代码量 | 需要手动包装每个操作 | 只需传入一个参数 |
| 覆盖范围 | 只能监控外部调用 | 监控所有内部操作 |
| 维护性 | 容易遗漏 | 自动完整 |
| 性能数据 | 不够精确 | 精确到每个操作 |

### 新方案的优势

✅ **自动完整**：所有操作自动被监控
✅ **无需手动**：不需要手动包装每个调用
✅ **内部可见**：可以监控包内部的操作
✅ **灵活扩展**：可以用任何监控工具实现接口
✅ **向后兼容**：不传 `performanceMonitor` 参数时，包正常工作

---

## 在 Sentry Dashboard 中查看

所有数据会自动出现在 Sentry Performance 面板：

- **Transaction**: `video_playback_play`, `video_playback_pause`, etc.
- **Tags**: `videoId`, `resolution`, `deviceModel`
- **Data**: `currentPosition`, `duration`, `episodeIndex`

可以按以下维度过滤和分析：
- 按视频 ID
- 按分辨率
- 按设备类型
- 按操作类型

---

## 总结

**现在的方案是最优的**：

1. ✅ `vidra_player` 包保持独立（不依赖 Sentry）
2. ✅ 主应用获得完整的性能监控
3. ✅ 自动监控所有操作（包括内部操作）
4. ✅ 一行代码启用监控
5. ✅ 向后兼容

详细文档请查看：`SENTRY_MONITORING.md`
