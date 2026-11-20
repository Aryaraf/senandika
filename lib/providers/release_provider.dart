import 'package:flutter/foundation.dart';

import '../data/dummy_releases.dart';
import '../models/release_model.dart';

class ReleaseProvider with ChangeNotifier {
  ReleaseProvider({List<Release>? releases})
      : _releases = List<Release>.unmodifiable(releases ?? dummyReleases);


  final List<Release> _releases;
  final Set<String> _favoriteIds = <String>{};
  String _query = '';
  CatalogFilter _activeFilter = CatalogFilter.semua;


  List<Release> get releases => _releases;
  String get query => _query;
  CatalogFilter get activeFilter => _activeFilter;

  bool get hasQuery => _query.trim().isNotEmpty;

  bool get isBrowsingAll => !hasQuery && _activeFilter == CatalogFilter.semua;

  Release? get featured {
    for (final release in _releases) {
      if (release.isFeatured) return release;
    }
    return _releases.isEmpty ? null : _releases.first;
  }

  List<Release> get visibleReleases {
    final keyword = _query.trim().toLowerCase();
    return _releases.where((release) {
      if (!_matchesFilter(release, _activeFilter)) return false;
      if (keyword.isEmpty) return true;
      return release.title.toLowerCase().contains(keyword) ||
          release.artist.toLowerCase().contains(keyword);
    }).toList(growable: false);
  }

  int get favoriteCount =>
      _releases.where((releases) => _favoriteIds.contains(releases.id)).length;

  int get wishlistTotal => _releases
      .where((release) => _favoriteIds.contains(release.id))
      .fold<int>(0, (sum, release) => sum + release.price);

  bool isFavorite(String id) => _favoriteIds.contains(id);

  int countFor(CatalogFilter filter) =>
      _releases.where((release) => _matchesFilter(release, filter)).length;

  void setQuery(String value) {
    if (value == _query) return;
    _query = value;
    notifyListeners();
  }    

  void setFilter(CatalogFilter filter) {
    if (filter == _activeFilter) return;
    _activeFilter = filter;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    if (!_favoriteIds.add(id)) {
      _favoriteIds.remove(id);
    }
    notifyListeners();
  }

  void reset() {
    _query = '';
    _activeFilter = CatalogFilter.semua;
    notifyListeners();
  }

  bool _matchesFilter(Release release, CatalogFilter filter) {
    return switch (filter) {
      CatalogFilter.semua => true,
      CatalogFilter.vinyl => release.format == ReleaseFormat.vinyl,
      CatalogFilter.kaset => release.format == ReleaseFormat.kaset,
      CatalogFilter.cd => release.format == ReleaseFormat.cd,
      CatalogFilter.favorit => _favoriteIds.contains(release.id),
    };
  }
}