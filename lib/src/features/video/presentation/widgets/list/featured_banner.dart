import 'package:flutter/material.dart';

class FeaturedBanner extends StatelessWidget {
  const FeaturedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
            'https://image.tmdb.org/t/p/original/xbSuFiJbbBWCkyCCKIMfuDCA4yV.jpg',
          ), // The Crown (example)
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Stack(
        children: [
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(isDark ? 25 : 5),
                  Colors.black.withAlpha(isDark ? 150 : 40),
                  isDark ? const Color(0xFF0F1014) : theme.colorScheme.surface,
                ],
                stops: const [0, 0.6, 1],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'The Crown',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    // Watchlist Button
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withAlpha(50)
                            : Colors.black.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withAlpha(30)
                              : Colors.black.withAlpha(10),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: isDark ? Colors.white : Colors.black87,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Watchlist',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Pagination Dots
                    Row(
                      children: [
                        _buildDot(isDark, false),
                        _buildDot(isDark, true), // active
                        _buildDot(isDark, false),
                      ],
                    ),
                    const Spacer(),

                    // Watch Now Button
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withAlpha(100),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Watch Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Navigation Arrows
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: _buildArrowButton(isDark, Icons.chevron_left),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: _buildArrowButton(isDark, Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isDark, bool isActive) {
    return Container(
      width: isActive ? 24 : 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? Colors.white : Colors.black87)
            : (isDark
                  ? Colors.white.withAlpha(80)
                  : Colors.black.withAlpha(30)),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildArrowButton(bool isDark, IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withAlpha(50) : Colors.black.withAlpha(20),
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark
              ? Colors.white.withAlpha(30)
              : Colors.black.withAlpha(10),
        ),
      ),
      child: Icon(
        icon,
        color: isDark ? Colors.white : Colors.black87,
        size: 24,
      ),
    );
  }
}
