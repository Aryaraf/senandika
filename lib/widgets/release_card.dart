import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/release_model.dart';
import '../providers/release_provider.dart';
import '../theme/app_theme.dart';
import 'release_cover.dart';

class ReleaseCard extends StatelessWidget {
  const ReleaseCard({super.key, required this.release, required this.onTap});

  final Release release;
  final VoidCallback onTap;

  static const double infoHeight = 113;

  static double extentFor(double cardWidth) => cardWidth + infoHeight;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<ReleaseProvider, bool>(
      (provider) => provider.isFavorite(release.id),
    );

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children : [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ReleaseCover(release: release),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: FormatBadge(format: release.format),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: _FavoriteButton(
                      isFavorite: isFavorite,
                      onPressed: () => context
                        .read<ReleaseProvider>()
                        .toggleFavorite(release.id),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.hairlineStrong,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        release.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.serif(size: 14.5, height: 1.15),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      release.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.mono(size: 10.5, color: AppColors.inkSoft),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            release.priceLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.mono(
                              size: 11.5,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '${release.year}',
                          style: AppText.mono(
                            size: 10.5,
                            color: AppColors.inkSoft,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.isFavorite,
    required this.onPressed,
  });

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      padding: EdgeInsets.zero,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.redAccent : AppColors.ink,
        size: 20,
      ),
    );
  }
}