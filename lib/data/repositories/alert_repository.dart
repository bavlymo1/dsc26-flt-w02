import '../../domain/models/stock_alert.dart';

abstract class AlertRepository {
  Future<List<StockAlert>> fetchAlerts();
  Future<void> acknowledge(String alertId);
}

class InMemoryAlertRepository implements AlertRepository {
  InMemoryAlertRepository(this._alerts);
  final List<StockAlert> _alerts;

  @override
  Future<List<StockAlert>> fetchAlerts() async => List.of(_alerts);

  @override
  Future<void> acknowledge(String alertId) async {}
}