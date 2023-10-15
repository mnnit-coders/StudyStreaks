// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'address.dart';

class User {
  String uid;
  String userName;
  String firstName;
  String lastName;
  String profileImg;
  String backCoverImg;
  DateTime dob;
  String emailId;
  String contactNo;
  Address address;
  List<dynamic> favItemList;
  List<dynamic> itemsForDonation;
  List<dynamic> itemsDonated;
  User({
    required this.uid,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.profileImg,
    required this.backCoverImg,
    required this.dob,
    required this.emailId,
    required this.contactNo,
    required this.address,
    required this.favItemList,
    required this.itemsForDonation,
    required this.itemsDonated,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
        address: Address(
          location: snapshot['address']['location'],
          city: snapshot['address']['city'],
          state: snapshot['address']['state'],
          country: snapshot['address']['country'],
          zipCode: snapshot['address']['zipcode'],
        ),
        backCoverImg: snapshot['backCoverImg'],
        contactNo: snapshot['contactNo'],
        dob: snapshot['dob'].toDate(),
        emailId: snapshot['emailId'],
        favItemList: snapshot['favItemList'],
        firstName: snapshot['firstName'],
        lastName: snapshot['lastName'],
        profileImg: snapshot['profileImg'],
        uid: snapshot['uid'],
        userName: snapshot['userName'],
        itemsForDonation: snapshot['itemsForDonation'],
        itemsDonated: snapshot['itemsDonated']);
  }

  User copyWith({
    String? uid,
    String? userName,
    String? firstName,
    String? lastName,
    String? profileImg,
    String? backCoverImg,
    DateTime? dob,
    String? emailId,
    String? contactNo,
    Address? address,
    List<dynamic>? favItemList,
    List<dynamic>? itemsForDonation,
    List<dynamic>? itemsDonated,
  }) {
    return User(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImg: profileImg ?? this.profileImg,
      backCoverImg: backCoverImg ?? this.backCoverImg,
      dob: dob ?? this.dob,
      emailId: emailId ?? this.emailId,
      contactNo: contactNo ?? this.contactNo,
      address: address ?? this.address,
      favItemList: favItemList ?? this.favItemList,
      itemsForDonation: itemsForDonation ?? this.itemsForDonation,
      itemsDonated: itemsDonated ?? this.itemsDonated,
    );
  }

  User.dummyUser()
      : this(
          uid: "",
          userName: "John123",
          firstName: "John",
          lastName: "Doe",
          profileImg: "",
          backCoverImg: "",
          dob: DateTime.now(),
          emailId: "",
          contactNo: "",
          address: Address(
            city: "",
            country: '',
            location: const GeoPoint(0, 0),
            state: '',
            zipCode: 123235,
          ),
          favItemList: [],
          itemsForDonation: [],
          itemsDonated: [],
        );
  //      {
  //   return User(
  //     uid: "",
  //     userName: "John123",
  //     firstName: "John",
  //     lastName: "Doe",
  //     profileImg: "",
  //     backCoverImg: "",
  //     dob: DateTime.now(),
  //     emailId: "",
  //     contactNo: "",
  //     address: Address(
  //       city: "",
  //       country: '',
  //       location: const GeoPoint(0, 0),
  //       state: '',
  //       zipCode: 123235,
  //     ),
  //     favItemList: [],
  //     itemsForDonation: [],
  //     itemsDonated: [],
  //   );
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'profileImg': profileImg,
      'backCoverImg': backCoverImg,
      'dob': Timestamp.fromDate(dob),
      'emailId': emailId,
      'contactNo': contactNo,
      'address': address.toMap(),
      'favItemList': favItemList,
      'itemsForDonation': itemsForDonation,
      'itemsDonated': itemsDonated,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      userName: map['userName'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      profileImg: map['profileImg'] as String,
      backCoverImg: map['backCoverImg'] as String,
      dob: DateTime.fromMillisecondsSinceEpoch(map['dob'] as int),
      emailId: map['emailId'] as String,
      contactNo: map['contactNo'] as String,
      address: Address.fromMap(map['address'] as Map<String, dynamic>),
      favItemList: List<dynamic>.from(map['favItemList'] as List<dynamic>),
      itemsForDonation:
          List<dynamic>.from(map['itemsForDonation'] as List<dynamic>),
      itemsDonated: List<dynamic>.from(map['itemsDonated'] as List<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(uid: $uid, userName: $userName, firstName: $firstName, lastName: $lastName, profileImg: $profileImg, backCoverImg: $backCoverImg, dob: $dob, emailId: $emailId, contactNo: $contactNo, address: $address, favItemList: $favItemList, itemsForDonation: $itemsForDonation, itemsDonated: $itemsDonated)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.userName == userName &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.profileImg == profileImg &&
        other.backCoverImg == backCoverImg &&
        other.dob == dob &&
        other.emailId == emailId &&
        other.contactNo == contactNo &&
        other.address == address &&
        listEquals(other.favItemList, favItemList) &&
        listEquals(other.itemsForDonation, itemsForDonation) &&
        listEquals(other.itemsDonated, itemsDonated);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        userName.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        profileImg.hashCode ^
        backCoverImg.hashCode ^
        dob.hashCode ^
        emailId.hashCode ^
        contactNo.hashCode ^
        address.hashCode ^
        favItemList.hashCode ^
        itemsForDonation.hashCode ^
        itemsDonated.hashCode;
  }
}

// User cUser = User(
//   address: Address(
//     latitude: "P-131 Near Shivam Appt",
//     longitude: "RajivNagar",
//     city: "Porbandar",
//     state: "Gujarat",
//     country: "India",
//     zipCode: 360575,
//   ),
//   favItemList: [],
//   backCoverImg: 'assets/images/cutebirt.jpg',
//   contactNo: '8707022722',
//   dob: DateTime.now(),
//   emailId: 'rahulmokaria.rm@gmail.com',
//   firstName: 'Rahul',
//   lastName: 'Mokaria',
//   profileImg: 'assets/images/owl.jpg',
//   uid: 'dfsebzdhlgvuighaliSA7tg',
//   userName: 'rahulMokaria',
// );

// User cUser = FirebaseAuth.instance.currentUser.to
// Future<User> getUserDetails() async {
//   DocumentSnapshot<Map<String, dynamic>> userSnap = await FirebaseFirestore
//       .instance
//       .collection("users")
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .get();
//   User cUser = User(
//       // address: Address(latitude: userSnap['address'][]),
//       a
//   return cUser;
// }
