import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/datas/cart_product.dart';
import 'package:virtual_store/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel extends Model {
  UserModel _user;
  List<CartProduct> _products = [];
  Firestore _firestore = Firestore.instance;
  bool isLoading = false;
  String couponCode;
  int discountPercentage;

  CartModel(this._user) {
    if (_user.isLoggedIn()) _loadCartItems();
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    _products.add(cartProduct);
    _firestore
        .collection('users')
        .document(_user.firebaseUser.uid)
        .collection('cart')
        .add(cartProduct.toMap())
        .then((cart) => cartProduct.cid = cart.documentID);
  }

  void remove(CartProduct cartProduct) {
    _firestore
        .collection('users')
        .document(_user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cid)
        .delete();
    _products.remove(cartProduct);
    notifyListeners();
  }

  List<CartProduct> get products => _products;

  void removeCartItem(CartProduct product) {
    _firestore
        .collection('users')
        .document(_user.firebaseUser.uid)
        .collection('cart')
        .document(product.cid)
        .delete();
    _products.remove(product);
    notifyListeners();
  }

  void decProduct(CartProduct product) {
    product.quantity--;
    _updateProduct(product);
  }

  void incProduct(CartProduct product) {
    product.quantity++;
    _updateProduct(product);
  }

  void _updateProduct(CartProduct product) {
    _firestore
        .collection('users')
        .document(_user.firebaseUser.uid)
        .collection('cart')
        .document(product.cid)
        .updateData(product.toMap());
    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot query = await _firestore
        .collection('users')
        .document(_user.firebaseUser.uid)
        .collection('cart')
        .getDocuments();
    _products =
        query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }
}
