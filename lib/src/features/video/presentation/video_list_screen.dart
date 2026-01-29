import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:vidra/src/features/video/presentation/widgets/list/video_list_widgets.dart';
import 'package:vidra/src/features/video/presentation/video_list_provider.dart';
import 'package:vidra/src/features/video/presentation/widgets/cards/video_cards.dart';
import 'package:vidra/src/common/skeleton/video_card_skeleton.dart';
import 'package:vidra/src/features/video/domain/category.dart';
import 'package:vidra/src/features/video/data/video_repository.dart';

class VideoListScreen extends HookConsumerWidget {
  const VideoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    context.locale; // Ensure rebuild on locale change
    final listState = ref.watch(videoListProvider);
    final filter = ref.watch(videoListFilterProvider);
    final videos = listState.videos;

    // Infinite Scroll Controller
    final scrollController = useScrollController();
    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          ref.read(videoListProvider.notifier).loadNextPage();
        }
      });
      return null;
    }, [scrollController]);

    final categoriesAsync = ref.watch(categoriesProvider);
    final categories = categoriesAsync.maybeWhen(
      data: (data) => data,
      orElse: () => <Category>[],
    );

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          // Header (Category Filter)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CategoryFilter(
                      selectedCategory: filter.category,
                      categories: categories,
                      selectedSubType: filter.subType,
                      selectedArea: filter.area,
                      selectedYear: filter.year,
                      onCategoryChanged: (Category cat) {
                        ref
                            .read(videoListFilterProvider.notifier)
                            .state = filter.copyWith(
                          category: cat,
                          subType: '全部类型',
                          area: '全部地区',
                          year: '全部年份',
                        );
                      },
                      onFilterChanged: (subType, area, year) {
                        ref
                            .read(videoListFilterProvider.notifier)
                            .state = filter.copyWith(
                          subType: subType,
                          area: area,
                          year: year,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading State Skeleton
          if (listState.isLoading && videos.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const VideoCardSkeleton(),
                  childCount: 12, // Show a reasonable number of skeletons
                ),
              ),
            ),

          if (videos.isNotEmpty) ...[
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220, // Adjusted for responsiveness
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return PopularVideoCard(video: videos[index]);
                }, childCount: videos.length),
              ),
            ),

            // Loading footer - use skeletons instead of spinner
            if (listState.isLoading)
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: 20,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const VideoCardSkeleton(),
                    childCount: 4, // Show a row of loading items at bottom
                  ),
                ),
              ),
          ] else if (!listState.isLoading && videos.isEmpty) ...[
            SliverFillRemaining(
              child: Center(
                child: Text(
                  tr('search.no_results'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
