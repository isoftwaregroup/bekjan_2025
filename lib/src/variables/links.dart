class Links {
  static const String baseUrl = 'https://bekjaantaxi.uz';
  static const String splash = '/api/client/open-data/splash';
  static const String sendPhone = '/api/client/auth/login-via-phone';
  static const String editPhone = '/api/client/auth/login-via-phone';
  static const String sendVerify = '/api/client/auth/confirm-phone';
  static const String editVerify = '';
  static const String resendSMSCode = '/api/client/auth/resend-sms';
  static const String register = '/api/client/auth/fill-user-account';
  static const String deleteUser = '/api/client/auth/delete-account';
  static const String getCars = '/api/client/data/cars';
  static const String totalBonus = '/api/client/data/bonus';
  static const String editAccount = '/api/client/user/account';
  static const String avatar = '/api/client/user/avatar';
  static const String tarifs = '/api/client/data/modes';
  static const String shareMessage = '/api/client/data/share';
  static const String about = '/api/client/data/version';
  static const String faq = '/api/client/data/faq';
  static const String services = '/api/client/data/services';
  static const String getMe = '/api/client/auth/me';
  static const String newOrder = '/api/client/order/new';
  static const String cancelOrder = '/api/client/order/cancel';
  static const String payFromBonus = '/api/client/bonus/pay';
  static const String getFullBonus = '/api/client/bonus/get';
  static const String status = '/api/client/order/status';
  static const String rating = '/api/client/order/rate';
  static const String skipRating = '/api/client/order/skip-rate';
  static const String history = '/api/client/order/history';
  static const String bonusHistory = '/api/client/bonus/history';
  static const String historyOrder = '/api/client/order/history-one';
  static const String drawLink = '/api/common/direction-with-cost';
  static const String contact = '/api/common/contact';
  static const String places = '/api/common/place-name';
  static const String searchAdress =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyCR9BC6v0iDlFDZ4in6Uw7Y9sjJui3oThg&input=';
  static const String getLocationFromAdress =
      'https://maps.googleapis.com/maps/api/geocode/json?address=';
  static const String addressFromLocation =
      'https://nominatim.openstreetmap.org/reverse?format=json';
  static const String socketLink = 'wss://bekjaantaxi.uz/connect/?token=';
}
