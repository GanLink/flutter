abstract class FarmEvent {
  const FarmEvent();
}

class FetchFarms extends FarmEvent {
  final int userId;

  const FetchFarms({required this.userId});
}
