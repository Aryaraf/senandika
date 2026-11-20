import 'package:flutter/material.dart';

import '../models/release_model.dart';
import '../theme/app_theme.dart';
import 'release_cover.dart';

class FeaturedBanner extends StatelessWidget {
  const FeaturedBanner({super.key, required this.release, required this.onTap});

  final Release release;
  final VoidCallback onTap;

  static const Color _creamSoft = Color(0xCCF2EADB);
  static const Color _creamLine = Color(0x55F2EADB);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Sorotan: ${release.title} oleh ${release.artist}. Buka catatan.',
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 226),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: ColoredBox(color: AppColors.oxblood),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: _creamLine),
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  right: -34,
                  top: 34,
                  child: SizedBox(
                    width: 112,
                    height: 112,
                    child: CustomPaint(
                      painter: VinylPainter(labelColor: AppColors.ochre),
                    ),
                  ),
                ),
                Positioned(
                  right: 24,
                  top: 26,
                  child: Transform.rotate(
                    angle: 0.05,
                    child: Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: AppColors.paper,
                        border: Border.all(color: AppColors.paper, width: 3),
                      ),
                      child: ReleaseCover(release: release),
                    ),
                  ),
                ),
                Positioned(
                  right: 18,
                  bottom: 6,
                  child: Text(
                    '01',
                    style: AppText.serif(
                      size: 54,
                      italic: true,
                      color: const Color(0x33F2EADB),
                      height: 1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 22, 0, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'SOROTAN PEKAN INI',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.mono(
                                size: 10,
                                color: AppColors.ochreLight,
                                letterSpacing: 1.6,
                                weight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              release.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.serif(
                                size: 30,
                                weight: FontWeight.w600,
                                color: AppColors.paper,
                                height: 1.05,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              release.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.mono(
                                size: 11.5,
                                color: AppColors.ochreLight,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              release.note,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.serif(
                                size: 13,
                                italic: true,
                                weight: FontWeight.w400,
                                color: _creamSoft,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                FormatBadge(
                                  format: release.format,
                                  inverted: true,
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    release.priceLabel,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppText.mono(
                                      size: 12.5,
                                      weight: FontWeight.w600,
                                      color: AppColors.paper,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 128),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
