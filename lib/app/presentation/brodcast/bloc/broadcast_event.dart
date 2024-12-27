import 'dart:io';

import 'package:lm_club/app/models/auth/request_model/broadcast_model.dart';
import 'package:lm_club/app/models/auth/request_model/profile_req_model.dart';
import 'package:lm_club/app/models/auth/request_model/sharePost_broadCast_model.dart';

abstract class BroadcastEvent {
  BroadcastEvent._();
  factory BroadcastEvent.uploadBroadcast(BroadcastModel model) =>
      UploadBroadcast(model);
  factory BroadcastEvent.updatePropertyImages(List<File> path) =>
      UploadImage(path);
  factory BroadcastEvent.updateSaveImage(String path) => SaveImage(path);

  factory BroadcastEvent.getBroadcasts(
          String selectedUserId, String selectedDuration) =>
      FetchBroadcasts(selectedUserId, selectedDuration);
  factory BroadcastEvent.uploadSavedBroadcast(BroadcastModel model) =>
      UploadSavedBroadcast(model);
  factory BroadcastEvent.getMyBroadcasts(String selectedDurationMyPosts) => FetchMyBroadcasts(selectedDurationMyPosts);
  factory BroadcastEvent.generateAcceratedUrl(ProfileRequestModel model) =>
      GenerateAcceratedUrl(model);
  factory BroadcastEvent.setUserId(String id) => SetUserId(id);
  factory BroadcastEvent.myShares() => MySharesBroadCast();
  factory BroadcastEvent.shareType() => ShareType();
  factory BroadcastEvent.sharePost(SharePostModel model) => SharePost(model);
  factory BroadcastEvent.selectDurationDates(String text) =>
      SelectDurationDates(text);
}

class UploadBroadcast extends BroadcastEvent {
  final BroadcastModel model;
  UploadBroadcast(this.model) : super._();
}

class UploadImage extends BroadcastEvent {
  //  final List<File> images;
  List<File> path;
  UploadImage(this.path) : super._();
}

class SaveImage extends BroadcastEvent {
  // final List<ImageModel> images;
  String path;
  SaveImage(this.path) : super._();
}

class FetchBroadcasts extends BroadcastEvent {
  final String selectedUserId;
  final String selectedDuration;
  FetchBroadcasts(this.selectedUserId, this.selectedDuration) : super._();
}

class UploadSavedBroadcast extends BroadcastEvent {
  final BroadcastModel model;
  UploadSavedBroadcast(this.model) : super._();
}

class FetchMyBroadcasts extends BroadcastEvent {
  final String selectedDurationMyPosts;
  FetchMyBroadcasts(this.selectedDurationMyPosts) : super._();
}

class GenerateAcceratedUrl extends BroadcastEvent {
  final ProfileRequestModel model;
  GenerateAcceratedUrl(this.model) : super._();
}

class SetUserId extends BroadcastEvent {
  final String id;
  SetUserId(this.id) : super._();
}

class SelectDurationDates extends BroadcastEvent {
  final String text;
  SelectDurationDates(this.text) : super._();
}

class MySharesBroadCast extends BroadcastEvent {
  MySharesBroadCast() : super._();
}

class ShareType extends BroadcastEvent {
  ShareType() : super._();
}

class SharePost extends BroadcastEvent {
  final SharePostModel model;
  SharePost(this.model) : super._();
}
