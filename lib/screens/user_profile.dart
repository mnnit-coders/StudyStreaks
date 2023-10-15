import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/address.dart';
import '../models/item.dart';
import '../models/user.dart' as model;
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../widgets/item_card.dart';
import 'add_item.dart';
import 'favorite_items.dart';
import 'home_page.dart';

class UserProfile extends StatefulWidget {
  final model.User cUser;
  const UserProfile({
    Key? key,
    required this.cUser,
  }) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _isLoading = false;
  int _selectedCategory = 1;

  Map itemListdb = {};
  List<Item> itemsForDonationList = [];
  List<Item> itemsDonatedList = [];
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      itemsForDonationList = await FireStoreMethods()
          .getCustomItemList("itemsForDonation", widget.cUser.itemsForDonation);
      itemsDonatedList = await FireStoreMethods()
          .getCustomItemList("itemsDonated", widget.cUser.itemsDonated);
    } catch (e) {
      // showSnackBar(
      //   context,
      //   e.toString(),
      // );
    }
    setState(() {
      _isLoading = false;
    });
    // print(userData);
  }

  void navigateToAddItem() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddItem(
          cUser: widget.cUser,
          setIndex: (index) {
            setState(() {
              menuItemSelected = index;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          "Profile",
          style: TextStyle(
            color: primary,
          ),
          textAlign: TextAlign.center,
        ),
        // elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.barsStaggered,
            color: primary,
          ),
          onPressed: () {
            zoomDrawerController.toggle!();
          },
        ),
        // shadowColor: secondaryLight,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.02,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_width * 10),
              topRight:
                  Radius.circular(MediaQuery.of(context).size.width * 0.1),
            ),
            color: secondary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              MediaQuery.of(context).size.width * 0.1),
                          topRight: Radius.circular(
                              MediaQuery.of(context).size.width * 0.1),
                          // bottomLeft: Radius.circular(
                          // MediaQuery.of(context).size.width * 0.1),
                          // bottomRight: Radius.circular(
                          // MediaQuery.of(context).size.width * 0.1),
                        ),
                        child: Image.network(
                          widget.cUser.backCoverImg,
                          height: MediaQuery.of(context).size.width * 0.5,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.25,
                      ),
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.3,
                    right: MediaQuery.of(context).size.width * 0.05,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.25),
                      child: Container(
                        color: secondary,
                        height: MediaQuery.of(context).size.width * 0.44,
                        width: MediaQuery.of(context).size.width * 0.44,
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.32,
                    right: MediaQuery.of(context).size.width * 0.07,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.2),
                      child: Container(
                        color: secondary,
                        height: MediaQuery.of(context).size.width * 0.4,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Image.network(
                          widget.cUser.profileImg,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: MediaQuery.of(context).size.width * 0.3,
                  //   right: MediaQuery.of(context).size.width * 0.35,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(
                  //         MediaQuery.of(context).size.width * 0.2),
                  //     child: InkWell(
                  //       onTap: () => changeImageDropDown(),
                  //       child: Container(
                  //         color: secondary,
                  //         height: MediaQuery.of(context).size.width * 0.14,
                  //         width: MediaQuery.of(context).size.width * 0.14,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.32,
                    right: MediaQuery.of(context).size.width * 0.37,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.2),
                      child: InkWell(
                        onTap: () => changeImageDropDown(),
                        child: Container(
                          color: primary,
                          height: MediaQuery.of(context).size.width * 0.1,
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Icon(
                            FontAwesomeIcons.camera,
                            color: white,
                            size: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                widget.cUser.userName,
                textScaleFactor: 1.5,
                style: TextStyle(
                  color: black,
                ),
              ),
              Text(
                "${widget.cUser.firstName} ${widget.cUser.lastName}",
                textScaleFactor: 1.7,
                style: TextStyle(
                  color: black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${widget.cUser.address.city}, ${widget.cUser.address.state},",
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: black,
                ),
              ),
              Text(
                "${widget.cUser.address.country}",
                textScaleFactor: 1,
                style: TextStyle(
                  color: black,
                ),
              ),
              Text(
                widget.cUser.emailId,
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.cUser.contactNo,
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: black,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // additem();
                    },
                    child: Icon(
                      Icons.edit,
                      color: black,
                    ),
                  ),
                ],
              ),
              Container(
                child: Divider(
                  color: primary,
                  // height: 36,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: _width * 15,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(_width * 7.5),
                ),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      print("All items put for donation");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FavoriteItemScreen(
                              cUser: widget.cUser,
                              listType: "Items For Donation"),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(child: Container(), flex: 1),
                        Text(
                          "Items added for donation ",
                          textScaleFactor: 1.5,
                          style: TextStyle(
                            color: black,
                          ),
                        ),
                        Flexible(child: Container(), flex: 2),
                        InkWell(
                          child: Icon(
                            FontAwesomeIcons.chevronDown,
                            color: black,
                          ),
                        ),
                        Flexible(child: Container(), flex: 1),
                      ],
                    ),
                  ),
                ),
              ),
              (itemsForDonationList.isEmpty || itemsForDonationList.isEmpty)
                  ? SizedBox(
                      width: _width * 100,
                      height: _width * 20,
                      child: Center(
                        child: Text(
                          "No Items put for donation",
                          style: TextStyle(
                            color: black,
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var item in itemsForDonationList) ...[
                            portraitItemCard(item, widget.cUser, context),
                          ]
                        ],
                      ),
                    ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: _width * 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_width * 7.5)),
                child: ElevatedButton(
                  onPressed: () => navigateToAddItem(),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return secondary;
                      }
                      return primary;
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_width * 7.5))),
                  ),
                  child: const Text(
                    "Add Item for Donation",
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: secondary,
                      fontWeight: FontWeight.bold,
                      // fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                child: Divider(
                  color: primary,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: _width * 15,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(_width * 7.5),
                ),
                child: Center(
                  child: Row(
                    children: [
                      Flexible(child: Container(), flex: 1),
                      Text(
                        "Items donated ",
                        textScaleFactor: 1.5,
                        style: TextStyle(
                          color: black,
                        ),
                      ),
                      Flexible(child: Container(), flex: 3),
                      InkWell(
                        onTap: () {
                          print("All items donated");
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FavoriteItemScreen(
                                  cUser: widget.cUser,
                                  listType: "Items Donated"),
                            ),
                          );
                        },
                        child: Icon(
                          FontAwesomeIcons.chevronDown,
                          color: black,
                        ),
                      ),
                      Flexible(child: Container(), flex: 1),
                    ],
                  ),
                ),
              ),
              (itemsDonatedList.isEmpty )
                  ? SizedBox(
                      width: _width * 100,
                      height: _width * 20,
                      child: Center(
                        child: Text(
                          "No Items donated ",
                          style: TextStyle(
                            color: black,
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var item in itemsDonatedList) ...[
                            portraitItemCard(item, widget.cUser, context),
                          ]
                        ],
                      ),
                    ),
              Container(
                child: Divider(
                  color: primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

changeImageDropDown() {
  print("Change Image");
}
