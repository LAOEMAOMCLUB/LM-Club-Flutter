// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:lm_club/app/models/auth/request_model/coupons_model.dart';
import 'package:lm_club/app/models/image_model.dart';
import 'package:lm_club/app/presentation/coupons/bloc/coupon_state.dart';
import 'package:lm_club/app/presentation/coupons/bloc/coupon_event.dart';
import 'package:lm_club/utils/string_extention.dart';

@injectable
class CouponsBloc extends Bloc<CouponsEvent, CouponsState> {
  final webFormKey = GlobalKey<FormState>();
  final HomeUsecase _homeUsecase;
  String categoryId = '';
  List<ImageModel> imageFile = [];
  String imagePath = "";
  TextEditingController offerController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cNameController = TextEditingController();
  TextEditingController validUptoController = TextEditingController();
  late CouponsModel request;

  CouponsBloc(this._homeUsecase) : super(CouponsState.init(null)) {
    on<AddCoupon>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: "", isSuccesful: false));
        try {
          final response = await _homeUsecase.addCoupon(event.model);
          emit(state.copyWith(
            isLoading: false,
            error: "",
            isSuccesful: true,
            data: response,
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

    on<UploadImage>(
      (event, emit) {
        imageFile = event.images;
        imagePath = event.path;
        emit(state.copyWith(isLoading: true));
        emit(state.copyWith(
          isLoading: false,
          pImages: event.images,
          imagePath: event.path,
          error: "",
        ));
      },
    );
    // on<FetchCategories>(
    //   (event, emit) async {
    //     emit(state.copyWith(isLoading: true, error: ""));
    //     try {
    //       final response = await _homeUsecase.getCategories();
    //       emit(state.copyWith(
    //         error: "",
    //         isLoading: false,
    //         categories: response.data,
    //         //  loggedIn: loggedIn,
    //       ));
    //     } catch (e) {
    //       if (kDebugMode) {
    //         print('Debug-- FetchUserDetails ${e.toString()}');
    //       }
    //       if (e is DioException) {
    //         emit(state.copyWith(
    //           isLoading: false,
    //           categories: null,
    //           error: e.errorMessage(),
    //           //loggedIn: loggedIn,
    //         ));
    //       } else {
    //         emit(state.copyWith(
    //           isLoading: false,
    //           categories: null,
    //           error: e.toString(),
    //           //loggedIn: loggedIn,
    //         ));
    //       }
    //     }
    //   },
    // );


    //  on<FetchCoupons>(
    //   (event, emit) async {
    //     emit(state.copyWith(isLoading: true, error: ""));
    //     try {
    //       final response = await _homeUsecase.getCoupons();
    //       emit(state.copyWith(
    //         error: "",
    //         isLoading: false,
    //         coupons: response.data,
    //         //  loggedIn: loggedIn,
    //       ));
    //     } catch (e) {
    //       if (kDebugMode) {
    //         print('Debug-- FetchUserDetails ${e.toString()}');
    //       }
    //       if (e is DioException) {
    //         emit(state.copyWith(
    //           isLoading: false,
    //           categories: null,
    //           error: e.errorMessage(),
    //           //loggedIn: loggedIn,
    //         ));
    //       } else {
    //         emit(state.copyWith(
    //           isLoading: false,
    //           categories: null,
    //           error: e.toString(),
    //           //loggedIn: loggedIn,
    //         ));
    //       }
    //     }
    //   },
    // );


    on<UpdateCategory>(
      (event, emit) {
        final String catId = event.id;
        categoryId = catId;

        emit(state.copyWith(isLoading: true));
        emit(state.copyWith(
          isLoading: false,
          category: categoryId,
          error: "",
        ));
      },
    );
  }

  void addCoupon(String path) {
    final model = CouponsModel(
      image: path,
      category: categoryId,
      company_name: cNameController.text,
      description: descriptionController.text,
      company_offer: offerController.text,
      valid_upto: validUptoController.text,
      referal_code: 'yahaj1',
    );
    request = model;
    add(CouponsEvent.addCoupon(model));
  }

  CouponsModel addCouponRequest() {
    return request;
  }

  uploadImage(images, imagePath) {
    add(CouponsEvent.updateCouponImages(images, imagePath));
  }

  fetchCategories() async {
   // final response = await _homeUsecase.getCategories();
    add(CouponsEvent.getCategories());
  }

  updateCategory(String category) {
    add(CouponsEvent.updateCategory(category));
  }

   fetchCoupons() async {
    // final response = await _homeUsecase.getCoupons();
    add(CouponsEvent.getCoupons());
  }

}
