import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'package:uuid/uuid.dart';

import '../models/address.dart';
import '../models/item.dart';
import '../models/request.dart';
import '../models/user.dart' as model;
import 'storage_methods.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadItem({
    required double time_used,
    required String desc,
    required List<XFile> imgs,
    // required List<String> imgs,
    required GeoPoint location,
    required String name,
    required String oldOwner,
    required String oldOwnerUID,
    required String type,
    required String city,
    required String state,
    required String country,
    required int zipCode,
  }) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state mantime_usedment
    String res = "Some error occurred";
    try {
      print(1);
      List<String> photoUrls = [];
      for (var itemPhoto in imgs) {
        Uint8List photo = await itemPhoto.readAsBytes();

        String photoUrl = await StorageMethods().uploadImageToStorage(
            childName: 'items', file: photo, isItem: true);

        photoUrls.add(photoUrl);
      }
      print(2);
      String itemId = const Uuid().v1(); // creates unique id based on time

      Item item = Item(
        address: Address(
            location: location,
            city: city,
            state: state,
            country: country,
            zipCode: zipCode),
        time_used: time_used,
        datePosted: DateTime.now(),
        desc: desc,
        imgs: photoUrls,
        name: name,
        oldOwner: oldOwner,
        oldOwnerUID: oldOwnerUID,
        itemId: itemId,
        type: type,
      );

      var uploadItemData = item.toMap();
      print(3);
      print(uploadItemData);
      await _firestore
          .collection('itemsForDonation')
          .doc(itemId)
          .set(uploadItemData);
      print(4);
      await _firestore.collection('users').doc(oldOwnerUID).update({
        'itemsForDonation': FieldValue.arrayUnion([itemId])
      });
      print(5);
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    print(6);
    return res;
  }

  Future<String> AddFavItem({
    required String itemId,
    required model.User user,
  }) async {
    String res = "Some error occurred";
    try {
      user.favItemList.add(itemId);
      _firestore.collection('items').doc(user.uid).set(user.toMap());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<model.User> getUserDetails({String? userId}) async {
    var userSnap = (userId == null)
        ? await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
        : await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
    var userData = {};
    userData = userSnap.data()!;

    model.User cUser = model.User(
      address: Address(
        location: userData['address']['location'],
        city: userData['address']['city'], //works
        country: userData['address']['country'], //works
        state: userData['address']['state'], //works
        zipCode: userData['address']['zipCode'],
      ),
      contactNo: userData['contactNo'],
      userName: userData['userName'],
      uid: userData['uid'],
      firstName: userData['firstName'],
      lastName: userData['lastName'],
      dob: userData['dob'].toDate(),
      emailId: userData['emailId'],
      profileImg: userData['profileImg'],
      backCoverImg: userData['backCoverImg'],
      favItemList: userData['favItemList'],
      itemsForDonation: userData['itemsForDonation'],
      // itemsForDonation: [],
      itemsDonated: userData['itemsDonated'],
      // itemsDonated: [],
    );
    return cUser;
  }

  Future<List<Item>> getItemList(String currentUserUid) async {
    var itemListdb = [];
    List<Item> itemList = [];
    QuerySnapshot<Map<String, dynamic>> itemSnap =
        await FirebaseFirestore.instance
            .collection('itemsForDonation') //add the below comment
            .where("oldOwnerUID", isNotEqualTo: currentUserUid)
            .get();
    itemListdb = itemSnap.docs;
    for (var item in itemListdb) {
      var curItem = Item(
        address: Address(
          location: item["address"]['location'],
          city: item["address"]["city"],
          state: item["address"]["state"],
          country: item["address"]["country"],
          zipCode: item["address"]["zipCode"],
        ),
        time_used: (item["time_used"] * 1.0), //problem

        datePosted: item["datePosted"].toDate(), //problem
        desc: item["desc"],

        imgs: item["imgs"], // problem
        name: item["name"],
        oldOwner: item["oldOwner"],
        oldOwnerUID: item["oldOwnerUID"],
        itemId: item["itemId"],
        type: item["type"],
      );
      // print(curItem);
      itemList.add(curItem);
    }
    // print(itemList);
    return itemList;
  }

  Future<Item> getItem(String itemId) async {
    DocumentSnapshot<Map<String, dynamic>> itemSnap = await FirebaseFirestore
        .instance
        .collection('itemsForDonation')
        .doc(itemId)
        .get();

    if (itemSnap.data() == null) {
      itemSnap = await FirebaseFirestore.instance
          .collection('itemsDonated')
          .doc(itemId)
          .get();
    }
    Map<String, dynamic> item = itemSnap.data()!;

    Item curItem = Item(
      time_used: (item["time_used"] * 1.0),

      desc: item["desc"],

      imgs: item["imgs"], // problem
      name: item["name"],
      oldOwner: item["oldOwner"],
      oldOwnerUID: item["oldOwnerUID"],
      itemId: item["itemId"],
      type: item["type"],
      datePosted: item["datePosted"].toDate(), //problem
      address: Address(
        location: item['address']['location'],
        city: item["address"]["city"],
        state: item["address"]["state"],
        country: item["address"]["country"],
        zipCode: item["address"]["zipCode"],
      ),
    );

    return curItem;
  }

  Future<List<Item>> getCustomItemList(
      String itemListType, List<dynamic> itemIdList) async {
    List<Item> itemList = [];
    for (var p in itemIdList) {
      DocumentSnapshot<Map<String, dynamic>> itemSnap = await FirebaseFirestore
          .instance
          .collection(itemListType)
          .doc(p)
          .get();

      if (itemSnap.data() == null) {
        itemSnap = await FirebaseFirestore.instance
            .collection('itemsDonated')
            .doc(p)
            .get();
      }

      Map<String, dynamic> item = itemSnap.data()!;
      Item curItem = Item(
        time_used: (item["time_used"] * 1.0),

        desc: item["desc"],

        imgs: item["imgs"], // problem
        name: item["name"],
        oldOwner: item["oldOwner"],
        oldOwnerUID: item["oldOwnerUID"],
        itemId: item["itemId"],
        type: item["type"],
        datePosted: item["datePosted"].toDate(), //problem
        address: Address(
          location: item['address']['location'],
          city: item["address"]["city"],
          state: item["address"]["state"],
          country: item["address"]["country"],
          zipCode: item["address"]["zipCode"],
        ),
      );
      itemList.add(curItem);
    }
    // print(itemList);
    return itemList;
  }

//query for user uploaded items
// Future<List<Item>> getItemList()async{
//       var itemForDonationSnap = await FirebaseFirestore.instance
//           .collection('itemsforDonation')
//           .where('oldOwnerUID',
//               isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//           .get();

  Future<String> changeFavList(
      model.User cUser, String itemId, bool isFavItem) async {
    String res = "Some error occured, please try again";
    cUser.favItemList.remove(itemId);

    if (isFavItem) {
      cUser.favItemList.remove(itemId);
      FirebaseFirestore.instance
          .collection("users")
          .doc(cUser.uid)
          .set(cUser.toMap());
      res = "success";
    } else {
      cUser.favItemList.add(itemId);
      FirebaseFirestore.instance
          .collection("users")
          .doc(cUser.uid)
          .set(cUser.toMap());
      res = "success";
    }
    return res;
  }

  Future<String> sendDonationRequest(Item item, model.User sender) async {
    String res = "Some error occurred, please try again.";
    try {
      String requestId = const Uuid().v1();
      Request request = Request(
        ownerName: item.oldOwner,
        ownerUid: item.oldOwnerUID,
        itemId: item.itemId,
        itemName: item.name,
        requestId: requestId,
        senderName: sender.firstName + " " + sender.lastName,
        senderUid: sender.uid,
        status: "Pending",
      );

      var uploadRequest = request.toMap();

      await _firestore.collection('requests').doc(requestId).set(uploadRequest);
      res = "success";
      print(res);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<List<Request>> getSentRequests(String userId) async {
    List<Request> sentRequests = [];

    var sentdb = [];
    QuerySnapshot<Map<String, dynamic>> requestSnap = await _firestore
        .collection("requests")
        .where("senderUid", isEqualTo: userId)
        .get();

    sentdb = requestSnap.docs;
    for (var r in sentdb) {
      var req = Request(
        ownerName: r['ownerName'],
        ownerUid: r['ownerUid'],
        itemId: r['itemId'],
        itemName: r['itemName'],
        requestId: r['requestId'],
        senderName: r['senderName'],
        senderUid: r['senderUid'],
        status: r['status'],
      );
      sentRequests.add(req);
    }
    return sentRequests;
  }

  Future<List<Request>> getReceivedRequests(String userId) async {
    List<Request> rRequests = [];
    var requestdb = [];
    QuerySnapshot<Map<String, dynamic>> requestSnap = await _firestore
        .collection("requests")
        .where("ownerUid", isEqualTo: userId)
        .get();

    requestdb = requestSnap.docs;
    for (var r in requestdb) {
      var req = Request(
        ownerName: r['ownerName'],
        ownerUid: r['ownerUid'],
        itemId: r['itemId'],
        itemName: r['itemName'],
        requestId: r['requestId'],
        senderName: r['senderName'],
        senderUid: r['senderUid'],
        status: r['status'],
      );
      rRequests.add(req);
    }
    return rRequests;
  }

  Future<String> cancelRequestFromSender(Request request) async {
    String res = "Some error occured. Try again later.";

    try {
      await _firestore.collection('requests').doc(request.requestId).delete();
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    print(6);

    return res;
  }

  Future<String> cancelRequestByOwner(Request request) async {
    String res = "Some error occurred";
    try {
      request.status = "Rejected";
      await _firestore
          .collection('requests')
          .doc(request.requestId)
          .set(request.toMap());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> confirmRequest(Request request) async {
    String res = "Some error occurred";
    try {
      request.status = "Accepted";
      await _firestore
          .collection('requests')
          .doc(request.requestId)
          .set(request.toMap());

      Item item = await getItem(request.itemId);

      await _firestore.collection("itemsForDonation").doc(item.itemId).delete();

      await _firestore
          .collection('itemsDonated')
          .doc(item.itemId)
          .set(item.toMap());

      model.User sender = await getUserDetails(userId: request.senderUid);
      sender.itemsDonated.add(item.itemId);
      await _firestore.collection("users").doc(sender.uid).set(sender.toMap());

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
