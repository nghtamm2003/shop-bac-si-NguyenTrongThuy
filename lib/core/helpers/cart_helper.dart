import 'package:shop_bacsi_nguyentrongthuy/features/order/domain/entities/product_ordered.dart';

class CartHelper {
  static num calculateCartSubtotal(List<ProductOrderedEntity> products) {
    num subtotalPrice = 0;
    for (var item in products) {
      subtotalPrice = subtotalPrice + item.totalPrice;
    }
    return subtotalPrice;
  }
}