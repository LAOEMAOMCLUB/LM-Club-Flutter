// homeEventPage helps to track all users actions to make API calls.

abstract class HomeEvent {
  HomeEvent._();

  factory HomeEvent.fetchWidgets() => FetchWidgets();
  factory HomeEvent.getUserDetails(id) => GetUserDetails(id);
  factory HomeEvent.getAllNotifications() => GetAllNotifications();
  factory HomeEvent.getReferalCode() => GetReferalCode();
  factory HomeEvent.deleteAccount() => DeleteAccount();
}

class FetchWidgets extends HomeEvent {
  FetchWidgets() : super._();
}

class GetUserDetails extends HomeEvent {
  final String id;
  GetUserDetails(this.id) : super._();
}

class GetAllNotifications extends HomeEvent {
  GetAllNotifications() : super._();
}

class GetReferalCode extends HomeEvent {
  GetReferalCode() : super._();
}

class DeleteAccount extends HomeEvent {
  DeleteAccount() : super._();
}
