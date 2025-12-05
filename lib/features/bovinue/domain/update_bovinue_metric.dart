import 'package:equatable/equatable.dart';

class UpdateBovinueMetric extends Equatable {
  final int id;
  final int bovinueId;
  final int bovinueMPId;
  final String date;
  final int quantity;

  const UpdateBovinueMetric({
    required this.id,
    required this.bovinueId,
    required this.bovinueMPId,
    required this.date,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bovinueId': bovinueId,
      'bovinueMPId': bovinueMPId,
      'date': date,
      'quantity': quantity,
    };
  }

  @override
  List<Object?> get props => [id, bovinueId, bovinueMPId, date, quantity];
}
