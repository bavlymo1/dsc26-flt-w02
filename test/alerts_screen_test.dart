import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dsc26_flt_w02/data/repositories/alert_repository.dart';
import 'package:dsc26_flt_w02/domain/models/stock_alert.dart';
import 'package:dsc26_flt_w02/ui/alerts/widgets/alerts_screen.dart';

void main() {
  final demoAlerts = [
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

  testWidgets('shows the most urgent alert first', (tester) async {
    await tester.pumpWidget(
      NourShelfApp(repository: InMemoryAlertRepository(demoAlerts)),
    );
    await tester.pumpAndSettle();

    final first = tester.getTopLeft(find.byKey(const Key('alert-insulin')));
    final second = tester.getTopLeft(find.byKey(const Key('alert-levo')));

    expect(first.dy, lessThan(second.dy));
  });
}
