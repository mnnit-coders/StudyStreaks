// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/address.dart';
import '../models/item.dart';
import '../models/user.dart' as model;
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../widgets/item_card.dart';
import 'home_page.dart';

class FavoriteItemScreen extends StatefulWidget {
  final model.User cUser;
  final String listType;
  const FavoriteItemScreen({
    Key? key,
    required this.cUser,
    required this.listType,
  }) : super(key: key);

  @override
  State<FavoriteItemScreen> createState() => _FavoriteItemScreenState();
}

class _FavoriteItemScreenState extends State<FavoriteItemScreen> {
  bool _isLoading = false;
  String category = "All";
  int _selectedCategory = 1;

  // Map itemListdb = {};
  List<Item> itemList = [];
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    setState(() {
      _isLoading = true;
    });
    print("trying");
    try {
      List<dynamic> itemIdList = (widget.listType == 'Favorite Items')
          ? widget.cUser.favItemList
          : (widget.listType == "Items For Donation")
              ? widget.cUser.itemsForDonation
              : widget.cUser.itemsDonated;

      String itemListType = (widget.listType == 'Favorite Items' ||
              widget.listType == "Items For Donation")
          ? "itemsForDonation"
          : "itemsDonated";
      itemList =
          await FireStoreMethods().getCustomItemList(itemListType, itemIdList); 
    } catch (e) {
      // showSnackBar(
      //   context,
      //   e.toString(),
      // );
    }
    print(itemList.length);
    setState(() {
      _isLoading = false;
    });
    // print(userData);
  }

  Widget filterOption(
    int index,
    String type,
    String img,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = index;
          category = type;
        });
      },
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          surfaceIntensity: .1,
          color: _selectedCategory == index ? primary : secondary,
          shadowLightColor: secondaryLight,
          shadowDarkColor: secondaryDark,
          depth: 18,
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(right: 10),
        child: Row(
          children: [
            Image.asset(
              img,
              width: 30,
              color: _selectedCategory == index ? white : black,
            ),
            const SizedBox(width: 10),
            Text(
              type,
              style: TextStyle(
                color: _selectedCategory == index ? white : black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showItemList() {
    int len = 0;

    for (var item in itemList) {
      if (category == 'All' ||
          category.toLowerCase() == ("${item.type}s").toLowerCase()) {
        len++;
      }
    }
    if (len == 0) {
      return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              "No item found",
              textScaleFactor: 1.5,
              style: TextStyle(
                color: black,
              ),
            ),
          ));
    } else {
      return Column(
        children: [
          for (var item in itemList) ...[
            if (category == 'All' ||
                category.toLowerCase() == ("${item.type}s").toLowerCase())
              landscapeItemCard(
                cUser: widget.cUser,
                context: context,
                listType: false,
                item: item,
              ),
          ]
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(itemList);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          widget.listType,
          // (widget.listType == "favItemList")
          //     ? "Favorite Items"
          //     : (widget.listType == "itemsforDonation")
          //         ? "Items For Donation"
          //         : "Items Donated",
          style: TextStyle(
            color: primary,
          ),
          textAlign: TextAlign.center,
        ),
        // elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            (widget.listType == "Favorite Items")
                ? FontAwesomeIcons.barsStaggered
                : FontAwesomeIcons.arrowLeft,
            color: primary,
          ),
          onPressed: () {
            (widget.listType == "Favorite Items")
                ? zoomDrawerController.toggle!()
                : Navigator.pop(context);
          },
        ),
        // shadowColor: secondaryLight,
        shadowColor: Colors.transparent,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primary,
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: secondary,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              filterOption(
                                  1, 'All', 'assets/images/donate.png'),
                              filterOption(2, 'Books', 'assets/images/book.png'),
                              filterOption(3, 'Clothes', 'assets/images/clothes.png'),
                              filterOption(
                                  4, 'Devices', 'assets/images/devices.png'),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),c
                    showItemList(),
                  ],
                ),
              ),
            ),
    );
  }
}
