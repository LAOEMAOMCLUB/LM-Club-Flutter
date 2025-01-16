// beehiveStatePage used to display UI and manage Models.

import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/beehive_response.dart';
import 'package:lm_club/app/models/auth/response_model/categories_response.dart';
import 'package:lm_club/app/models/auth/response_model/myPostbeehive_response.dart';
import 'package:lm_club/app/models/auth/response_model/savedBeehive_response.dart';
import '../../../models/auth/response_model/saveOrLikePost_response.dart';

class BeehiveState extends Equatable {
  final bool isSuccesful;
  final bool? isSaveOrLike;
  final bool isLoading;
  final String? error;
  final BeehiveResponse? data;
  final SaveOrLikePostResponse? saveOrLikePostResponse;
  final List<String>? selectedCategoryIds;
  final List<BeehiveDetails> beehiveDetails;
  final List<BeehiveCategory>? beehiveCategories;
  final List<MyPostBeehiveDetails> mypostbeehiveDetails;
  final List<MyPostBeehiveCategory>? myPostBeehiveCategories;
  final List<PostModel> savedbeehivePosts;
  final String? categoryId;
  final String? categoryName;
  final String? userId;
  final String? selectedDuration;
  final String? uploadBeehivePost;
  final String? postId;
  final List<File>? imagePath;
  const BeehiveState({
    required this.isSuccesful,
    this.isSaveOrLike,
    required this.isLoading,
    required this.mypostbeehiveDetails,
    this.myPostBeehiveCategories,
    this.saveOrLikePostResponse,
    this.error,
    this.data,
    this.userId,
    this.postId,
    this.beehiveCategories,
    this.selectedCategoryIds,
    this.categoryId,
    this.categoryName,
    this.selectedDuration,
    required this.beehiveDetails,
    required this.savedbeehivePosts,
    this.uploadBeehivePost,
    this.imagePath,
  });

  BeehiveState.init(this.data, this.saveOrLikePostResponse)
      : error = "",
        isLoading = false,
        beehiveDetails = [],
        beehiveCategories = [],
        savedbeehivePosts = [],
        myPostBeehiveCategories = [],
        mypostbeehiveDetails = [],
        uploadBeehivePost = '',
        postId = '',
        imagePath = [],
        categoryId = '',
        categoryName = '',
        selectedCategoryIds = [],
        userId = '',
        selectedDuration = '',
        isSuccesful = false,
        isSaveOrLike = false;

  @override
  List<Object?> get props => [
        isSuccesful,
        isSaveOrLike,
        isLoading,
        error,
        data,
        categoryId,
        myPostBeehiveCategories,
        mypostbeehiveDetails,
        categoryName,
        beehiveDetails,
        beehiveCategories,
        selectedCategoryIds,
        userId,
        saveOrLikePostResponse,
        selectedDuration,
        imagePath,
        uploadBeehivePost,
        postId,
        savedbeehivePosts
      ];

  BeehiveState copyWith(
      {String? error,
      bool? isLoading,
      bool? isSuccesful,
      bool? isSaveOrLike,
      BeehiveResponse? data,
      String? categoryId,
      String? categoryName,
      List<File>? imagePath,
      String? uploadBeehivePost,
      SaveOrLikePostResponse? saveOrLikePostResponse,
      final String? userId,
      final String? selectedDuration,
      final List<String>? selectedCategoryIds,
      List<BeehiveDetails>? beehiveDetails,
      List<MyPostBeehiveDetails>? mypostbeehiveDetails,
      List<PostModel>? savedbeehivePosts,
      final String? postId,
      List<BeehiveCategory>? beehiveCategories,
      List<MyPostBeehiveCategory>? myPostBeehiveCategories}) {
    return BeehiveState(
        isSuccesful: isSuccesful ?? this.isSuccesful,
        isSaveOrLike: isSaveOrLike ?? this.isSaveOrLike,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
        data: data ?? this.data,
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        userId: userId ?? this.userId,
        saveOrLikePostResponse:
            saveOrLikePostResponse ?? this.saveOrLikePostResponse,
        beehiveCategories: beehiveCategories ?? this.beehiveCategories,
        beehiveDetails: beehiveDetails ?? this.beehiveDetails,
        uploadBeehivePost: uploadBeehivePost ?? uploadBeehivePost,
        postId: postId ?? this.postId,
        imagePath: imagePath ?? this.imagePath,
        myPostBeehiveCategories:
            myPostBeehiveCategories ?? this.myPostBeehiveCategories,
        mypostbeehiveDetails: mypostbeehiveDetails ?? this.mypostbeehiveDetails,
        selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
        savedbeehivePosts: savedbeehivePosts ?? this.savedbeehivePosts,
        selectedDuration: selectedDuration ?? this.selectedDuration);
  }
}
