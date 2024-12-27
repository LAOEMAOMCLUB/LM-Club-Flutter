import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/coupons_response.dart';
import 'package:lm_club/app/models/auth/response_model/enroll_response.dart';
import 'package:lm_club/app/models/image_model.dart';

// ignore: must_be_immutable
class CouponsState extends Equatable {
  final bool? isSuccesful;
  final bool isLoading;
  String? imagePath;
  final EnrollResModel? data;
  final String? error;
  //final List<Categories> categories;
  List<ImageModel>? pImages;
  final List<Coupons> coupons;
  final String? category;
  CouponsState(
      {this.isSuccesful,
      required this.isLoading,
      this.error,
      this.data,
      this.pImages,
    //  required this.categories,
      this.category,
      this.imagePath,
      required this.coupons});

  CouponsState.init(this.data)
      : error = "",
        isLoading = false,
        isSuccesful = false,
        pImages = [],
        category = '',
        imagePath = '',
        coupons = []
      //  categories = []
      ;

  @override
  List<Object?> get props => [
        isSuccesful,
        isLoading,
        error,
      //  categories,
        category,
        pImages,
        imagePath,
        data
      ];

  CouponsState copyWith({
    String? error,
    bool? isLoading,
    bool? isSuccesful,
   // List<Categories>? categories,
    List<Coupons>? coupons,
    String? category,
    List<ImageModel>? pImages,
    String? imagePath,
    EnrollResModel? data,
  }) {
    return CouponsState(
        isSuccesful: isSuccesful ?? this.isSuccesful,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
     //   categories: categories ?? this.categories,
        category: category ?? this.category,
        imagePath: imagePath ?? this.imagePath,
        pImages: pImages ?? this.pImages,
        coupons: coupons ?? this.coupons,
        data: data ?? this.data);
  }
}
