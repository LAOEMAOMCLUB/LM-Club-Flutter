// beehiveBlocPage here every logic and functionality defined to make API calls.

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/domain/local_storage/shared_pref_repository.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:lm_club/app/models/auth/request_model/beehive_model.dart';
import 'package:lm_club/app/models/auth/request_model/saveOrLike_model.dart';
import 'package:lm_club/app/models/auth/response_model/categories_response.dart';
import 'package:lm_club/app/presentation/beehive/bloc/beehive_event.dart';
import 'package:lm_club/app/presentation/beehive/bloc/beehive_state.dart';
import 'package:lm_club/utils/string_extention.dart';

final SharedPrefRepository _sharedPrefRepository =
    getIt.get<SharedPrefRepository>();

@injectable
class BeehiveBloc extends Bloc<BeehiveEvent, BeehiveState> {
  final HomeUsecase _homeUsecase;
  final webFormKey = GlobalKey<FormState>();
  String categoryId = '';
  String catName = '';
  String userID = '';
  String selectedDuration = '';
  List<String> selectedCatIds = [];
  List<File> imagePath = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController validUptoController = TextEditingController();
  TextEditingController validFromController = TextEditingController();
  TextEditingController isDraftController = TextEditingController();
  TextEditingController couponCodeController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController operationHoursFromController = TextEditingController();
  TextEditingController operationHoursToController = TextEditingController();
  late BeehiveModel request;
  late SaveOrLikeModel request1;
  String selectedBeehiveUserId = '';
  BeehiveBloc(this._homeUsecase) : super(BeehiveState.init(null, null)) {
    on<GetBeehivePosts>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          Map<String, dynamic> params = {
            'categoryId': event.selectedCategoryIdsAsString,
            'search': event.selectedUserId,
            'dates': event.selectedDuration
          };
          final response = await _homeUsecase.getBeehivePosts(params);

          emit(state.copyWith(
            error: "",
            isLoading: false,
            isSaveOrLike: false,
            beehiveDetails: response.data,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchBeehivePosts ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              beehiveDetails: null,
              error: e.errorMessage(),
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              beehiveDetails: null,
              error: e.toString(),
            ));
          }
        }
      },
    );
    on<GetSavedBeehivePosts>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          Map<String, dynamic> params = {
            'categoryId': event.selectedCategoryIdsAsString,
            'search': event.selectedUserId,
            'dates': event.selectedDuration
          };
          final response = await _homeUsecase.mySavedPosts(params);

          emit(state.copyWith(
            error: "",
            isLoading: false,
            isSaveOrLike: false,
            savedbeehivePosts: response.data,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchSavedBeehivePosts ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              savedbeehivePosts: null,
              error: e.errorMessage(),
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              savedbeehivePosts: null,
              error: e.toString(),
            ));
          }
        }
      },
    );
    on<GetBeehiveMyPosts>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          Map<String, dynamic> params = {
            'categoryId': event.selectedPostCategory,
            'dates': event.selectedPostDuration
          };
          final response = await _homeUsecase.myPostsBeehive(params);

          emit(state.copyWith(
            error: "",
            isLoading: false,
            mypostbeehiveDetails: response.data,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchMyBeehivePosts ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              mypostbeehiveDetails: null,
              error: e.errorMessage(),
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              mypostbeehiveDetails: null,
              error: e.toString(),
            ));
          }
        }
      },
    );

    on<GetBeehiveCategories>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          final response = await _homeUsecase.getBeehiveCategories();

          emit(state.copyWith(
            error: "",
            isLoading: false,
            beehiveCategories: response.data,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchBeehivePosts ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              beehiveCategories: null,
              error: e.errorMessage(),
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              beehiveCategories: null,
              error: e.toString(),
            ));
          }
        }
      },
    );

    on<UpdateBeehiveCategory>(
      (event, emit) {
        final BeehiveCategory catId = event.category;
        categoryId = catId.id.toString();
        catName = catId.category;
        emit(state.copyWith(isLoading: true));
        emit(state.copyWith(
          isLoading: false,
          categoryId: categoryId,
          categoryName: catName,
          error: "",
        ));
      },
    );

    on<UploadBeehivePost>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: "", isSuccesful: false));
        try {
          final response = await _homeUsecase.uploadBeehive(event.model);
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isSuccesful: true,
              uploadBeehivePost: response.message
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
    on<SaveOrLikePost>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true,
            error: "",
            isSuccesful: false,
            isSaveOrLike: false));
        try {
          final response = await _homeUsecase.saveOrLikePost(event.model);

          emit(state.copyWith(
              isLoading: false,
              error: "",
              isSuccesful: true,
              isSaveOrLike: true,
              saveOrLikePostResponse: response));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false,
              error: de.errorMessage(),
              isSuccesful: false,
              isSaveOrLike: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false,
              error: e.toString(),
              isSuccesful: false,
              isSaveOrLike: false));
        }
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

    on<GetCategoryIdSelection>(
      (event, emit) {
        final String catergoryIdSelected = event.toString();
        selectedCatIds.add(catergoryIdSelected);

        emit(state.copyWith(isLoading: true));
        emit(state.copyWith(
          isLoading: false,
          selectedCategoryIds: selectedCatIds,
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
  void uploadBeehive() {
    if (webFormKey.currentState!.validate()) {
      final model = BeehiveModel(
          isDrafted: false,
          image: imagePath,
          title: titleController.text,
          companyName: companyController.text,
          couponCode: couponCodeController.text,
          category: int.parse(categoryId.trim()),
          validUpto: validUptoController.text,
          description: descriptionController.text,
          validFrom: validFromController.text,
          operationHoursFrom: operationHoursFromController.text,
          operationHoursTo: operationHoursToController.text);
      request = model;

      add(BeehiveEvent.uploadBeehivePost(model));
    }
  }

  void savePost(String postId, saved) {
    final model1 = SaveOrLikeModel(
        action: saved, id: int.parse(postId.trim()), type: 'save');
    request1 = model1;
    add(BeehiveEvent.saveOrLikePosts(model1));
  }

  void likePosts(String postId, bool liked, String selectedLikeUserId) {
    selectedBeehiveUserId = selectedLikeUserId;
    _sharedPrefRepository.storeData(
        'selectedBeehiveUserId', selectedBeehiveUserId);
    final model1 = SaveOrLikeModel(
        action: liked, id: int.parse(postId.trim()), type: 'like');
    request1 = model1;
    add(BeehiveEvent.saveOrLikePosts(model1));
  }

  uploadImage(imagePath) {
    add(BeehiveEvent.uploadImages(imagePath));
  }

  void getBeehivePosts(List<String> selectedCategoryIdsAsString,
      String selectedUserId, String selectedDuration) async {
    add(BeehiveEvent.getBeehivePosts(
        selectedCategoryIdsAsString, selectedUserId, selectedDuration));
  }

  void mySavedPosts(List<String> selectedCategoryIdsAsString,
      String selectedUserId, String selectedDuration) async {
    add(BeehiveEvent.mySavedPosts(
        selectedCategoryIdsAsString, selectedUserId, selectedDuration));
  }

  void myPostsBeehive(
      List<String> selectedPostCategory, String selectedPostDuration) async {
    add(BeehiveEvent.myPostsBeehive(
        selectedPostCategory, selectedPostDuration));
  }

  void getBeehiveCategories() async {
    add(BeehiveEvent.getBeehiveCategories());
  }

  void updateBeehiveCategory(BeehiveCategory category) {
    add(BeehiveEvent.updateBeehiveCategory(category));
  }

  void getCategoryIdSelection(String catId) {
    add(BeehiveEvent.getCategoryIdSelection(catId));
  }

  void setUserId(String userId) {
    add(BeehiveEvent.setUserId(userId));
  }

  void selectDurationDates(String text) {
    add(BeehiveEvent.selectDurationDates(text));
  }
}
