import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../data/repositories/auth_repository.dart';

class MainNavController extends GetxController {
  final AuthRepository authRepository = Get.find<AuthRepository>();
  final RxInt currentIndex = 0.obs;

  String get userRole => authRepository.userRole;
  bool get isWorker => userRole == AppConstants.roleWorker;
  bool get isAdmin => userRole == AppConstants.roleAdmin;
  bool get isCustomer => userRole == AppConstants.roleCustomer || userRole == AppConstants.roleGuest;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
