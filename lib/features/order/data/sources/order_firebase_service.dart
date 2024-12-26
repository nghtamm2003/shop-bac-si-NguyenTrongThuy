import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/order/data/models/add_to_cart_req.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/order/data/models/order_registration_req.dart';

abstract class OrderFirebaseService {
  Future<Either<String, String>> addtoCart(AddToCartReq addToCartReq);
  Future<Either> removeCartProduct(String id);
  Future<Either> getCartProducts();
  Future<Either> orderRegistration(OrderRegistrationReq order);
}

class OrderFirebaseServiceImpl extends OrderFirebaseService {
  @override
  Future<Either<String, String>> addtoCart(AddToCartReq addToCartReq) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('Cart')
          .add(addToCartReq.toMap());
      return const Right('Thêm vào giỏ thành công');
    } catch (e) {
      return const Left('Lỗi khi thêm vào giỏ');
    }
  }

  @override
  Future<Either> getCartProducts() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var returnedData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('Cart')
          .get();
      List<Map> products = [];
      for (var item in returnedData.docs) {
        var data = item.data();
        data.addAll({'id': item.id});
        products.add(data);
      }
      return Right(products);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> removeCartProduct(String id) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('Cart')
          .doc(id)
          .delete();
      return const Right('Product removed successfully');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> orderRegistration(OrderRegistrationReq order) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('Orders')
          .add(order.toMap());
      return const Right('Order registered successfully');
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
