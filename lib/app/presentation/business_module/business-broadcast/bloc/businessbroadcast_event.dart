import 'dart:io';
import 'package:lm_club/app/models/auth/request_model/business_broadcast_request_model.dart';
import 'package:lm_club/app/models/auth/response_model/broadcast_plan_response.dart';
import 'package:lm_club/app/models/auth/response_model/viewBroadcast_response.dart';

abstract class BusinessBroadcastEvent {
  BusinessBroadcastEvent._();
  factory BusinessBroadcastEvent.uploadImages(List<File> path) =>
      UploadImage(path);
  factory BusinessBroadcastEvent.fetchBroadcastPlans() => FetchBroadcastPlans();
factory BusinessBroadcastEvent.checkOut(String amount) =>
      CheckOut(amount);
       factory BusinessBroadcastEvent.uploadBusinessBroadcast(BusinessBroadcastModel model) =>
      UploadBusinessBroadcast(model);
      factory BusinessBroadcastEvent.uploadSavedBroadcast(BusinessBroadcastModel model) =>
      UploadDraftBusinessBroadcast(model);
        factory BusinessBroadcastEvent.viewBroadcastPost(id) => ViewBroadcastPost(id);
        factory BusinessBroadcastEvent.populateBroadcastDetails(ViewBroadcastDetails broadcastDetails) => PopulateBroadcastDetails(broadcastDetails);
factory BusinessBroadcastEvent.updatePromotion(String value) =>
      UpdatePromotion(value);

      factory BusinessBroadcastEvent.editDraftBusinessBroadcast(BusinessBroadcastModel model) =>
      EditDraftBusinessBroadcast(model);
       factory BusinessBroadcastEvent.deleteFile(String fileId , String postId) => DeleteFile(fileId , postId);
              factory BusinessBroadcastEvent.setselectedPlan(BroadcastPlan plan) => SetSelectedPlan(plan);

}

class CheckOut extends BusinessBroadcastEvent {
  final String amount;
  CheckOut(this.amount) : super._();
}


class UploadImage extends BusinessBroadcastEvent {
  List<File> path;
  UploadImage(this.path) : super._();
}

class FetchBroadcastPlans extends BusinessBroadcastEvent {
  FetchBroadcastPlans() : super._();
}
class UploadBusinessBroadcast extends BusinessBroadcastEvent {
  final BusinessBroadcastModel model;
  UploadBusinessBroadcast(this.model) : super._();
}
class UploadDraftBusinessBroadcast extends BusinessBroadcastEvent {
  final BusinessBroadcastModel model;
  UploadDraftBusinessBroadcast(this.model) : super._();
}
class ViewBroadcastPost extends BusinessBroadcastEvent {
  final String id;
  ViewBroadcastPost(this.id) : super._();
}
class PopulateBroadcastDetails extends BusinessBroadcastEvent{
  final ViewBroadcastDetails broadcastDetails;
  PopulateBroadcastDetails(this.broadcastDetails): super._();
}
class UpdatePromotion extends BusinessBroadcastEvent {
  String value ;
  UpdatePromotion(this.value) : super._();
}
class EditDraftBusinessBroadcast extends BusinessBroadcastEvent {
  final BusinessBroadcastModel model;
  EditDraftBusinessBroadcast(this.model) : super._();
}

class DeleteFile extends BusinessBroadcastEvent {
  final String fileId;
  final String postId;
  DeleteFile(this.fileId , this.postId) : super._();
}
class SetSelectedPlan extends BusinessBroadcastEvent {
  final BroadcastPlan plan;
  SetSelectedPlan(this.plan) : super._();
}