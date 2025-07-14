import 'package:get/get.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/form/form_screen.dart';
import '../../features/results/results_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/scheme_detail/scheme_detail_screen.dart';
import '../../features/history/history_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: _Paths.FORM,
      page: () => FormScreen(),
    ),
    GetPage(
      name: _Paths.RESULTS,
      page: () => ResultsScreen(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: _Paths.SCHEME_DETAIL,
      page: () => SchemeDetailScreen(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => HistoryScreen(),
    ),
  ];
}
