import 'package:e_commerce_app/models/item_model.dart';
import 'package:flutter/material.dart';

class CartModel with ChangeNotifier {
  List selectedProducts = [];
  int price = 0;
  addProduct(ItemModel product) {
    selectedProducts.add(product);
    price += product.price.round();

    notifyListeners();
  }

  removeProduct(ItemModel product) {
    selectedProducts.remove(product);
    price -= product.price.round();
    notifyListeners();
  }

  get productsCount {
    return selectedProducts.length;
  }
}
