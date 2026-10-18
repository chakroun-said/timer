import 'package:flutter/material.dart';

/// Full-window fitness photo behind the app, softened by a scrim so the light
/// surfaces above it stay calm and readable.
///
/// Two derivatives ship: the crisp photo for the desktop margins, and a blurred
/// copy for phones, where the photo sits behind the whole interface and its
/// baked-in "GO" dial would otherwise read as a second timer.
class FitnessBackdrop extends StatelessWidget {
  const FitnessBackdrop({super.key, required this.blurred});

  static const String _sharpAsset = 'assets/background/gym.webp';
  static const String _softAsset = 'assets/background/gym-soft.webp';

  /// Whether to use the blurred derivative (full-screen, narrow layouts).
  final bool blurred;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            blurred ? _softAsset : _sharpAsset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.medium,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) return child;
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOut,
                child: child,
              );
            },
          ),
          // Navy scrim: unifies the photo, deepens its lower half and keeps it
          // from competing with the content panel.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x400B141F), Color(0x730B141F)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
