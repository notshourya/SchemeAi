part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const HOME = _Paths.HOME;
  static const FORM = _Paths.FORM;
  static const RESULTS = _Paths.RESULTS;
  static const PROFILE = _Paths.PROFILE;
  static const SCHEME_DETAIL = _Paths.SCHEME_DETAIL;
  static const HISTORY = _Paths.HISTORY;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const HOME = '/home';
  static const FORM = '/form';
  static const RESULTS = '/results';
  static const PROFILE = '/profile';
  static const SCHEME_DETAIL = '/scheme-detail';
  static const HISTORY = '/history';
}
