import 'package:fpdart/fpdart.dart';
import 'package:shop_bacsi_nguyentrongthuy/core/usecase/use_case.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/auth/domain/repository/auth_repository.dart';
import 'package:shop_bacsi_nguyentrongthuy/service_locator.dart';

class GoogleSignInUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return serviceLocator<AuthenticationRepository>().signInWithGoogle();
  }
}