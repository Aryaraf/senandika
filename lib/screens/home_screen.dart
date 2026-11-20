import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/release_model.dart';
import '../providers/release_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/featured_banner.dart';
import '../widgets/header_section.dart';
import '../widgets/release_card.dart';
import '../widgets/release_cover.dart';
import '../widgets/release_detail_sheet.dart';

/// Satu-satunya halaman aplikasi.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetAll() {
    _searchController.clear();
    context.read<ReleaseProvider>().reset();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const HeaderSection(),
              Expanded(
                child: _CatalogView(
                  searchController: _searchController,
                  onReset: _resetAll,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogView extends StatelessWidget {
  const _CatalogView({required this.searchController, required this.onReset});

  final TextEditingController searchController;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReleaseProvider>();
    final items = provider.visibleReleases;
    final featured = provider.featured;

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(top: 18, bottom: 40),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _SearchField(controller: searchController),
        ),
        if (provider.isBrowsingAll && featured != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: FeaturedBanner(
              release: featured,
              onTap: () => showReleaseDetailSheet(context, featured),
            ),
          ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 26, 20, 12),
          child: _SectionHeading(),
        ),
        const _FilterBar(),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          child: items.isEmpty
              ? _EmptyState(
                  hasQuery: provider.hasQuery,
                  isFavorites: provider.activeFilter == CatalogFilter.favorit,
                  canReset: !provider.isBrowsingAll,
                  onReset: onReset,
                )
              : _ReleaseGrid(items: items),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: AppColors.hairlineStrong),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 20, color: AppColors.inkSoft),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (value) =>
                  context.read<ReleaseProvider>().setQuery(value),
              textInputAction: TextInputAction.search,
              cursorColor: AppColors.oxblood,
              style: AppText.mono(size: 13),
              decoration: InputDecoration.collapsed(
                hintText: 'Cari judul album atau nama band',
                hintStyle: AppText.mono(size: 12.5, color: AppColors.inkSoft),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  controller.clear();
                  context.read<ReleaseProvider>().setQuery('');
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppColors.inkSoft,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReleaseProvider>();
    final count = provider.visibleReleases.length;

    final String title;
    if (provider.hasQuery) {
      title = 'Hasil pencarian';
    } else {
      title = switch (provider.activeFilter) {
        CatalogFilter.semua => 'Katalog rilisan',
        CatalogFilter.favorit => 'Wishlist saya',
        final filter => 'Rak ${filter.label}',
      };
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.serif(size: 22, letterSpacing: -0.3),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '${count.toString().padLeft(2, '0')} judul',
          style: AppText.mono(size: 11, color: AppColors.inkSoft),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReleaseProvider>();

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: CatalogFilter.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = CatalogFilter.values[index];
          return _FilterChip(
            filter: filter,
            count: provider.countFor(filter),
            isActive: provider.activeFilter == filter,
            onTap: () => context.read<ReleaseProvider>().setFilter(filter),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  final CatalogFilter filter;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = isActive ? AppColors.paper : AppColors.ink;
    final muted = isActive ? const Color(0xB3F2EADB) : AppColors.inkSoft;

    return Semantics(
      button: true,
      selected: isActive,
      label: 'Filter ${filter.label}',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isActive ? AppColors.ink : Colors.transparent,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: isActive ? AppColors.ink : AppColors.hairlineStrong,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (filter == CatalogFilter.favorit) ...[
                Icon(Icons.favorite, size: 12, color: foreground),
                const SizedBox(width: 6),
              ],
              Text(
                filter.label.toUpperCase(),
                style: AppText.mono(
                  size: 11,
                  weight: FontWeight.w600,
                  color: foreground,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 6),
              Text('$count', style: AppText.mono(size: 10.5, color: muted)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReleaseGrid extends StatelessWidget {
  const _ReleaseGrid({required this.items});

  final List<Release> items;

  static const double _spacing = 14;

  /// Kolom kanan turun sedikit agar komposisi terasa asimetris ala majalah.
  static const double _stagger = 22;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - _spacing) / 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: _spacing,
            crossAxisSpacing: _spacing,
            mainAxisExtent: ReleaseCard.extentFor(cardWidth) + _stagger,
          ),
          itemBuilder: (context, index) {
            final release = items[index];
            final isRightColumn = index.isOdd;

            return Padding(
              padding: EdgeInsets.only(
                top: isRightColumn ? _stagger : 0,
                bottom: isRightColumn ? 0 : _stagger,
              ),
              child: ReleaseCard(
                key: ValueKey<String>(release.id),
                release: release,
                onTap: () => showReleaseDetailSheet(context, release),
              ),
            );
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.hasQuery,
    required this.isFavorites,
    required this.canReset,
    required this.onReset,
  });

  final bool hasQuery;
  final bool isFavorites;
  final bool canReset;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final String title;
    final String body;
    if (hasQuery) {
      title = 'Piringannya belum ketemu.';
      body =
          'Tidak ada rilisan yang cocok dengan pencarianmu. '
          'Coba nama band atau judul album lain.';
    } else if (isFavorites) {
      title = 'Wishlist masih kosong.';
      body = 'Ketuk ikon hati pada sebuah rilisan untuk menyimpannya di sini.';
    } else {
      title = 'Rak ini masih kosong.';
      body = 'Belum ada rilisan pada filter ini.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.hairlineStrong),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 72,
            height: 72,
            child: CustomPaint(
              painter: VinylPainter(labelColor: AppColors.ochre),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppText.serif(size: 20, italic: true),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            textAlign: TextAlign.center,
            style: AppText.mono(
              size: 11.5,
              color: AppColors.inkSoft,
              height: 1.5,
            ),
          ),
          if (canReset) ...[
            const SizedBox(height: 18),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onReset,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Text(
                  'ATUR ULANG PENCARIAN & FILTER',
                  textAlign: TextAlign.center,
                  style: AppText.mono(
                    size: 10.5,
                    weight: FontWeight.w600,
                    color: AppColors.oxblood,
                    letterSpacing: 1.1,
                  ).copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
