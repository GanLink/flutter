abstract class FarmFormEvent {
  const FarmFormEvent();
}

class AliasChanged extends FarmFormEvent {
  final String alias;
  const AliasChanged(this.alias);
}

class DescriptionChanged extends FarmFormEvent {
  final String description;
  const DescriptionChanged(this.description);
}

class ActivityChanged extends FarmFormEvent {
  final int activity;
  const ActivityChanged(this.activity);
}

class OwnerDniChanged extends FarmFormEvent {
  final String ownerDni;
  const OwnerDniChanged(this.ownerDni);
}

class SubmitFarm extends FarmFormEvent {
  final int userId;
  const SubmitFarm({required this.userId});
}

class ResetFarmForm extends FarmFormEvent {
  const ResetFarmForm();
}
