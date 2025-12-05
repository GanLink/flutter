import 'package:equatable/equatable.dart';

class CreateBovinueMetric extends Equatable {
  final int bovinueId;
  final int bovinueMPId;
  final String date;
  final int quantity;

  const CreateBovinueMetric({
    required this.bovinueId,
    required this.bovinueMPId,
    required this.date,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'bovinueId': bovinueId,
      'bovinueMPId': bovinueMPId,
      'date': date,
      'quantity': quantity,
    };
  }

  @override
  List<Object?> get props => [bovinueId, bovinueMPId, date, quantity];
}
