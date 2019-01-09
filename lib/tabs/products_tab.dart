import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  Firestore _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _firestore.collection('products').getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          List<Widget> dividedTiles = ListTile.divideTiles(
                  tiles: snapshot.data.documents.map((document) {
                    return CategoryTile(document);
                  }).toList(),
                  color: Colors.grey[500])
              .toList();
          return ListView(children: dividedTiles);
        }
      },
    );
  }
}
