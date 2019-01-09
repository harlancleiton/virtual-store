import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  Map<String, dynamic> _userData = Map();
  bool isLoading = false;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  void singUp(
      {@required Map<String, dynamic> userData,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    _notify(true);
    _auth
        .createUserWithEmailAndPassword(
            email: userData['email'], password: password)
        .then((user) async {
      _user = user;
      await _saveUserData(userData);
      _notify(false);
      onSuccess();
    }).catchError((e) {
      _notify(false);
      onFail();
    });
  }

  void singOut() async {
    await _auth.signOut();
    _userData = Map();
    _user = null;
    notifyListeners();
  }

  void singIn(
      {@required String email,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    _notify(true);
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {
      _user = user;
      await _loadCurrentUser();
      onSuccess();
      _notify(false);
      onSuccess();
    }).catchError((error) {
      onFail();
      _notify(false);
    });
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return _user != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    _userData = userData;
    Firestore firestore = Firestore.instance;
    await firestore.collection('users').document(_user.uid).setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    Firestore firestore = Firestore.instance;
    if (_user == null) _user = await _auth.currentUser();
    if (_user != null) {
      if (userData['name'] == null) {
        DocumentSnapshot document =
            await firestore.collection('users').document(_user.uid).get();
        _userData = document.data;
      }
    }
    notifyListeners();
  }

  void _notify(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  Map<String, dynamic> get userData => _userData;

  FirebaseUser get firebaseUser => _user;
}
