import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/models/user_model.dart';
import 'package:virtual_store/screens/login_screen.dart';
import 'package:virtual_store/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (!model.isLoggedIn()) {
        return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.view_list,
                    size: 80.0, color: Theme.of(context).primaryColor),
                SizedBox(height: 16.0),
                Text(
                  'Faça login para acompanhar seus pedidos',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                RaisedButton(
                  child: Text('Entrar', style: TextStyle(fontSize: 18.0)),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                )
              ],
            ));
      } else {
        Firestore firestore = Firestore.instance;
        return FutureBuilder<QuerySnapshot>(
          future: firestore
              .collection('users')
              .document(model.firebaseUser.uid)
              .collection('orders')
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: snapshot.data.documents
                    .map((doc) => OrderTile(doc.documentID))
                    .toList(),
              );
            }
          },
        );
      }
    });
  }
}
