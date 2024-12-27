// referEarnEventpage helps to track all users actions to make API calls.

abstract class ReferEarnEvent {
  ReferEarnEvent._();

  factory ReferEarnEvent.getReferalCode() => GetReferalCode();
}

class GetReferalCode extends ReferEarnEvent {
  GetReferalCode() : super._();
}
