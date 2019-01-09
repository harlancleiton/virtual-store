import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String id;
  String category;
  String name;
  String description;
  double price;
  List sizes;
  List images;

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    name = snapshot.data['name'];
    description = snapshot.data['description'];
    price = snapshot.data['price'];
    sizes = snapshot.data['sizes'];
    images = snapshot.data['images'];
  }

  Map<String, dynamic> toResumeMap() {
    return {'name': name, 'description': description, 'price': price};
  }
}
