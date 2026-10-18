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
        // The photo supplies the page background; content floats on a light
        // veil so text stays readable and the photo reads as atmosphere.
        scaffoldBackgroundColor: colors.surface.withAlpha(0xCC),
        appBarTheme: AppBarTheme(
          // Slightly denser than the page veil so content scrolling beneath the
          // bar fades out instead of clashing with the title.
          backgroundColor: colors.surface.withAlpha(0xDE),
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
        Positioned.fill(child: FitnessBackdrop(blurred: !framed)),
        Positioned.fill(
          child: framed
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    // Opaque and rounded: the photo frames the app instead of
                    // showing through the reading surface.
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: _maxContentWidth,
                      ),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x59000000),
                              blurRadius: 56,
                              offset: Offset(0, 18),
                            ),
                          ],
                        ),
                        child: child,
                      ),
                    ),
                  ),
                )
              : child,
        ),
      ],
    );
  }
}
