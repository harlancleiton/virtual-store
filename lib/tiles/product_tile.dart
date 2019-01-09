import 'package:flutter/material.dart';
import 'package:virtual_store/datas/product_data.dart';
import 'package:virtual_store/screens/product_screen.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final ProductData _productData;

  const ProductTile(this.type, this._productData);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductScreen(_productData)));
      },
      child: Card(
        child: type == 'grid'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 0.8,
                    child: Image.network(_productData.images[0],
                        fit: BoxFit.cover),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _productData.name,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'R\$ ${_productData.price.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Image.network(_productData.images[0],
                        fit: BoxFit.cover, height: 250.0),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _productData.name,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'R\$ ${_productData.price.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
