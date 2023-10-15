import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(
      {required String childName,
      required Uint8List file,
      required bool isItem}) async {
    // creating location to our firebase storage
    Reference ref;
    if (isItem) {
      String uid = const Uuid().v1();
      ref = _storage.ref().child(childName).child(uid);
    } else {
      ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
    }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
