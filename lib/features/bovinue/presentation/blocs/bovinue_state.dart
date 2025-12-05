import 'package:equatable/equatable.dart';
import '../../../../core/enums/status.dart';
import '../../domain/bovinue.dart';

class BovinueState extends Equatable {
  final Status status;
  final List<Bovinue> bovinues;
  final String? errorMessage;

  const BovinueState({
    this.status = Status.initial,
    this.bovinues = const [],
    this.errorMessage,
  });

  BovinueState copyWith({
    Status? status,
    List<Bovinue>? bovinues,
    String? errorMessage,
  }) {
    return BovinueState(
      status: status ?? this.status,
      bovinues: bovinues ?? this.bovinues,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bovinues, errorMessage];
}
