import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/address.dart';
import 'storage_methods.dart';
import '../models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> signUpUser({
    required String userName,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required DateTime dob,
    required String contactNumber,
    required GeoPoint location,
    required String city,
    required String state,
    required String country,
    required int zipCode,
    required Uint8List profilePicFile,
    required Uint8List backCoverPicFile,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          userName.isNotEmpty &&
          firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          dob != DateTime.now() &&
          (int.parse(contactNumber) > 1000000000 &&
              int.parse(contactNumber) <= 9999999999) &&
          city.isNotEmpty &&
          state.isNotEmpty &&
          country.isNotEmpty &&
          (zipCode >= 100000 && zipCode <= 999999)) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String profilePicUrl = await StorageMethods().uploadImageToStorage(
            childName: "ProfilePics", file: profilePicFile, isItem: false);
        String backCoverPicUrl = await StorageMethods().uploadImageToStorage(
            childName: "BackCoverPics", file: backCoverPicFile, isItem: false);

        model.User user = model.User(
          userName: userName,
          firstName: firstName,
          lastName: lastName,
          dob: dob,
          emailId: email,
          contactNo: contactNumber.toString(),
          uid: cred.user!.uid,
          profileImg: profilePicUrl,
          backCoverImg: backCoverPicUrl,
          address: Address(
            location: location,
            city: city,
            state: state,
            country: country,
            zipCode: zipCode,
          ),
          favItemList: [],
          itemsDonated: [],
          itemsForDonation: [],
        );

        // print(user);
        var uploadUser = user.toMap();
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(uploadUser);
        res = "success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        // print(cred.user!.uid);

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await _auth.signInWithCredential(authCredential);
      User? user = result.user;

      if (result != null) {
        return 'success';
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => HomePage()));
      }

      // if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
    }
    return "fails";
  }
}
