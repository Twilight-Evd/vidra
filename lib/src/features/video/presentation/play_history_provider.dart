import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/log.dart';
import '../data/video_repository.dart';
import '../domain/play_history.dart';

final episodeHistoriesProvider = FutureProvider.autoDispose
    .family<Map<int, EpisodeHistory>, ({int videoId, String? sourceId})>((
      ref,
      arg,
    ) async {
      final repository = ref.watch(videoRepositoryProvider);
      final histories = await repository.getEpisodeHistories(
        arg.videoId,
        arg.sourceId,
      );
      // Create a map for O(1) lookup: episodeIndex -> EpisodeHistory
      return {for (var h in histories) h.episodeIndex: h};
    });

final playHistoryProvider =
    StreamNotifierProvider.autoDispose<PlayHistoryNotifier, List<VideoHistory>>(
      PlayHistoryNotifier.new,
    );

class PlayHistoryNotifier extends StreamNotifier<List<VideoHistory>> {
  VideoRepository get _repository => ref.watch(videoRepositoryProvider);

  @override
  Stream<List<VideoHistory>> build() {
    return _repository.watchAllVideoHistory();
  }

  Future<void> saveVideoHistory(VideoHistory history) async {
    try {
      await _repository.saveVideoHistory(history);
    } catch (e) {
      logR('PlayHistory', 'Error saving video history: $e');
    }
  }

  Future<void> deleteVideoHistory(int id) async {
    try {
      await _repository.deleteVideoHistory(id);
    } catch (e) {
      logR('PlayHistory', 'Error deleting video history: $e');
    }
  }

  Future<void> clearHistory() async {
    try {
      await _repository.clearAllHistory();
    } catch (e) {
      logR('PlayHistory', 'Error clearing history: $e');
    }
  }
}
