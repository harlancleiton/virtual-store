import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/datas/cart_product.dart';
import 'package:virtual_store/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel extends Model {
  UserModel _user;
  List<CartProduct> _products = [];
  Firestore _firestore = Firestore.instance;
  bool _isLoading = false;
  String _couponCode;
  double _discountPercentage = 0.0;

  CartModel(this._user) {
    if (_user.isLoggedIn()) _loadCartItems();
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void couponDiscount(String code, double percentage) {
    _couponCode = code;
    _discountPercentage = percentage;
    notifyListeners();
  }

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

  bool get isLoading => _isLoading;

  get couponCode => _couponCode;

  double get discountPercentage => _discountPercentage;

  double get discount {
    return productsPrice * _discountPercentage / 100;
  }

  double get shipPrice {
    return 10.00;
  }

  double get productsPrice {
    double price = 0.0;
    _products.forEach((p) {
      if (p.productData != null) price += p.quantity * p.productData.price;
    });
    return price;
  }

  void updatePrices() {
    notifyListeners();
  }

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

  Future<String> finishOrder() async {
    if (_products.length == 0) return null;
    _isLoading = true;
    notifyListeners();
    DocumentReference refOrder = await _firestore.collection('orders').add({
      'userId': _user.firebaseUser.uid,
      'products': _products.map((p) => p.toMap()).toList(),
      'shipPrice': shipPrice,
      'discount': discount,
      'totalPrice': productsPrice - discount + shipPrice,
      'status': 1
    });
    await _firestore
        .collection('users')
        .document(_user.firebaseUser.uid)
        .collection('orders')
        .document(refOrder.documentID)
        .setData({'orderId': refOrder.documentID});

    QuerySnapshot query = await _firestore
        .collection('users')
        .document(_user.firebaseUser.uid)
        .collection('cart')
        .getDocuments();
    query.documents.forEach((doc) {
      doc.reference.delete();
    });
    _products.clear();
    _couponCode = null;
    _discountPercentage = 0.0;
    _isLoading = false;
    notifyListeners();
    return refOrder.documentID;
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
