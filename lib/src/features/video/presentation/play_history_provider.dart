import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/video_repository.dart';
import '../domain/play_history.dart';

final episodeHistoriesProvider =
    FutureProvider.family<
      Map<int, EpisodeHistory>,
      ({int videoId, String? sourceId})
    >((ref, arg) async {
      final repository = ref.watch(videoRepositoryProvider);
      final histories = await repository.getEpisodeHistories(
        arg.videoId,
        arg.sourceId,
      );
      // Create a map for O(1) lookup: episodeIndex -> EpisodeHistory
      return {for (var h in histories) h.episodeIndex: h};
    });

final playHistoryProvider =
    AsyncNotifierProvider<PlayHistoryNotifier, List<VideoHistory>>(
      PlayHistoryNotifier.new,
      isAutoDispose: true,
    );

class PlayHistoryNotifier extends AsyncNotifier<List<VideoHistory>> {
  VideoRepository get _repository => ref.watch(videoRepositoryProvider);

  @override
  Future<List<VideoHistory>> build() async {
    return _repository.getAllVideoHistory();
  }

  Future<void> loadHistory() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getAllVideoHistory());
  }

  Future<void> saveVideoHistory(VideoHistory history) async {
    try {
      await _repository.saveVideoHistory(history);
      await loadHistory();
    } catch (e) {
      print('Error saving video history: $e');
    }
  }

  Future<void> deleteVideoHistory(int id) async {
    try {
      await _repository.deleteVideoHistory(id);
      await loadHistory();
    } catch (e) {
      print('Error deleting video history: $e');
    }
  }

  Future<void> clearHistory() async {
    try {
      await _repository.clearAllHistory();
      await loadHistory();
    } catch (e) {
      print('Error clearing history: $e');
    }
  }
}
