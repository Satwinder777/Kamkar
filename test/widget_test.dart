import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:kamkar/core/bindings/initial_binding.dart';
import 'package:kamkar/core/storage/secure_storage_service.dart';
import 'package:kamkar/modules/auth/auth_controller.dart';
import 'package:kamkar/modules/auth/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    Get.reset();
    final storageService = Get.put<SecureStorageService>(SecureStorageService(), permanent: true);
    await storageService.init();
    InitialBinding().dependencies();
    Get.put<AuthController>(AuthController());
  });

  testWidgets('LoginView renders with email, password fields and sign in button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: LoginView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Browse as Guest →'), findsOneWidget);
  });
}
