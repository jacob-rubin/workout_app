import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CloudStorageProvider extends ChangeNotifier {
  late FirebaseStorage _storage;

  CloudStorageProvider() {
    _storage = FirebaseStorage.instance;
  }

  // Get image from Firebase Storage
  Future<Image> getImage(String id) async {
    final Reference imageRef = _storage.ref().child('360/$id.gif');
    final String url = await imageRef.getDownloadURL();
    print('url: $url');
    return Image.network(url);
  }
}
