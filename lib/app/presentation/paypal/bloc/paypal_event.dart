// paypalEvent helps to track all users actions to make API calls.
abstract class PaypalEvent {
  PaypalEvent._();
  factory PaypalEvent.checkOut(String amount) => CheckOut(amount);
  factory PaypalEvent.renewalPay(String amount, String planId) =>
      RenewalPay(amount, planId);
}

class CheckOut extends PaypalEvent {
  final String amount;
  CheckOut(this.amount) : super._();
}

class RenewalPay extends PaypalEvent {
  final String amount;
  final String planId;
  RenewalPay(this.amount, this.planId) : super._();
}
