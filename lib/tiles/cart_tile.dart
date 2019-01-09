import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/datas/cart_product.dart';
import 'package:virtual_store/datas/product_data.dart';

class CartTile extends StatelessWidget {
  final CartProduct _product;

  CartTile(this._product);

  @override
  Widget build(BuildContext context) {
    _buildContent() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              _product.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_product.productData.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16.0)),
                  Text('Tamanho: ${_product.size}',
                      style: TextStyle(fontWeight: FontWeight.w300)),
                  Text('R\$ ${_product.productData.price.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        onPressed: _product.quantity > 1 ? () {} : null,
                      ),
                      Text(_product.quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: Text('Remover'),
                        textColor: Colors.grey[500],
                        onPressed: () {},
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    // return Container(child: Text('CartTitle works!'),);
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      child: _product.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: Firestore.instance
                  .collection('products')
                  .document(_product.category)
                  .collection('items')
                  .document(_product.pid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(_product.pid);
                  print(_product.size);
                  print(snapshot.data['name']);
                  _product.productData =
                      ProductData.fromDocument(snapshot.data);
                  return _buildContent();
                } else {
                  return Container(
                      height: 70.0,
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center);
                }
              },
            )
          : _buildContent(),
    );
  }
}
