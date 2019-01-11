import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  final String _orderId;

  OrderScreen(this._orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pedido Realizado')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
              size: 80.0,
            ),
            Text('Pedido realizado com sucesso!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            Text('Código do Pedido: $_orderId',
                style: TextStyle(fontSize: 16.0))
          ],
        ),
      ),
    );
  }
}
