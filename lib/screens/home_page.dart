import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:sustainable_swap/screens/user_profile.dart';

import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../models/user.dart' as model;
import '../widgets/menu_screen.dart';
import 'add_item.dart';
import 'donated_item_screen.dart';
import 'favorite_items.dart';
import 'notification_page.dart';

int menuItemSelected = 1;
final ZoomDrawerController zoomDrawerController = ZoomDrawerController();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _menuItemSelected = 1;
  GeoPoint currLocation = GeoPoint(0, 0);
  bool _isLoading = true;
  late model.User cUser;
  // List<Item> itemList = [];
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
      cUser = await FireStoreMethods().getUserDetails();
      // print(cUser);
    } catch (e) {}
    setState(() {
      _isLoading = false;
    });
  }

  getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    setState(() async {
      currLocation = (await Geolocator.getCurrentPosition()) as GeoPoint;
    });
  }

  Widget currentScreen(model.User cUser) {
    if (menuItemSelected == 1) {
      return DonatedItemScreen(
        cUser: cUser,
      );
    } else if (menuItemSelected == 2) {
      return AddItem(
        cUser: cUser,
        setIndex: (index) {
          setState(() {
            menuItemSelected = index;
          });
        },
      );
    } else if (menuItemSelected == 3) {
      // return const FavoriteScreen();
      return FavoriteItemScreen(
        cUser: cUser,
        listType: 'Favorite Items',
      );
    } else if (menuItemSelected == 4) {
      return NotificationPage(
        cUser: cUser,
      );
    } else if (menuItemSelected == 5) {
      return UserProfile(
        cUser: cUser,
      );
    }
    return DonatedItemScreen(
      cUser: cUser,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: white,
            ),
          )
        : ZoomDrawer(
            // mainScreen: const Body(),
            mainScreen: currentScreen(cUser),
            menuScreen: MenuScreen(
              cUser: cUser,
              setIndex: (index) {
                setState(() {
                  menuItemSelected = index;
                });
              },
            ),

            controller: zoomDrawerController,
            borderRadius: 24,
            style: DrawerStyle.defaultStyle,
            showShadow: true,
            openCurve: Curves.fastOutSlowIn,
            closeCurve: Curves.fastOutSlowIn,
            slideWidth: MediaQuery.of(context).size.width * 0.65,
            duration: const Duration(milliseconds: 500),
            angle: 0.0,
            menuBackgroundColor: primary,
          );
  }
}
