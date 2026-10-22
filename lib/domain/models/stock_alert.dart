enum Severity { critical, high, medium, low }

class StockAlert {
  final String id;
  final String medicineNameEn;
  final String medicineNameAr;
  final Severity severity;
  final double daysOfCover;
  final String branchCode;
  final bool acknowledged;

  const StockAlert({
    required this.id,
    required this.medicineNameEn,
    required this.medicineNameAr,
    required this.severity,
    required this.daysOfCover,
    required this.branchCode,
    this.acknowledged = false,
  });

  factory StockAlert.fromJson(Map<String, Object?> json) {
    final id = json['id'];
    if (id is! String || id.isEmpty) {
      throw const FormatException('id must be a non-empty string');
    }

    final nameEn = json['medicineNameEn'];
    if (nameEn is! String || nameEn.isEmpty) {
      throw const FormatException('medicineNameEn must be a non-empty string');
    }

    final nameAr = json['medicineNameAr'];
    if (nameAr is! String || nameAr.isEmpty) {
      throw const FormatException('medicineNameAr must be a non-empty string');
    }

    final rawSeverity = json['severity'];
    if (rawSeverity is! String) {
      throw const FormatException('severity must be a string');
    }
    final severity = Severity.values
        .where((s) => s.name == rawSeverity.toLowerCase())
        .firstOrNull;
    if (severity == null) {
      throw FormatException('unknown severity: $rawSeverity');
    }

    final days = json['daysOfCover'];
    if (days is! num || days < 0) {
      throw FormatException('bad daysOfCover: $days');
    }

    final branch = json['branchCode'];
    if (branch is! String || branch.isEmpty) {
      throw const FormatException('branchCode must be a non-empty string');
    }

    final ack = json['acknowledged'];
    final acknowledged = ack is bool ? ack : false;

    return StockAlert(
      id: id,
      medicineNameEn: nameEn,
      medicineNameAr: nameAr,
      severity: severity,
      daysOfCover: days.toDouble(),
      branchCode: branch,
      acknowledged: acknowledged,
    );
  }

  StockAlert copyWith({
    String? id,
    String? medicineNameEn,
    String? medicineNameAr,
    Severity? severity,
    double? daysOfCover,
    String? branchCode,
    bool? acknowledged,
  }) {
    return StockAlert(
      id: id ?? this.id,
      medicineNameEn: medicineNameEn ?? this.medicineNameEn,
      medicineNameAr: medicineNameAr ?? this.medicineNameAr,
      severity: severity ?? this.severity,
      daysOfCover: daysOfCover ?? this.daysOfCover,
      branchCode: branchCode ?? this.branchCode,
      acknowledged: acknowledged ?? this.acknowledged,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockAlert &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          medicineNameEn == other.medicineNameEn &&
          medicineNameAr == other.medicineNameAr &&
          severity == other.severity &&
          daysOfCover == other.daysOfCover &&
          branchCode == other.branchCode &&
          acknowledged == other.acknowledged;

  @override
  int get hashCode =>
      id.hashCode ^
      medicineNameEn.hashCode ^
      medicineNameAr.hashCode ^
      severity.hashCode ^
      daysOfCover.hashCode ^
      branchCode.hashCode ^
      acknowledged.hashCode;
}