class Farm {
  final int id;
  final String alias;
  final String mainActivity;
  final String ownerDni;
  final int userId;
  final String description;

  const Farm({
    required this.id,
    required this.alias,
    required this.mainActivity,
    required this.ownerDni,
    required this.userId,
    required this.description,
  });

  factory Farm.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final userIdValue = json['userId'] ?? json['user_id'];

    return Farm(
      id: idValue is String ? int.tryParse(idValue) ?? 0 : (idValue ?? 0),
      alias: json['alias'] ?? '',
      mainActivity:
          (json['mainActivity'] ?? json['main_activity'] ?? '').toString(),
      ownerDni: json['ownerDni'] ?? json['owner_dni'] ?? '',
      userId: userIdValue is String
          ? int.tryParse(userIdValue) ?? 0
          : (userIdValue ?? 0),
      description: json['description'] ?? '',
    );
  }

}
