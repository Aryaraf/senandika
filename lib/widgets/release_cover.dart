import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/release_model.dart';
import '../theme/app_theme.dart';

class ReleaseCover extends StatelessWidget {
  const ReleaseCover({super.key, required this.release});

  final Release release;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      release.coverUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFA47C4B),
      colorBlendMode: BlendMode.color,
      semanticLabel: 'Sampul ${release.title} oleh ${release.artist}',
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return CoverFallback(release: release);
      },
      errorBuilder: (context, error, stackTrace) {
        return CoverFallback(release: release);
      },
    );
  }
}

class _SleeveTone {
  const _SleeveTone(this.background, this.foreground, this.accent);

  final Color background;
  final Color foreground;
  final Color accent;
}

class CoverFallback extends StatelessWidget {
  const CoverFallback({super.key, required this.release});

  final Release release;

  static const List<_SleeveTone> _tones = <_SleeveTone>[
    _SleeveTone(Color(0xFFD8C7A8), AppColors.ink, AppColors.oxblood),
    _SleeveTone(Color(0xFF8E3B27), AppColors.paper, AppColors.ochreLight),
    _SleeveTone(Color(0xFF51603F), AppColors.paper, AppColors.ochre),
    _SleeveTone(Color(0xFFD3A445), AppColors.ink, AppColors.oxblood),
    _SleeveTone(Color(0xFF3A2F29), AppColors.paper, AppColors.ochre),
    _SleeveTone(Color(0xFFC27A56), AppColors.ink, Color(0xFF3A2F29)),
  ];

