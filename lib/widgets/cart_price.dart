import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/models/cart_model.dart';

class CartPrice extends StatelessWidget {
  VoidCallback _buy;

  CartPrice(this._buy);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant<CartModel>(
          builder: (context, child, model) {
            double price = model.productsPrice;
            double discount = model.discount;
            double shipPrice = model.shipPrice;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Resumo do Pedido',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Subtotal'),
                    Text('R\$ ${price.toStringAsFixed(2)}'),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Desconto'),
                    Text('R\$ ${discount.toStringAsFixed(2)}'),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Entrega'),
                    Text('R\$ ${shipPrice.toStringAsFixed(2)}'),
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Total',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Text(
                        'R\$ ${(price + shipPrice - discount).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor))
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                RaisedButton(
                  child: Text('Finalizar Pedido'),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: _buy,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
