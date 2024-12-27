import 'package:lm_club/app/models/auth/request_model/coupons_model.dart';
import 'package:lm_club/app/models/image_model.dart';

abstract class CouponsEvent {
  CouponsEvent._();
  factory CouponsEvent.addCoupon(CouponsModel model) => AddCoupon(model);
  factory CouponsEvent.updateCouponImages(
          List<ImageModel> images, String path) =>
      UploadImage(images, path);
  factory CouponsEvent.updateCategory(String id) => UpdateCategory(id);

  factory CouponsEvent.getCategories() => FetchCategories();
  factory CouponsEvent.getCoupons() => FetchCoupons();
}

class UploadImage extends CouponsEvent {
  final List<ImageModel> images;
  final String path;
  UploadImage(
    this.images,
    this.path,
  ) : super._();
}

class UpdateCategory extends CouponsEvent {
  final String id;
  UpdateCategory(this.id) : super._();
}

class FetchCategories extends CouponsEvent {
  FetchCategories() : super._();
}

class AddCoupon extends CouponsEvent {
  final CouponsModel model;
  AddCoupon(this.model) : super._();
}

class FetchCoupons extends CouponsEvent {
  FetchCoupons() : super._();
}
