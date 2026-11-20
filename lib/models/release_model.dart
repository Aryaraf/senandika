enum ReleaseFormat { vinyl, kaset, cd }

extension ReleaseFormatX on ReleaseFormat {
  String get label => switch (this) {
    ReleaseFormat.vinyl => 'Vinyl',
    ReleaseFormat.kaset => 'Kaset',
    ReleaseFormat.cd => 'CD',
  };

  String get detail => switch (this) {
    ReleaseFormat.vinyl => 'Vinyl LP 12',
    ReleaseFormat.kaset => 'Kaset Pita',
    ReleaseFormat.cd => 'Compact Disc',
  };
}

enum CatalogFilter { semua, vinyl, kaset, cd, favorit}

extension CatalogFilterX on CatalogFilter {
  String get label => switch (this) {
    CatalogFilter.semua => 'Semua',
    CatalogFilter.vinyl => 'Vinyl',
    CatalogFilter.kaset => 'Kaset',
    CatalogFilter.cd => 'CD',
    CatalogFilter.favorit => 'Favorit',
  };
}

class Release {
  const Release({
    required this.id,
    required this.title,
    required this.artist,
    required this.format,
    required this.year,
    required this.price,
    required this.note,
    required this.coverUrl,
    this.isFeatured = false,
  });

  final String id;
  final String title;
  final String artist;
  final ReleaseFormat format;
  final int year;
  final int price;
  final String note;
  final String coverUrl;
  final bool isFeatured;

  String get priceLabel => formatRupiah(price);
}

String formatRupiah(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    buffer.write(digits[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }
  return 'Rp ${buffer.toString()}';
}