import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/auth/data/models/auth_request.dart';

abstract class AuthenticationFirebaseService {
  Future<Either> signUp(AuthenticationRequest authRequest);

  Future<Either> signIn(AuthenticationRequest authRequest);

  Future<bool> getAuthState();

  Future<String> getDisplayName();
}

class AuthenticationFirebaseServiceImpl extends AuthenticationFirebaseService {
  @override
  Future<Either> signUp(AuthenticationRequest authRequest) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: authRequest.email,
        password: authRequest.password,
      );
      return const Right('Đăng ký tài khoản thành công!');
    } on FirebaseAuthException catch (err) {
      String errorMessage = '';
      if (err.code == 'email-already-in-use') {
        errorMessage = 'Địa chỉ email đã được sử dụng cho một tài khoản khác.';
      } else if (err.code == 'invalid-email') {
        errorMessage = 'Địa chỉ email không hợp lệ.';
      } else if (err.code == 'weak-password') {
        errorMessage = 'Mật khẩu quá yếu.';
      } else {
        errorMessage = 'Đã xảy ra lỗi không xác định.';
      }
      return Left(errorMessage);
    }
  }

  @override
  Future<Either> signIn(AuthenticationRequest authRequest) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: authRequest.email,
        password: authRequest.password,
      );
      return const Right(null);
    } on FirebaseAuthException catch (err) {
      String errorMessage = '';
      if (err.code == 'invalid-email') {
        errorMessage = 'Địa chỉ email không hợp lệ.';
      } else if (err.code == 'user-disabled') {
        errorMessage = 'Tài khoản đã bị vô hiệu hóa.';
      } else if (err.code == 'invalid-credenital') {
        errorMessage = 'Địa chỉ email hoặc mật khẩu không chính xác.';
      } else {
        errorMessage = 'Đã xảy ra lỗi không xác định.';
      }
      return Left(errorMessage);
    }
  }

  @override
  Future<bool> getAuthState() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<String> getDisplayName() async {
    return FirebaseAuth.instance.currentUser?.displayName ?? '';
  }
}
