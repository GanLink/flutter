import 'package:equatable/equatable.dart';

class BovinueMetric extends Equatable {
  final int id;
  final int bovinueId;
  final int bovinueMPId;
  final String categoryName;
  final String parameterName;
  final int quantity;
  final String date;
  final String createdDate;
  final String updatedDate;

  const BovinueMetric({
    required this.id,
    required this.bovinueId,
    required this.bovinueMPId,
    required this.categoryName,
    required this.parameterName,
    required this.quantity,
    required this.date,
    required this.createdDate,
    required this.updatedDate,
  });

  factory BovinueMetric.fromJson(Map<String, dynamic> json) {
    return BovinueMetric(
      id: json['id'] as int,
      bovinueId: json['bovinueId'] as int,
      bovinueMPId: json['bovinueMPId'] as int,
      categoryName: json['categoryName'] as String? ?? '',
      parameterName: json['parameterName'] as String? ?? '',
      quantity: json['quantity'] as int,
      date: json['date'] as String? ?? '',
      createdDate: json['createdDate'] as String? ?? '',
      updatedDate: json['updatedDate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bovinueId': bovinueId,
      'bovinueMPId': bovinueMPId,
      'categoryName': categoryName,
      'parameterName': parameterName,
      'quantity': quantity,
      'date': date,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
    };
  }

  BovinueMetric copyWith({
    int? id,
    int? bovinueId,
    int? bovinueMPId,
    String? categoryName,
    String? parameterName,
    int? quantity,
    String? date,
    String? createdDate,
    String? updatedDate,
  }) {
    return BovinueMetric(
      id: id ?? this.id,
      bovinueId: bovinueId ?? this.bovinueId,
      bovinueMPId: bovinueMPId ?? this.bovinueMPId,
      categoryName: categoryName ?? this.categoryName,
      parameterName: parameterName ?? this.parameterName,
      quantity: quantity ?? this.quantity,
      date: date ?? this.date,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        bovinueId,
        bovinueMPId,
        categoryName,
        parameterName,
        quantity,
        date,
        createdDate,
        updatedDate,
      ];
}