  @override
  Widget build(BuildContext context) {
    final seed = release.title.codeUnits.fold<int>(
      0,
      (sum, unit) => sum + unit,
    );
    final tone = _tones[seed % _tones.length];

    final CustomPainter painter = switch (release.format) {
      ReleaseFormat.vinyl => VinylPainter(labelColor: tone.accent),
      ReleaseFormat.kaset => CassettePainter(accent: tone.accent),
      ReleaseFormat.cd => CdPainter(holeColor: tone.background),
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.biggest.shortestSide;
        final showText = side >= 120;
        final verticalArt = showText ? side * 0.18 : side * 0.1;

        return Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: tone.background),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  side * 0.12,
                  verticalArt,
                  side * 0.12,
                  showText ? side * 0.2 : verticalArt,
                ),
                child: CustomPaint(painter: painter, size: Size.infinite),
              ),
            ),
            if (showText) ...[
              Positioned(
                left: side * 0.07,
                right: side * 0.07,
                top: side * 0.06,
                child: Text(
                  release.artist.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.mono(
                    size: side * 0.05,
                    weight: FontWeight.w600,
                    color: tone.foreground,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Positioned(
                left: side * 0.07,
                right: side * 0.07,
                bottom: side * 0.05,
                child: Text(
                  release.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.serif(
                    size: side * 0.075,
                    italic: true,
                    color: tone.foreground,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class FormatBadge extends StatelessWidget {
  const FormatBadge({super.key, required this.format, this.inverted = false});

  final ReleaseFormat format;

  final bool inverted;

  @override
  Widget build(BuildContext context) {
    final background = inverted
        ? AppColors.paper
        : AppColors.formatBackground(format);
    final foreground = inverted
        ? AppColors.ink
        : AppColors.formatForeground(format);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        format.label.toUpperCase(),
        style: AppText.mono(
          size: 9.5,
          weight: FontWeight.w600,
          color: foreground,
          letterSpacing: 1.2,
          height: 1.1,
        ),
      ),
    );
  }
}

class VinylPainter extends CustomPainter {
  const VinylPainter({this.labelColor = AppColors.oxblood});

  final Color labelColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;

    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF15100D));

    final groove = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6
      ..color = const Color(0x14FFFFFF);
    for (var r = radius * 0.38; r < radius * 0.96; r += radius * 0.055) {
      canvas.drawCircle(center, r, groove);
    }

    final sheen = Paint()
      ..shader = const SweepGradient(
        colors: [
          Color(0x00FFFFFF),
          Color(0x22FFFFFF),
          Color(0x00FFFFFF),
          Color(0x1AFFFFFF),
          Color(0x00FFFFFF),
        ],
        stops: [0.0, 0.12, 0.5, 0.62, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, sheen);

    canvas.drawCircle(
      center,
      radius * 0.985,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = const Color(0x22FFFFFF),
    );

    canvas.drawCircle(center, radius * 0.34, Paint()..color = labelColor);
    canvas.drawCircle(
      center,
      radius * 0.25,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = const Color(0x55F2EADB),
    );
    canvas.drawCircle(center, radius * 0.045, Paint()..color = AppColors.paper);
  }

  @override
  bool shouldRepaint(VinylPainter oldDelegate) =>
      oldDelegate.labelColor != labelColor;
}

class CassettePainter extends CustomPainter {
  const CassettePainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final w = math.min(size.width, size.height * 1.6) * 0.94;
    final h = w / 1.6;
    final body = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: w,
      height: h,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(body, Radius.circular(w * 0.035)),
      Paint()..color = const Color(0xFF2A221D),
    );

    final label = Rect.fromLTWH(
      body.left + w * 0.07,
      body.top + h * 0.09,
      w * 0.86,
      h * 0.5,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(label, Radius.circular(w * 0.02)),
      Paint()..color = AppColors.paper,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        label.left,
        label.bottom - label.height * 0.28,
        label.width,
        label.height * 0.28,
      ),
      Paint()..color = accent,
    );

    final line = Paint()
      ..color = const Color(0x59241C17)
      ..strokeWidth = math.max(0.8, h * 0.012);
    for (final fraction in [0.22, 0.45]) {
      final y = label.top + label.height * fraction;
      canvas.drawLine(
        Offset(label.left + label.width * 0.08, y),
        Offset(label.right - label.width * 0.08, y),
        line,
      );
    }

    final window = Rect.fromCenter(
      center: Offset(body.center.dx, body.top + h * 0.78),
      width: w * 0.52,
      height: h * 0.22,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(window, Radius.circular(window.height / 2)),
      Paint()..color = const Color(0xFF0F0B09),
    );

    final reelRadius = window.height * 0.36;
    for (final dx in [
      window.left + window.width * 0.24,
      window.right - window.width * 0.24,
    ]) {
      final c = Offset(dx, window.center.dy);
      canvas.drawCircle(c, reelRadius, Paint()..color = AppColors.paperDeep);
      canvas.drawCircle(
        c,
        reelRadius * 0.45,
        Paint()..color = const Color(0xFF0F0B09),
      );
    }

    final screw = Paint()..color = const Color(0x40F2EADB);
    for (final p in [
      Offset(body.left + w * 0.04, body.top + h * 0.07),
      Offset(body.right - w * 0.04, body.top + h * 0.07),
      Offset(body.left + w * 0.04, body.bottom - h * 0.07),
      Offset(body.right - w * 0.04, body.bottom - h * 0.07),
    ]) {
      canvas.drawCircle(p, w * 0.012, screw);
    }
  }

  @override
  bool shouldRepaint(CassettePainter oldDelegate) =>
      oldDelegate.accent != accent;
}

class CdPainter extends CustomPainter {
  const CdPainter({required this.holeColor});

  final Color holeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const SweepGradient(
          colors: [
            Color(0xFFDCD3C1),
            Color(0xFFB9AE9A),
            Color(0xFFEFE8D8),
            Color(0xFFB4A892),
            Color(0xFFDCD3C1),
          ],
        ).createShader(rect),
    );

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7
      ..color = const Color(0x33241C17);
    canvas.drawCircle(center, radius * 0.96, ring);
    canvas.drawCircle(center, radius * 0.66, ring);
    canvas.drawCircle(
      center,
      radius * 0.34,
      Paint()..color = const Color(0x55F2EADB),
    );
    canvas.drawCircle(center, radius * 0.34, ring);
    canvas.drawCircle(center, radius * 0.1, Paint()..color = holeColor);
  }

  @override
  bool shouldRepaint(CdPainter oldDelegate) =>
      oldDelegate.holeColor != holeColor;
}