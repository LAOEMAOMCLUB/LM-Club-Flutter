import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:lm_club/app/models/auth/request_model/broadcast_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:lm_club/app/models/auth/request_model/profile_req_model.dart';
import 'package:lm_club/app/models/auth/request_model/sharePost_broadCast_model.dart';
import 'package:lm_club/app/presentation/brodcast/bloc/broadcast_state.dart';
import 'package:lm_club/app/presentation/brodcast/bloc/broadcast_event.dart';
import 'package:lm_club/utils/string_extention.dart';
import '../../../models/image_model.dart';
import 'package:http/http.dart' as http;

@injectable
class BroadcastBloc extends Bloc<BroadcastEvent, BroadcastState> {
  final webFormKey = GlobalKey<FormState>();
  final HomeUsecase _homeUsecase;
  List<ImageModel> imageFile = [];
  List<File> imagePath = [];
  String imageUploaded = '';
  List<int> imageBytes = [];
  String userID = '';
  String selectedDuration = '';
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  late BroadcastModel request;
  late SharePostModel request1;
  late ProfileRequestModel requestModel;

  BroadcastBloc(this._homeUsecase) : super(BroadcastState.init(null)) {
    on<UploadBroadcast>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: "", isSuccesful: false));
        try {
          final response = await _homeUsecase.uploadBroadcast(event.model);
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isSuccesful: true,
              uploadPost: response.message
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

    on<UploadSavedBroadcast>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true, error: "", isDraftSuccesful: false));
        try {
          final response = await _homeUsecase.uploadBroadcast(event.model);
          // fetchMyBroadcasts();
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isDraftSuccesful: true,
              uploadPostDraft: response.message
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
    on<UploadImage>(
      (event, emit) {
        // imageFile = event.images;
        imagePath = event.path;

        emit(state.copyWith(isLoading: true));
        emit(state.copyWith(
          isLoading: false,
          // pImages: event.images,
          imagePath: event.path,
          error: "",
        ));
      },
    );
    on<SaveImage>(
      (event, emit) async {
        // imageFile = event.images;
        imageUploaded = event.path;

        // List<int> imageBytes = await File(imageUploaded).readAsBytes();

        // // Pass the binary data to the uploadImage method

        emit(state.copyWith(isLoading: true));
        emit(state.copyWith(
          isLoading: false,
          // pImages: event.images,
          imagePathuploaded: event.path,
          error: "",
        ));
      },
    );
    on<FetchBroadcasts>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          Map<String, dynamic> params = {
            'search': event.selectedUserId,
            'dates': event.selectedDuration
          };
          final response = await _homeUsecase.getBroadcasts(params);
          emit(state.copyWith(
            error: "",
            isLoading: false,
            broadcastDetails: response.data,
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

    on<FetchMyBroadcasts>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          Map<String, dynamic> params = {
            'dates': event.selectedDurationMyPosts
          };

          final response = await _homeUsecase.getMyBroadcasts(params);
          emit(state.copyWith(
            error: "",
            isLoading: false,
            broadcastDetails: response.data,
            //  loggedIn: loggedIn,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchBroadcastDetails ${e.toString()}');
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

    on<MySharesBroadCast>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          final response = await _homeUsecase.myShares();
          emit(state.copyWith(
            error: "",
            isLoading: false,
            myShareBroadCast: response.data,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchMyShareBroadcast ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              myShareBroadCast: null,
              error: e.errorMessage(),
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              myShareBroadCast: null,
              error: e.toString(),
            ));
          }
        }
      },
    );

    on<ShareType>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          final response = await _homeUsecase.shareTypes();
          emit(state.copyWith(
            error: "",
            isLoading: false,
            shareType: response.data,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchShareTypeBroadcast ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              shareType: null,
              error: e.errorMessage(),
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              shareType: null,
              error: e.toString(),
            ));
          }
        }
      },
    );
    on<SharePost>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true, error: "", isPostSuccessful: false));
        try {
          final response = await _homeUsecase.sharePost(event.model);
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isPostSuccessful: true,
              sharePost: response.message
              // data: response,
              ));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false,
              error: de.errorMessage(),
              isPostSuccessful: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false, error: e.toString(), isPostSuccessful: false));
        }
      },
    );

    on<GenerateAcceratedUrl>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true, error: "", isDraftSuccesful: false));
        try {
          final response = await _homeUsecase.generateAcceratedUrl(event.model);
          updateBrodcastImages(response.data.toString());
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isDraftSuccesful: true,
              uploadPost: response.message
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

    on<SetUserId>(
      (event, emit) {
        userID = event.id;

        emit(state.copyWith(isLoading: true));
        emit(state.copyWith(
          isLoading: false,
          userId: event.id,
          error: "",
        ));
      },
    );

    on<SelectDurationDates>(
      (event, emit) {
        final String selectedDurationTime = event.toString();
        selectedDuration = selectedDurationTime;

        emit(state.copyWith(isLoading: true));
        emit(state.copyWith(
          isLoading: false,
          selectedDuration: selectedDuration,
          error: "",
        ));
      },
    );
  }

  void sharePost(int postId, String share) {
    final model = SharePostModel(postId: postId, modeOfShare: share);
    request1 = model;
    add(BroadcastEvent.sharePost(model));
  }

  void uploadBroadcast() {
    if (webFormKey.currentState!.validate()) {
      final model = BroadcastModel(
        isDrafted: false,
        image: imagePath,
        title: titleController.text,
        description: descriptionController.text,
      );
      request = model;

      add(BroadcastEvent.uploadBroadcast(model));
    }
  }

  // void saveBroadcastDraft(List<File> images) {
  //   final model = BroadcastModel(
  //     isDrafted: true,
  //     // isApproved: true,
  //     // userId: userIntId,

  //     image: images,
  //     title: titleController.text,
  //     description: descriptionController.text,
  //   );
  //   request = model;
  //   add(BroadcastEvent.uploadBroadcast(model));
  // }

  BroadcastModel uploadBroadcastRequest() {
    return request;
  }

  uploadImage(imagePath) {
    add(BroadcastEvent.updatePropertyImages(imagePath));
  }

  saveImage(String imagep) {
    add(BroadcastEvent.updateSaveImage(imagep));
  }

  fetchBroadcasts(String selectedUserId, String selectedDuration) async {
    // final response = await _homeUsecase.getBroadcasts();
    add(BroadcastEvent.getBroadcasts(selectedUserId, selectedDuration));
  }

  fetchMyBroadcasts(String selectedDurationMyPosts) async {
    // final response = await _homeUsecase.getBroadcasts();
    add(BroadcastEvent.getMyBroadcasts(selectedDurationMyPosts));
  }

  void setUserId(String userId) {
    add(BroadcastEvent.setUserId(userId));
  }

  void selectDurationDates(String text) {
    add(BroadcastEvent.selectDurationDates(text));
  }

  void myShares() {
    add(BroadcastEvent.myShares());
  }

  void shareType() {
    add(BroadcastEvent.shareType());
  }

  void uploadSavedBroadcast(List<File> imageP) {
    final model = BroadcastModel(
      isDrafted: true,
      // isApproved: true,
      // userId: userIntId,
      image: imageP,
      title: titleController.text,
      description: descriptionController.text,
    );
    request = model;
    add(BroadcastEvent.uploadSavedBroadcast(model));
  }

  // void generateAcceratedUrl(String imageP) {
  //   //  String imageUploaded = image ;
  //   //if (webFormKey.currentState!.validate()) {
  //   final model = ProfileRequestModel(
  //     image: imageP,
  //   );
  //   requestModel = model;
  //   print('requestModl____$requestModel');
  //   add(BroadcastEvent.generateAcceratedUrl(model));
  //   //}
  // }

  Future<http.Response> updateBrodcastImages(String urlToUpdate) async {
    try {
      http.Response response = await http.put(
        Uri.parse(urlToUpdate),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: imageUploaded,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to update album: $e');
    }
  }

  disposeControllers() {
    titleController.clear();
    descriptionController.clear();
    searchController.clear();
    webFormKey.currentState?.reset();
  }
}
