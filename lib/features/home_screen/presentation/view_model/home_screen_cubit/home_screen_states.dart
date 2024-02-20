abstract class HomeScreenStates {}

class InitHomeScreenState extends HomeScreenStates {}

class SuccessGetHomeScreenBooks extends HomeScreenStates {}

class FailureGetHomeScreenBooks extends HomeScreenStates {
  final String message;

  FailureGetHomeScreenBooks(this.message);
}

class LoadingGetHomeScreenBooks extends HomeScreenStates {}
