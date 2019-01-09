import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Firestore _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    Widget _builderBodyBack() => Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 211, 118, 130),
            Color.fromARGB(255, 253, 181, 168)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ));
    return Stack(children: <Widget>[
      _builderBodyBack(),
      CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Loja Virtual'),
              centerTitle: true,
            ),
          ),
          FutureBuilder<QuerySnapshot>(
              future: _firestore
                  .collection('home')
                  .orderBy('position')
                  .getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                else
                  return SliverStaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0.5,
                    crossAxisSpacing: 0.5,
                    staggeredTiles: snapshot.data.documents.map((document) {
                      return StaggeredTile.count(
                          document.data['x'], document.data['y']);
                    }).toList(),
                    children: snapshot.data.documents.map((document) {
                      return FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: document.data['image'],
                          fit: BoxFit.cover);
                    }).toList(),
                  );
              })
        ],
      )
    ]);
  }
}
