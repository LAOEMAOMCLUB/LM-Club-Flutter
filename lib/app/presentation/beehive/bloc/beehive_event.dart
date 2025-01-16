// beehiveEventPage helps to track all users actions to make API calls.

import 'dart:io';
import 'package:lm_club/app/models/auth/request_model/saveOrLike_model.dart';
import 'package:lm_club/app/models/auth/response_model/categories_response.dart';
import '../../../models/auth/request_model/beehive_model.dart';

abstract class BeehiveEvent {
  BeehiveEvent._();

  factory BeehiveEvent.getBeehivePosts(List<String> selectedCategoryIdsAsString,
          String selectedUserId, String selectedDuration) =>
      GetBeehivePosts(
          selectedCategoryIdsAsString, selectedUserId, selectedDuration);

  factory BeehiveEvent.mySavedPosts(List<String> selectedCategoryIdsAsString,
          String selectedUserId, String selectedDuration) =>
      GetSavedBeehivePosts(
          selectedCategoryIdsAsString, selectedUserId, selectedDuration);
  factory BeehiveEvent.myPostsBeehive(
          List<String> selectedPostCategory, String selectedPostDuration) =>
      GetBeehiveMyPosts(selectedPostCategory, selectedPostDuration);
  factory BeehiveEvent.getBeehiveCategories() => GetBeehiveCategories();
  factory BeehiveEvent.updateBeehiveCategory(BeehiveCategory category) =>
      UpdateBeehiveCategory(category);
  factory BeehiveEvent.getCategoryIdSelection(String id) =>
      GetCategoryIdSelection(id);
  factory BeehiveEvent.selectDurationDates(String text) =>
      SelectDurationDates(text);
  factory BeehiveEvent.setUserId(String id) => SetUserId(id);
  factory BeehiveEvent.uploadBeehivePost(BeehiveModel model) =>
      UploadBeehivePost(model);
  factory BeehiveEvent.uploadImages(List<File> path) => UploadImage(path);
  factory BeehiveEvent.savePostId(String id) => SavePost(id);
  factory BeehiveEvent.unSavePost() => UnSavePost();
  factory BeehiveEvent.likePost() => LikePost();
  factory BeehiveEvent.unLikePost() => UnLikePost();
  factory BeehiveEvent.saveOrLikePosts(SaveOrLikeModel model) =>
      SaveOrLikePost(model);
}

class GetBeehivePosts extends BeehiveEvent {
  final List<String> selectedCategoryIdsAsString;
  final String selectedUserId;
  final String selectedDuration;
  GetBeehivePosts(this.selectedCategoryIdsAsString, this.selectedUserId,
      this.selectedDuration)
      : super._();
}

class GetSavedBeehivePosts extends BeehiveEvent {
  final List<String> selectedCategoryIdsAsString;
  final String selectedUserId;
  final String selectedDuration;
  GetSavedBeehivePosts(this.selectedCategoryIdsAsString, this.selectedUserId,
      this.selectedDuration)
      : super._();
}

class GetBeehiveMyPosts extends BeehiveEvent {
  final List<String> selectedPostCategory;

  final String selectedPostDuration;
  GetBeehiveMyPosts(this.selectedPostCategory, this.selectedPostDuration)
      : super._();
}

class GetBeehiveCategories extends BeehiveEvent {
  GetBeehiveCategories() : super._();
}

class UpdateBeehiveCategory extends BeehiveEvent {
  final BeehiveCategory category;
  UpdateBeehiveCategory(this.category) : super._();
}

class GetCategoryIdSelection extends BeehiveEvent {
  final String id;
  GetCategoryIdSelection(this.id) : super._();
}

class SetUserId extends BeehiveEvent {
  final String id;
  SetUserId(this.id) : super._();
}

class SelectDurationDates extends BeehiveEvent {
  final String text;
  SelectDurationDates(this.text) : super._();
}

class UploadBeehivePost extends BeehiveEvent {
  final BeehiveModel model;
  UploadBeehivePost(this.model) : super._();
}

class UploadImage extends BeehiveEvent {
  List<File> path;
  UploadImage(this.path) : super._();
}

class SaveOrLikePost extends BeehiveEvent {
  final SaveOrLikeModel model;
  SaveOrLikePost(this.model) : super._();
}

class SavePost extends BeehiveEvent {
  final String? id;
  SavePost(this.id) : super._();
}

class UnSavePost extends BeehiveEvent {
  UnSavePost() : super._();
}

class LikePost extends BeehiveEvent {
  LikePost() : super._();
}

class UnLikePost extends BeehiveEvent {
  UnLikePost() : super._();
}
