import 'package:impariamo/03_contiamo/02_domain/domain.dart';

class HiveGuessTableProgressModel {
  final int tableNumber;
  final double averagepoints;
  final int total;

  HiveGuessTableProgressModel({
    required this.tableNumber,
    required this.averagepoints,
    required this.total,
  });

  factory HiveGuessTableProgressModel.fromMap(Map<dynamic, dynamic> map) {
    return HiveGuessTableProgressModel(
      tableNumber: map['tableNumber'] as int,
      averagepoints: (map['averagepoints'] as num).toDouble(),
      total: map['total'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tableNumber': tableNumber,
      'averagepoints': averagepoints,
      'total': total,
    };
  }

  GuessTableProgress toDomain() {
    return GuessTableProgress(
      tableNumber: tableNumber,
      averagePoints: averagepoints,
      total: total,
    );
  }

  factory HiveGuessTableProgressModel.fromDomain(GuessTableProgress domain) {
    return HiveGuessTableProgressModel(
      tableNumber: domain.tableNumber,
      averagepoints: domain.averagePoints,
      total: domain.total,
    );
  }
}
