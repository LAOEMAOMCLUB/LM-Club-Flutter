import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/broadcast_response.dart';
import 'package:lm_club/app/models/auth/response_model/enroll_response.dart';
import 'package:lm_club/app/models/auth/response_model/myShareBroadCast_response.dart';
import 'package:lm_club/app/models/auth/response_model/shareTypeBroadCast_response.dart';
import 'package:lm_club/app/models/image_model.dart';

// ignore: must_be_immutable
class BroadcastState extends Equatable {
  final bool? isSuccesful;
  final bool? isPostSuccessful;
  final bool isLoading;
  final EnrollResModel? data;
  final String? error;
  final String? uploadPost;
  final String? uploadPostDraft;
  final List<BroadcastDetails> broadcastDetails;
  final List<MySharesBroadcast> myShareBroadCast;
  final List<ShareTypeModel> shareType;
  final String? generatedResponse;
  List<ImageModel>? pImages;
  List<File>? imagePath;
  String? imagePathuploaded;
  final bool? isDraftSuccesful;
  final String? userId;
  final String? selectedDuration;
  final String? sharePost;
  BroadcastState(
      {required this.isSuccesful,
      required this.isLoading,
      required this.isPostSuccessful,
      this.uploadPost,
      this.uploadPostDraft,
      this.error,
      this.data,
      this.pImages,
      this.imagePath,
      this.generatedResponse,
      this.isDraftSuccesful,
      this.imagePathuploaded,
      this.userId,
      this.selectedDuration,
      this.sharePost,
      required this.shareType,
      required this.myShareBroadCast,
      required this.broadcastDetails});

  BroadcastState.init(this.data)
      : error = "",
        isLoading = false,
        isSuccesful = false,
        isPostSuccessful = false,
        uploadPost = '',
        uploadPostDraft = '',
        generatedResponse = '',
        isDraftSuccesful = false,
        pImages = [],
        imagePath = [],
        imagePathuploaded = '',
        userId = '',
        sharePost = '',
        selectedDuration = '',
        myShareBroadCast = [],
        shareType = [],
        broadcastDetails = [];

  @override
  List<Object?> get props => [
        isSuccesful,
        isPostSuccessful,
        isLoading,
        error,
        data,
        pImages,
        broadcastDetails,
        myShareBroadCast,
        uploadPostDraft,
        isDraftSuccesful,
        generatedResponse,
        uploadPost,
        imagePathuploaded,
        userId,
        selectedDuration,
        shareType,
        sharePost
      ];

  BroadcastState copyWith({
    String? error,
    bool? isLoading,
    bool? isSuccesful,
    bool? isPostSuccessful,
    bool? isDraftSuccesful,
    EnrollResModel? data,
    List<ImageModel>? pImages,
    List<BroadcastDetails>? broadcastDetails,
    List<MySharesBroadcast>? myShareBroadCast,
    List<ShareTypeModel>? shareType,
    List<File>? imagePath,
    String? imagePathuploaded,
    String? uploadPostDraft,
    String? generatedResponse,
    String? uploadPost,
    String? userId,
    String? sharePost,
    final String? selectedDuration,
  }) {
    return BroadcastState(
        isSuccesful: isSuccesful ?? this.isSuccesful,
        isPostSuccessful: isPostSuccessful ?? this.isPostSuccessful,
        error: error ?? this.error,
        data: data ?? this.data,
        isLoading: isLoading ?? this.isLoading,
        imagePath: imagePath ?? this.imagePath,
        uploadPost: uploadPost ?? uploadPost,
        uploadPostDraft: uploadPost ?? uploadPostDraft,
        generatedResponse: generatedResponse ?? generatedResponse,
        broadcastDetails: broadcastDetails ?? this.broadcastDetails,
        myShareBroadCast: myShareBroadCast ?? this.myShareBroadCast,
        isDraftSuccesful: isDraftSuccesful ?? this.isDraftSuccesful,
        pImages: pImages ?? this.pImages,
        userId: userId ?? this.userId,
        shareType: shareType ?? this.shareType,
        sharePost: sharePost ?? this.sharePost,
        selectedDuration: selectedDuration ?? this.selectedDuration,
        imagePathuploaded: imagePathuploaded ?? this.imagePathuploaded);
  }
}
