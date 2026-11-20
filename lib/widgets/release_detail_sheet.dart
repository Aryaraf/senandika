import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/release_model.dart';
import '../providers/release_provider.dart';
import '../theme/app_theme.dart';
import 'release_cover.dart';

Future<void> showReleaseDetailSheet(BuildContext context, Release release) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.paper,
    barrierColor: const Color(0x99241C17),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      side: BorderSide(color: AppColors.hairlineStrong),
    ),
    builder: (context) => ReleaseDetailSheet(release: release),
  );
}

class ReleaseDetailSheet extends StatelessWidget {
  const ReleaseDetailSheet({super.key, required this.release});

  final Release release;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<ReleaseProvider, bool>(
      (provider) => provider.isFavorite(release.id),
    );
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(22, 10, 22, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 3,
              color: AppColors.hairlineStrong,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.hairlineStrong),
                ),
                child: ReleaseCover(release: release),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormatBadge(format: release.format),
                    const SizedBox(height: 10),
                    Text(
                      release.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.serif(size: 24, height: 1.1),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      release.artist,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.mono(size: 12, color: AppColors.inkSoft),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'CATATAN KURATORIAL',
            style: AppText.mono(
              size: 10,
              weight: FontWeight.w600,
              color: AppColors.oxblood,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 14),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.oxblood, width: 2),
              ),
            ),
            child: Text(
              release.note,
              style: AppText.serif(
                size: 18,
                italic: true,
                weight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _MetaRow(label: 'FORMAT', value: release.format.detail),
          _MetaRow(label: 'TAHUN RILIS', value: '${release.year}'),
          _MetaRow(label: 'HARGA', value: release.priceLabel, isLast: true),
          const SizedBox(height: 22),
          Semantics(
            button: true,
            label: isFavorite ? 'Hapus dari wishlist' : 'Simpan ke wishlist',
            child: GestureDetector(
              onTap: () =>
                  context.read<ReleaseProvider>().toggleFavorite(release.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 50,
                decoration: BoxDecoration(
                  color: isFavorite ? Colors.transparent : AppColors.ink,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: isFavorite ? AppColors.oxblood : AppColors.ink,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 17,
                      color: isFavorite ? AppColors.oxblood : AppColors.paper,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        isFavorite
                            ? 'HAPUS DARI WISHLIST'
                            : 'SIMPAN KE WISHLIST',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.mono(
                          size: 12,
                          weight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: isFavorite
                              ? AppColors.oxblood
                              : AppColors.paper,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: const BorderSide(color: AppColors.hairline),
          bottom: isLast
              ? const BorderSide(color: AppColors.hairline)
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: AppText.mono(
                size: 10.5,
                color: AppColors.inkSoft,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppText.mono(size: 12.5, weight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
