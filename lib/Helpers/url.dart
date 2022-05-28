class UrlHelper {
  static Uri getProductUrl({String? id}) {
    return Uri.parse(id == null ? 'https://jandir-my-shop-default-rtdb.firebaseio'
        '.com/products.json' : 'https://jandir-my-shop-default-rtdb'
        '.firebaseio.com/products/$id.json');
  }

  static Uri getOrderUrl({String? id}) {
    return Uri.parse(id == null ? 'https://jandir-my-shop-default-rtdb.firebaseio'
        '.com/orders.json' : 'https://jandir-my-shop-default-rtdb'
        '.firebaseio.com/orders/$id.json');
  }
}