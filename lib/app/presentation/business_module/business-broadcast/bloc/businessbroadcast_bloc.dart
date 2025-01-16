import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:lm_club/app/models/auth/request_model/business_broadcast_request_model.dart';
import 'package:lm_club/app/models/auth/response_model/viewBroadcast_response.dart';
import 'package:lm_club/app/presentation/business_module/business-broadcast/bloc/businessbroadcast_event.dart';
import 'package:lm_club/app/presentation/business_module/business-broadcast/bloc/businessbroadcast_state.dart';
import 'package:lm_club/utils/string_extention.dart';
import 'package:lm_club/utils/globals.dart' as globals;

import '../../../../models/auth/response_model/broadcast_plan_response.dart';

@injectable
class BusinessBroadcastBloc
    extends Bloc<BusinessBroadcastEvent, BusinessBroadcastState> {
  final HomeUsecase _homeUsecase;
  final businessBroadcastFormKey = GlobalKey<FormState>();
  List<File> imagePath = [];
  String? promotingText = '';
  int? postDurationId;
  final webFormKey = GlobalKey<FormState>();
  late BusinessBroadcastModel request;
  TextEditingController amountController = TextEditingController();
  TextEditingController nonceController = TextEditingController();
  TextEditingController validFromController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController postDurationController = TextEditingController();
  TextEditingController promotingController = TextEditingController();
  TextEditingController isDraftController = TextEditingController();
  TextEditingController couponCodeController = TextEditingController();
  TextEditingController postDurationIdController = TextEditingController();
  BusinessBroadcastBloc(this._homeUsecase)
      : super(BusinessBroadcastState.init(null)) {
    on<SetSelectedPlan>(
      (event, emit) {
        emit(state.copyWith(
          selectedPlan: event.plan,
        ));
      },
    );

    on<UploadImage>(
      (event, emit) {
        imagePath = event.path;
        emit(state.copyWith(isLoading: true));
        emit(state.copyWith(
          isLoading: false,
          imagePath: event.path,
          error: "",
        ));
      },
    );

    on<UpdatePromotion>(
      (event, emit) {
        promotingText = event.value;
        emit(state.copyWith(isLoading: true));
        emit(state.copyWith(
          isLoading: false,
          promotingText: event.value,
          error: "",
        ));
      },
    );
    on<FetchBroadcastPlans>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          final response = await _homeUsecase.getBroadcastPlans();
          if ((state.postDurationId ?? 0) > 0) {
            setselectedPlan(response.data
                .firstWhere((model) => model.id == state.postDurationId));
          }
          emit(state.copyWith(
            error: "",
            isLoading: false,
            broadcastPlanDetails: response.data,
            //  loggedIn: loggedIn,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchBroadcastDetails ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              broadcastPlanDetails: null,
              error: e.errorMessage(),
              //loggedIn: loggedIn,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              broadcastPlanDetails: null,
              error: e.toString(),
              //loggedIn: loggedIn,
            ));
          }
        }
      },
    );
    on<CheckOut>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true, error: "", isSuccesfulPayment: false));
        try {
          String userIdStr = globals.userId;
          int userIdInt = int.parse(userIdStr);
          double parsedAmount = double.parse(event.amount);

          // Format the double to have 2 decimal places
          String formattedAmount = parsedAmount.toStringAsFixed(2);
          Map<String, dynamic> params = {
            'amount': formattedAmount,
            'userId': userIdInt,
            'payment_for': "Broadcast"
          };

          final response = await _homeUsecase.broadcastCheckOut(params);
          // uploadBusinessBroadcast(request);
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isSuccesfulPayment: true,
              message: response.message,
              data: response));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false,
              error: de.errorMessage(),
              isSuccesfulPayment: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false,
              error: e.toString(),
              isSuccesfulPayment: false));
        }
      },
    );
    on<UploadBusinessBroadcast>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true,
            error: "",
            isSuccesful: false,
            isSuccesfulPayment: false));
        try {
          final response =
              await _homeUsecase.uploadBusinessBroadcast(event.model);
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isSuccesful: true,
              uploadPostMessage: response.message
              // data: response,
              ));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false, error: de.errorMessage(), isSuccesful: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false, error: e.toString(), isSuccesful: false));
        }
      },
    );

    on<EditDraftBusinessBroadcast>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true,
            error: "",
            isSuccesful: false,
            isSuccesfulPayment: false));
        try {
          final response =
              await _homeUsecase.editBusinessBroadcast(event.model);
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isSuccesful: true,
              uploadPostMessage: response.message
              // data: response,
              ));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false, error: de.errorMessage(), isSuccesful: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false, error: e.toString(), isSuccesful: false));
        }
      },
    );

    on<UploadDraftBusinessBroadcast>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true, error: "", isDraftSuccesful: false));
        try {
          final response =
              await _homeUsecase.uploadBusinessBroadcast(event.model);

          emit(state.copyWith(
              isLoading: false,
              error: "",
              isDraftSuccesful: true,
              uploadPostDraftMessage: response.message
              // data: response,
              ));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false,
              error: de.errorMessage(),
              isDraftSuccesful: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false, error: e.toString(), isDraftSuccesful: false));
        }
      },
    );

    on<ViewBroadcastPost>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true, error: "", isSuccesfulDelete: false));
        try {
          final response = await _homeUsecase.viewBroadcastPost(event.id);
          populateBroadcastDetails(response.broadcastData!);
          emit(state.copyWith(
            error: "",
            isLoading: false,
            isSuccesfulDelete: false,
            broadcastDetails: response.broadcastData,
            //  loggedIn: loggedIn,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchUserDetails ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              broadcastDetails: null,

              error: e.errorMessage(),
              //loggedIn: loggedIn,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              broadcastDetails: null,

              error: e.toString(),
              //loggedIn: loggedIn,
            ));
          }
        }
      },
    );

    on<PopulateBroadcastDetails>((event, emit) {
      ViewBroadcastDetails broadcastDetails = event.broadcastDetails;
      descriptionController.text = broadcastDetails.description!;
      titleController.text = broadcastDetails.title!;
      couponCodeController.text = broadcastDetails.couponCode!;
      postDurationController.text = broadcastDetails.postDuration!;
      if (state.broadcastPlanDetails?.isNotEmpty ?? false) {
        setselectedPlan(state.broadcastPlanDetails!.firstWhere(
            (model) => model.id == broadcastDetails.postDurationId));
      }
      promotingController.text = broadcastDetails.whatPromoting!;

      String dateTimeString = broadcastDetails.validDate!;
      // Parse the DateTime string
      DateTime dateTime = DateTime.parse(dateTimeString);
      String formattedDate = DateFormat('MM-dd-yyyy').format(dateTime);
      validFromController.text = formattedDate;

      // List<ImageModel> imageUrls = [];
      // List<String> imageIds = [];
      // for (var media in broadcastDetails.images!) {
      //   imageUrls.add(media);
      //   imageIds.add(media.id!.toString());
      // }

      List<ImageModel>? imageModelsList = [];

      if (broadcastDetails.images != null) {
        for (var media in broadcastDetails.images!) {
          imageModelsList.add(ImageModel(media.id!, media.path!));
        }
      }

      emit(state.copyWith(
          postDurationId: broadcastDetails.postDurationId,
          postedMedia: imageModelsList));
    });

    on<DeleteFile>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true, error: "", isSuccesfulDelete: false));

        try {
          Map<String, dynamic> params = {
            "postType": "Broadcast",
            "fileId": int.parse(event.fileId.trim()),
          };
          final response = await _homeUsecase.deleteFile(params);
          viewBroadcastPost(event.postId);
          emit(state.copyWith(
              error: "",
              isLoading: false,
              deleteFileMessage: response.message,
              isSuccesfulDelete: true
              //  loggedIn: loggedIn,
              ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- DeleteFile ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
                isLoading: false,
                deleteFileMessage: null,
                error: e.errorMessage(),
                isSuccesfulDelete: false
                //loggedIn: loggedIn,
                ));
          } else {
            emit(state.copyWith(
                isLoading: false,
                deleteFileMessage: null,
                error: e.toString(),
                isSuccesfulDelete: false
                //loggedIn: loggedIn,
                ));
          }
        }
      },
    );
  }

  checkout(amount) {
    add(BusinessBroadcastEvent.checkOut(amount));
  }

  void uploadBusinessBroadcast(request) {
    request = request;
    add(BusinessBroadcastEvent.uploadBusinessBroadcast(request));
  }

  void uploadSavedBroadcast(request) {
    request = request;
    add(BusinessBroadcastEvent.uploadSavedBroadcast(request));
  }

  void editDraftBusinessBroadcast(request) {
    request = request;
    add(BusinessBroadcastEvent.editDraftBusinessBroadcast(request));
  }

  disposeControllers() {
    amountController.clear();
    nonceController.clear();
    webFormKey.currentState?.reset();
  }

  uploadImage(imagePath) {
    add(BusinessBroadcastEvent.uploadImages(imagePath));
  }

  updatePromotion(String value) {
    add(BusinessBroadcastEvent.updatePromotion(value));
  }

  fetchBroadcastPlans() async {
    add(BusinessBroadcastEvent.fetchBroadcastPlans());
  }

  void viewBroadcastPost(String id) async {
    add(BusinessBroadcastEvent.viewBroadcastPost(id));
  }

  populateBroadcastDetails(ViewBroadcastDetails broadcastDetails) {
    add(BusinessBroadcastEvent.populateBroadcastDetails(broadcastDetails));
  }

  deleteFile(String fileId, String postId) async {
    add(BusinessBroadcastEvent.deleteFile(fileId, postId));
  }

  setselectedPlan(BroadcastPlan plan) async {
    add(BusinessBroadcastEvent.setselectedPlan(plan));
  }
}

String formatDate(DateTime date) {
  return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
}

String _twoDigits(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}
