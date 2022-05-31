import 'package:flutter_dotenv/flutter_dotenv.dart';

class UrlHelper {
  static Uri getProductUrl({
    String? id,
    String? token,
    String? userId,
    bool filterByUser = false,
  }) {
    final filter = filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    return Uri.parse(id == null
        ? 'https://jandir-my-shop-default-rtdb.firebaseio'
            '.com/products.json?auth=$token$filter'
        : 'https://jandir-my-shop-default-rtdb'
            '.firebaseio.com/products/$id.json?auth=$token');
  }

  static Uri getUserFavoritesProductUrl(
      {String? id, String? token, String? userId}) {
    return id != null
        ? Uri.parse('https://jandir-my-shop-default-rtdb.firebaseio'
            '.com/userFavorites/$userId/$id.json?auth=$token')
        : Uri.parse('https://jandir-my-shop-default-rtdb.firebaseio'
            '.com/userFavorites/$userId.json?auth=$token');
  }

  static Uri getOrderUrl({String? id, String? token, String? userId}) {
    return Uri.parse('https://jandir-my-shop-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
  }

  static Uri signupUrl() {
    return Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${dotenv.env['FIREBASE_WEB_APP_KEY']}');
  }

  static Uri signInUrl() {
    return Uri.parse('https://identitytoolkit.googleapis'
        '.com/v1/accounts:signInWithPassword?key=${dotenv.env['FIREBASE_WEB_APP_KEY']}');
  }
}
