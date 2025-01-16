// planDetailEventPage helps to track all users actions to make API calls.
abstract class PlanDetailsEvent {
  PlanDetailsEvent._();

  factory PlanDetailsEvent.getplan(id) => GetPlan(id);
}

class GetPlan extends PlanDetailsEvent {
  final String id;
  GetPlan(this.id) : super._();
}
