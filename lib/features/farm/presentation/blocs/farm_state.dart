import 'package:ganlink/core/enums/status.dart';
import 'package:ganlink/features/farm/domain/farm.dart';

class FarmState {
  final List<Farm> farms;
  final Status status;
  final String message;

  const FarmState({
    this.farms = const [],
    this.status = Status.initial,
    this.message = '',
  });

  FarmState copyWith({
    List<Farm>? farms,
    Status? status,
    String? message,
  }) {
    return FarmState(
      farms: farms ?? this.farms,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
