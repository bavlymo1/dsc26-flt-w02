import 'package:flutter/material.dart';
import 'data/repositories/alert_repository.dart';
import 'domain/models/stock_alert.dart';
import 'ui/alerts/widgets/alerts_screen.dart';

void main() {
  final sampleAlerts = [
    const StockAlert(
      id: 'insulin',
      medicineNameEn: 'Insulin Glargine',
      medicineNameAr: 'انسولين جلارجين',
      severity: Severity.critical,
      daysOfCover: 2,
      branchCode: 'B01',
    ),
    const StockAlert(
      id: 'levo',
      medicineNameEn: 'Levothyroxine',
      medicineNameAr: 'ليفوتيروكسين',
      severity: Severity.high,
      daysOfCover: 6,
      branchCode: 'B01',
    ),
  ];

  final repository = InMemoryAlertRepository(sampleAlerts);

  runApp(NourShelfApp(repository: repository));
}