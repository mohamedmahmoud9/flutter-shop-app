import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  Products(this.authToken, this._items,this.userId);
  List<Product> _items = [
   
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> fetchAndSetProduct([bool filterByUser= false]) async {
    final filterString = filterByUser?'orderBy="creatorId"&equalTo="$userId"':'';
    var url =
        'https://shop-app-433d6.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
     url =
        'https://shop-app-433d6.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteRespone = await http.get((url));
      final favoriteData = json.decode(favoriteRespone.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            title: prodData['title'],
            price: prodData['price'],
            isFavorite: favoriteData == null ?false:favoriteData[prodId]??false));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://shop-app-433d6.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
         
          }));
      final newProduct = Product(
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        title: product.title,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product updatedProdct) async {
    final url = 'https://shop-app-433d6.firebaseio.com/products/$id.json?auth=$authToken';
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    await http.patch(url,
        body: json.encode({
          'title': updatedProdct.title,
          'description': updatedProdct.description,
          'imageUrl': updatedProdct.imageUrl,
          'price': updatedProdct.price,
        }));
    _items[prodIndex] = updatedProdct;
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    final url = 'https://shop-app-433d6.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      print('Error');
      _items.insert(existingProductIndex, existingProduct);
      print(response.body);

      notifyListeners();
      throw HttpException('Could not delete product.');
    } else {
      print('No error');
      print(response.body);
      existingProduct = null;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
  
}
