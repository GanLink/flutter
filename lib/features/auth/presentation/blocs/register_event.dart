abstract class RegisterEvent {
  const RegisterEvent();
}

class OnUsernameChanged extends RegisterEvent {
  final String username;
  const OnUsernameChanged({required this.username});
}

class OnFirstNameChanged extends RegisterEvent {
  final String firstName;
  const OnFirstNameChanged({required this.firstName});
}

class OnLastNameChanged extends RegisterEvent {
  final String lastName;
  const OnLastNameChanged({required this.lastName});
}

class OnEmailChanged extends RegisterEvent {
  final String email;
  const OnEmailChanged({required this.email});
}

class OnRucChanged extends RegisterEvent {
  final String ruc;
  const OnRucChanged({required this.ruc});
}

class OnPasswordChanged extends RegisterEvent {
  final String password;
  const OnPasswordChanged({required this.password});
}

class TogglePasswordVisibility extends RegisterEvent {
  const TogglePasswordVisibility();
}

class Register extends RegisterEvent {
  const Register();
}
