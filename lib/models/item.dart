import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'address.dart';
import 'user.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Item {
  double time_used;
  String desc;
  List<dynamic> imgs;
  String name;
  String oldOwner;
  String oldOwnerUID;
  String newOwner = "dummy-user";
  String newOwnerUID = "dummy-user";
  String itemId;
  String type;
  DateTime datePosted;
  double distance = 0;
  Address address;
  Item({
    required this.time_used,
    required this.desc,
    required this.imgs,
    required this.name,
    required this.oldOwner,
    required this.oldOwnerUID,
    required this.itemId,
    required this.type,
    required this.datePosted,
    required this.address,
  });

  Item copyWith({
    double? age,
    String? breed,
    String? desc,
    String? gender,
    List<dynamic>? imgs,
    String? name,
    String? oldOwner,
    String? oldOwnerUID,
    String? itemId,
    String? type,
    DateTime? datePosted,
    Address? address,
  }) {
    return Item(
      time_used: time_used ?? this.time_used,
      desc: desc ?? this.desc,
      imgs: imgs ?? this.imgs,
      name: name ?? this.name,
      oldOwner: oldOwner ?? this.oldOwner,
      oldOwnerUID: oldOwnerUID ?? this.oldOwnerUID,
      itemId: itemId ?? this.itemId,
      type: type ?? this.type,
      datePosted: datePosted ?? this.datePosted,
      address: address ?? this.address,
    );
  }

  Item.dummy()
      : this(
          time_used: 2.0,
          desc:
              "Everything is so expensive.Going to a bar is a fun thing to do.Here's my big brother. Doesn't he look good?",
          imgs: [
            "assets/images/dumbdog.jpg",
          ],
          name: 'Duggu',
          itemId: '',
          type: 'dog',
          oldOwner: 'Rahul Mokara',
          oldOwnerUID: '',
          datePosted: DateTime.now(),
          address: Address(
            location: GeoPoint(0, 0),
            city: "Porbandar",
            state: "Gujarat",
            country: "India",
            zipCode: 360575,
          ),
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'time_used': time_used,
      'desc': desc,
      'imgs': imgs,
      'name': name,
      'oldOwner': oldOwner,
      'oldOwnerUID': oldOwnerUID,
      'itemId': itemId,
      'type': type,
      'datePosted': Timestamp.fromDate(datePosted),
      'address': address.toMap(),
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      time_used: map['time_used'] as double,
      desc: map['desc'] as String,
      name: map['name'] as String,
      oldOwner: map['oldOwner'] as String,
      oldOwnerUID: map['oldOwnerUID'] as String,
      itemId: map['itemId'] as String,
      type: map['type'] as String,
      datePosted: DateTime.fromMillisecondsSinceEpoch(map['datePosted'] as int),
      address: Address.fromMap(map['address'] as Map<String, dynamic>),
      imgs: List<String>.from((map['imgs'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Item(time used: $time_used, desc: $desc, imgs: $imgs, name: $name, oldOwner: $oldOwner, oldOwnerUID: $oldOwnerUID, itemId: $itemId, type: $type, datePosted: $datePosted, address: $address)';
  }

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.time_used == time_used &&
        other.desc == desc &&
        listEquals(other.imgs, imgs) &&
        other.name == name &&
        other.oldOwner == oldOwner &&
        other.oldOwnerUID == oldOwnerUID &&
        other.itemId == itemId &&
        other.type == type &&
        other.datePosted == datePosted &&
        other.address == address;
  }

  @override
  int get hashCode {
    return time_used.hashCode ^
        desc.hashCode ^
        imgs.hashCode ^
        name.hashCode ^
        oldOwner.hashCode ^
        oldOwnerUID.hashCode ^
        itemId.hashCode ^
        type.hashCode ^
        datePosted.hashCode ^
        address.hashCode;
  }
}

// List<Item> itemList = [
//   Item(
//     age: 2.0,
//     breed: 'Labrador',
//     desc:
//         "Everything is so expensive.Going to a bar is a fun thing to do.Here's my big brother. Doesn't he look good?",
//     gender: 'M',
//     imgs: [
//       "assets/images/dumbdog.jpg",
//     ],
//     name: 'Duggu',
//     itemId: '',
//     type: 'dog',
//     oldOwner: 'Rahul Mokara',
//     oldOwnerUID: '',
//     datePosted: DateTime.now(),
//     address: Address(
//       latitude: "P-131 Near Shivam Appt",
//       longitude: "RajivNagar",
//       city: "Porbandar",
//       state: "Gujarat",
//       country: "India",
//       zipCode: 360575,
//     ),
//   ),
//   Item(
//     age: 1,
//     breed: 'Ginger',
//     desc:
//         "It's not a big room, but it's beautiful.I don't know where the list of my friends went.I am filthy rich.",
//     gender: 'F',
//     imgs: [
//       "assets/images/catbee.jpg",
//       "assets/images/dumbdog.jpg",
//       "assets/images/cutebirt.jpg",
//     ],
//     name: 'Pussy Cat',
//     itemId: '',
//     type: 'cat',
//     oldOwner: 'Rahul Mokaria',
//     oldOwnerUID: '',
//     datePosted: DateTime.now(),
//     address: Address(
//       latitude: "P-131 Near Shivam Appt",
//       longitude: "RajivNagar",
//       city: "Porbandar",
//       state: "Gujarat",
//       country: "India",
//       zipCode: 360575,
//     ),
//   ),
//   Item(
//     age: 1.5,
//     breed: 'Parrot',
//     desc:
//         "It's not a big room, but it's beautiful.I don't know where the list of my friends went.I am filthy rich.",
//     gender: 'F',
//     imgs: [
//       "assets/images/cutebirt.jpg",
//     ],
//     name: 'Mithoo',
//     itemId: '',
//     type: 'bird',
//     oldOwner: 'Rahul Moaria',
//     oldOwnerUID: '',
//     datePosted: DateTime.now(),
//     address: Address(
//       latitude: "P-131 Near Shivam Appt",
//       longitude: "RajivNagar",
//       city: "Porbandar",
//       state: "Gujarat",
//       country: "India",
//       zipCode: 360575,
//     ),
//   ),
//   Item(
//     age: 4,
//     breed: 'Pug',
//     desc:
//         "It's not a big room, but it's beautiful.I don't know where the list of my friends went.I am filthy rich.",
//     gender: 'M',
//     imgs: [
//       "assets/images/dumbdog.jpg",
//     ],
//     name: 'Lucy',
//     itemId: '',
//     type: 'dog',
//     oldOwner: 'Rhul Mokaria',
//     oldOwnerUID: '',
//     datePosted: DateTime.now(),
//     address: Address(
//       latitude: "P-131 Near Shivam Appt",
//       longitude: "RajivNagar",
//       city: "Porbandar",
//       state: "Gujarat",
//       country: "India",
//       zipCode: 360575,
//     ),
//   ),
//   Item(
//     age: 2.0,
//     breed: 'Ginger',
//     desc:
//         "It's not a big room, but it's beautiful.I don't know where the list of my friends went.I am filthy rich.",
//     gender: 'F',
//     imgs: [
//       "assets/images/catbee.jpg",
//     ],
//     name: 'Pussy Cat',
//     itemId: '',
//     type: 'cat',
//     oldOwner: 'Rahul Moaria',
//     oldOwnerUID: '',
//     datePosted: DateTime.now(),
//     address: Address(
//       latitude: "P-131 Near Shivam Appt",
//       longitude: "RajivNagar",
//       city: "Porbandar",
//       state: "Gujarat",
//       country: "India",
//       zipCode: 360575,
//     ),
//   ),
// ];
