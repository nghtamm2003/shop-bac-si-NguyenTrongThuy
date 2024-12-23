import 'package:fpdart/fpdart.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/auth/data/models/auth_request.dart';

abstract class AuthenticationRepository {
  Future<Either> signUp(AuthenticationRequest authRequest);

  Future<Either> signIn(AuthenticationRequest authRequest);

  Future<bool> getAuthState();

  Future<String> getDisplayName();
}
