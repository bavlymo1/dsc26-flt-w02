import 'package:flutter/foundation.dart';
import '../../../data/repositories/alert_repository.dart';
import '../../../domain/models/stock_alert.dart';

class AlertsViewModel extends ChangeNotifier {
  AlertsViewModel({required this._repository});

  final AlertRepository _repository;

  List<StockAlert> _alerts = const [];
  bool _loading = false;
  final Set<Severity> _activeFilters = {};
  String _query = '';

  bool get loading => _loading;
  Set<Severity> get activeFilters => Set.unmodifiable(_activeFilters);
  String get query => _query;

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    _alerts = await _repository.fetchAlerts();

    _loading = false;
    notifyListeners();
  }

  void toggleFilter(Severity severity) {
    if (_activeFilters.contains(severity)) {
      _activeFilters.remove(severity);
    } else {
      _activeFilters.add(severity);
    }
    notifyListeners();
  }

  void setQuery(String newQuery) {
    final normalized = _normalizeText(newQuery);
    if (_normalizeText(_query) == normalized) return;
    _query = newQuery;
    notifyListeners();
  }

  Future<void> acknowledge(String alertId) async {
    final index = _alerts.indexWhere((a) => a.id == alertId);
    if (index == -1) return;

    final alert = _alerts[index];
    if (alert.acknowledged) return;

    await _repository.acknowledge(alertId);

    final updated = alert.copyWith(acknowledged: true);
    _alerts = List.of(_alerts)..[index] = updated;
    notifyListeners();
  }

  List<StockAlert> get visibleAlerts {
    final normalizedQuery = _normalizeText(_query);

    final filtered = _alerts.where((alert) {
      if (_activeFilters.isNotEmpty &&
          !_activeFilters.contains(alert.severity)) {
        return false;
      }

      if (normalizedQuery.isNotEmpty) {
        final normEn = _normalizeText(alert.medicineNameEn);
        final normAr = _normalizeText(alert.medicineNameAr);
        if (!normEn.contains(normalizedQuery) &&
            !normAr.contains(normalizedQuery)) {
          return false;
        }
      }

      return true;
    }).toList();

    filtered.sort((a, b) {
      if (a.acknowledged != b.acknowledged) {
        return a.acknowledged ? 1 : -1;
      }

      final severityCompare = a.severity.index.compareTo(b.severity.index);
      if (severityCompare != 0) return severityCompare;

      final coverCompare = a.daysOfCover.compareTo(b.daysOfCover);
      if (coverCompare != 0) return coverCompare;

      return a.medicineNameEn
          .toLowerCase()
          .compareTo(b.medicineNameEn.toLowerCase());
    });

    return List.unmodifiable(filtered);
  }

  int get totalCount => visibleAlerts.length;

  static String _normalizeText(String input) {
    var text = input.trim().toLowerCase();

    text = text.replaceAll(RegExp(r'[أإآ]'), 'ا');
    text = text.replaceAll('ة', 'ه');
    text = text.replaceAll('ى', 'ي');
    text = text.replaceAll('ـ', '');
    text = text.replaceAll(RegExp(r'[\u064B-\u0652]'), '');

    return text;
  }
}