import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/release_model.dart';
import '../providers/release_provider.dart';
import '../theme/app_theme.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteCount = context.select<ReleaseProvider, int>(
      (p) => p.favoriteCount,
    );
    final wishlistTotal = context.select<ReleaseProvider, int>(
      (p) => p.wishlistTotal,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(bottom: BorderSide(color: AppColors.ink)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ARSIP RILISAN FISIK · INDONESIA',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.mono(
                        size: 9.5,
                        color: AppColors.inkSoft,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Senandika',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.serif(
                        size: 36,
                        weight: FontWeight.w700,
                        height: 1.05,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  'EDISI\nNOV 2026',
                  textAlign: TextAlign.right,
                  style: AppText.mono(
                    size: 9.5,
                    color: AppColors.inkSoft,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 58,
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.hairlineStrong)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _Stat(
                    label: 'KOLEKSI WISHLIST',
                    value: '${favoriteCount.toString().padLeft(2, '0')} judul',
                  ),
                ),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: AppColors.hairlineStrong,
                ),
                Expanded(
                  child: _Stat(
                    label: 'ESTIMASI HARGA',
                    value: formatRupiah(wishlistTotal),
                    leftPadding: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.leftPadding = 0});

  final String label;
  final String value;
  final double leftPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.mono(
              size: 9.5,
              color: AppColors.inkSoft,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: Text(
                value,
                key: ValueKey<String>(value),
                maxLines: 1,
                style: AppText.serif(size: 20, height: 1.1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
