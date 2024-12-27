// choosePlanEventPage helps to track all users actions to make API calls.

abstract class ChoosePlanEvent {
  ChoosePlanEvent._();

  factory ChoosePlanEvent.getAllPlans() => GetAllPlans();
  factory ChoosePlanEvent.updatePlanId(String id, String color) =>
      UpdatePlanId(id, color);
}

class GetAllPlans extends ChoosePlanEvent {
  GetAllPlans() : super._();
}

class UpdatePlanId extends ChoosePlanEvent {
  final String id;
  final String color;
  UpdatePlanId(this.id, this.color) : super._();
}
