import 'package:equatable/equatable.dart';

class Bovinue extends Equatable {
  final int id;
  final int farmId;

  const Bovinue({
    required this.id,
    required this.farmId,
  });

  factory Bovinue.fromJson(Map<String, dynamic> json) {
    return Bovinue(
      id: json['id'] as int,
      farmId: json['farmId'] as int,
    );
  }

  factory Bovinue.fromMap(Map<String, dynamic> map) {
    return Bovinue(
      id: map['id'],
      farmId: map['farmId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmId': farmId,
    };
  }

  @override
  List<Object?> get props => [id, farmId];
}
