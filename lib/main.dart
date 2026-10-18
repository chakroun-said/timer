import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'widgets/fitness_backdrop.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ColorScheme.fromSeed(seedColor: Colors.blue);
    return MaterialApp(
      title: 'Workout Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colors,
        useMaterial3: true,
        // The fitness backdrop supplies the page background, so scaffolds and
        // the app bar paint only a tint over it.
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          // Same tint as the frame so the bar dissolves into the column while
          // still hiding content that scrolls beneath it.
          backgroundColor: colors.surface.withAlpha(0xE4),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      builder: (context, child) => _AppFrame(child: child!),
      home: const HomePage(),
    );
  }
}

/// Keeps the app at a phone-like width in the middle of the viewport, over the
/// app-wide fitness backdrop.
///
/// Every page is designed for portrait mobile, so letting them stretch across a
/// desktop window scatters the app bar, list and FAB to opposite edges.
class _AppFrame extends StatelessWidget {
  const _AppFrame({required this.child});

  static const double _maxContentWidth = 560;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final framed = MediaQuery.sizeOf(context).width > _maxContentWidth;

    return Stack(
      children: [
        const Positioned.fill(child: FitnessBackdrop()),
        Positioned.fill(
          child: framed
              ? Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _maxContentWidth,
                    ),
                    // Translucent so the artwork carries through the column.
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.surface.withAlpha(0xE4),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1F0B1F3A),
                            blurRadius: 40,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: child,
                    ),
                  ),
                )
              : child,
        ),
      ],
    );
  }
}
