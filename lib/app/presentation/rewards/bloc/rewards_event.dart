// rewardEvent helps to track all users actions to make API calls.
abstract class RewardsEvent {
  RewardsEvent._();
  factory RewardsEvent.getUserPoints() => GetUserPoints();
}

class GetUserPoints extends RewardsEvent {
  GetUserPoints() : super._();
}
