import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/address.dart';
import '../models/item.dart';
import '../models/user.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../widgets/item_card.dart';
import '../widgets/show_snackbar.dart';

import 'home_page.dart';

class DonatedItemScreen extends StatefulWidget {
  final User cUser;
  const DonatedItemScreen({
    Key? key,
    required this.cUser,
  }) : super(key: key);

  @override
  State<DonatedItemScreen> createState() => _DonatedItemScreenState();
}

class _DonatedItemScreenState extends State<DonatedItemScreen> {
  bool _isLoading = false;
  List<Item> itemList = [];
  String category = "All";
  late GeoPoint currLocation;
  int _selectedCategory = 1;


  Widget filterOption(
    int index,
    String type,
    String img,
    _width,
    _height,
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
              width: _width * 9,
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

  Widget showItemList(_width, _height) {
    int len = 0;

    for (var item in itemList) {
      if (category == 'All' ||
          category.toLowerCase() == (item.type + "s").toLowerCase()) {
        len++;
      }
    }
    if (len == 0) {
      return Container(
          height: _height * 75,
          width: _width * 100,
          child: Center(
            child: Text(
              "No item found for donation",
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
                category.toLowerCase() == (item.type + "s").toLowerCase())
              landscapeItemCard(
                cUser: widget.cUser,
                context: context,
                listType: true,
                item: item,
              ),
          ]
        ],
      );
    }
  }


  showError(e) {
    ScaffoldMessenger.of(context).showSnackBar(
      showCustomSnackBar(
        ctype: ContentType.failure,
        message: e.toString(),
      ),
    );
  }

  getLocation() async {
    setState(() {
      _isLoading = true;
    });
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permissions are permanently denied, we cannot request permanently denied permissions.");
    }
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      launchLocationSettings();
      // Location services are enabled, proceed with your logic
      print('Location services were disabled');
    }

    Position position = await Geolocator.getCurrentPosition();
    // timeLimit: const Duration(seconds: 5));
    print(position);
    currLocation = GeoPoint(position.latitude, position.longitude);
    sortItemsOnDistance();
    print("hogaya");
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> launchLocationSettings() async {
    // Launch the device's settings screen where the user can enable location services
    final Uri settingsUri = Uri.parse('app-settings:');
    if (await canLaunchUrl(settingsUri)) {
      await launchUrl(settingsUri);
    } else {
      print('Could not open location settings');
    }
  }

  findDistance(double startLatitude, double startLongitude, double endLatitude,
      double endLongitude) {
    double dis = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    return dis;
  }

  sortItemsOnDistance() {
    setState(() {
      _isLoading = true;
    });
    for (var item in itemList) {
      item.distance = findDistance(currLocation.latitude, currLocation.longitude,
          item.address.location.latitude, item.address.location.longitude);
      item.distance = findDistance(currLocation.latitude, currLocation.longitude,
          item.address.location.latitude, item.address.location.longitude);
    }
    itemList.sort((p1, p2) => p1.distance.compareTo(p2.distance));
    setState(() {
      _isLoading = false;
    });
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      itemList = await FireStoreMethods().getItemList(widget.cUser.uid);
      print("${itemList.length} Fox");
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   showCustomSnackBar(
      //     ctype: ContentType.failure,
      //     message: e.toString(),
      //   ),
      // );
    }
    setState(() {
      _isLoading = false;
    });
    // print(userData);
  }

  @override
  void initState() {
    super.initState();
    getData();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width / 100;
    var _height = MediaQuery.of(context).size.height / 100;
    // print(itemList);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          "Donated Items",
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: white,
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), //~~
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
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          Row(
                            children: [
                              filterOption(
                                  1,
                                  'All',
                                  'assets/images/donate.png',
                                  _width,
                                  _height),
                              filterOption(2, 'Books', 'assets/images/book.png',
                                  _width, _height),
                              filterOption(3, 'Clothes', 'assets/images/clothes.png',
                                  _width, _height),
                              filterOption(4, 'devices', 'assets/images/devices.png',
                                  _width, _height),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),c
                    showItemList(_width, _height),
                  ],
                ),
              ),
            ),
    );
  }
}
