import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/broadcast_plan_response.dart';
import 'package:lm_club/app/models/auth/response_model/checkout_response.dart';
import 'package:lm_club/app/models/auth/response_model/viewBroadcast_response.dart';

class ImageModel {
  final int id;
  final String value;

  ImageModel(this.id, this.value);
}

class BusinessBroadcastState extends Equatable {
  final bool? isSuccesful;
  final bool isLoading;
  final List<File>? imagePath;
  final String? error;
  final List<BroadcastPlan>? broadcastPlanDetails;
  final String? message;
  final bool? isSuccesfulPayment;
  final CheckoutResponse? data;
  final String? uploadPostMessage;
  final bool? isDraftSuccesful;
  final ViewBroadcastDetails? broadcastDetails;
  final String? uploadPostDraftMessage;
  final List<String>? pImages;
  final String? postDurationText;
  final String? promotingText;
  final int? postDurationId;
  final List<ImageModel>? postedMedia;
  final String? deleteFileMessage;
  final bool? isSuccesfulDelete;
  final BroadcastPlan? selectedPlan;
  const BusinessBroadcastState(
      {required this.isSuccesful,
      required this.isLoading,
      this.error,
      this.imagePath,
      this.broadcastPlanDetails,
      this.message,
      this.data,
      this.isSuccesfulPayment,
      this.uploadPostMessage,
      this.uploadPostDraftMessage,
      this.isDraftSuccesful,
      this.broadcastDetails,
      this.pImages,
      this.promotingText,
      this.postDurationText,
      this.postDurationId,
      this.postedMedia,
      this.deleteFileMessage,
      this.isSuccesfulDelete,
      this.selectedPlan});

  BusinessBroadcastState.init(this.data)
      : error = "",
        isLoading = false,
        imagePath = [],
        broadcastPlanDetails = [],
        message = '',
        isSuccesfulPayment = false,
        uploadPostMessage = '',
        isDraftSuccesful = false,
        uploadPostDraftMessage = '',
        broadcastDetails = null,
        pImages = [],
        promotingText = '',
        postDurationText = '',
        postDurationId = null,
        isSuccesful = false,
        deleteFileMessage = '',
        isSuccesfulDelete = false,
        postedMedia = [],
        selectedPlan = BroadcastPlan();

  @override
  List<Object?> get props => [
        isSuccesful,
        isLoading,
        error,
        broadcastPlanDetails,
        data,
        isSuccesfulPayment,
        uploadPostMessage,
        message,
        uploadPostDraftMessage,
        isDraftSuccesful,
        pImages,
        promotingText,
        postDurationText,
        broadcastDetails,
        postDurationId,
        postedMedia,
        isSuccesfulDelete,
        deleteFileMessage,
        selectedPlan
      ];

  BusinessBroadcastState copyWith(
      {String? error,
      bool? isLoading,
      bool? isSuccesful,
      List<File>? imagePath,
      List<BroadcastPlan>? broadcastPlanDetails,
      String? message,
      CheckoutResponse? data,
      bool? isSuccesfulPayment,
      String? uploadPostMessage,
      String? uploadPostDraftMessage,
      bool? isDraftSuccesful,
      ViewBroadcastDetails? broadcastDetails,
      List<String>? pImages,
      String? promotingText,
      int? postDurationId,
      String? postDurationText,
      List<ImageModel>? postedMedia,
      String? deleteFileMessage,
      bool? isSuccesfulDelete,
      BroadcastPlan? selectedPlan}) {
    return BusinessBroadcastState(
        isSuccesful: isSuccesful ?? this.isSuccesful,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
        imagePath: imagePath ?? this.imagePath,
        broadcastPlanDetails: broadcastPlanDetails ?? this.broadcastPlanDetails,
        message: message ?? this.message,
        data: data ?? this.data,
        uploadPostMessage: uploadPostMessage ?? this.uploadPostMessage,
        isSuccesfulPayment: isSuccesfulPayment ?? this.isSuccesfulPayment,
        isDraftSuccesful: isDraftSuccesful ?? this.isDraftSuccesful,
        uploadPostDraftMessage:
            uploadPostDraftMessage ?? this.uploadPostDraftMessage,
        broadcastDetails: broadcastDetails ?? this.broadcastDetails,
        pImages: pImages ?? this.pImages,
        promotingText: promotingText ?? this.promotingText,
        postDurationText: postDurationText ?? this.postDurationText,
        postDurationId: postDurationId ?? this.postDurationId,
        postedMedia: postedMedia ?? this.postedMedia,
        isSuccesfulDelete: isSuccesfulDelete ?? this.isSuccesfulDelete,
        deleteFileMessage: deleteFileMessage ?? this.deleteFileMessage, 
        selectedPlan: selectedPlan ?? this.selectedPlan);
  }
}
