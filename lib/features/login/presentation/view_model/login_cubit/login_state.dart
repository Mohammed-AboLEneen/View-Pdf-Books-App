abstract class LoginStates {}

class InitLoginState extends LoginStates {}

class SuccessLoginState extends LoginStates {}

class FailureLoginState extends LoginStates {
  final String message;

  FailureLoginState(this.message);
}

class LoadingLoginState extends LoginStates {}
