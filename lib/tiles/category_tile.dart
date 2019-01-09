import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/screens/category_screen.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot _documentSnapshot;

  CategoryTile(this._documentSnapshot);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CategoryScreen(_documentSnapshot)));
      },
      leading: CircleAvatar(
        radius: 24.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(_documentSnapshot.data['icon']),
      ),
      title: Text(_documentSnapshot.data['title']),
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
