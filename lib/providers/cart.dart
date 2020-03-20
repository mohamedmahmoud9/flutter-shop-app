import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalPrice {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity * cartItem.price;
    });
    return total;
  }
  void addItem (String productId, double price, String title,[int quantity=1]){
   if(quantity>0){
if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity + quantity,
        ),
      );
    }
    else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: quantity));
    }
    notifyListeners();
   }
   else{
     return null;
   }
    
  }

  // void addItem(String productId, double price, String title) {
  //   if (_items.containsKey(productId)) {
  //     _items.update(
  //       productId,
  //       (existingItem) => CartItem(
  //         id: existingItem.id,
  //         title: existingItem.title,
  //         price: existingItem.price,
  //         quantity: existingItem.quantity + 1,
  //       ),
  //     );
  //   } else {
  //     _items.putIfAbsent(
  //         productId,
  //         () => CartItem(
  //             id: DateTime.now().toString(),
  //             title: title,
  //             price: price,
  //             quantity: 1));
  //   }
  //   notifyListeners();
  // }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (exisitingCartItem) => CartItem(
          id: exisitingCartItem.id,
          price: exisitingCartItem.price,
          title: exisitingCartItem.title,
          quantity: exisitingCartItem.quantity - 1,
        ),
      );
    }
     else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
