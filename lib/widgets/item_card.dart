import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../models/item.dart';
import '../models/user.dart' as model;
import '../screens/item_description_page.dart';
import '../utils/colors.dart';

Widget landscapeItemCard(
    {required Item item,
    required model.User cUser,
    required BuildContext context,
    required bool listType}) {
  //listType= true when all items are shown and =false when custom
  return InkWell(
    onTap: () {
      // print(FirebaseAuth.instance.currentUser);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ItemDescription(
                citem: item,
                cuser: cUser,
              )));
    },
    child: Container(
      height: 150,
      padding: const EdgeInsets.only(),
      margin: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          Neumorphic(
            padding: const EdgeInsets.only(right: 10),
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            // decoration: BoxDecoration(
            //   color: secondary,
            //   borderRadius: BorderRadius.circular(20),
            // ),

            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              surfaceIntensity: .1,
              color: secondary,
              // color: pink,
              shadowLightColor: secondaryLight,
              shadowDarkColor: secondaryDark,
              depth: 18,
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 170,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            item.name,
                            textScaleFactor: 1.5,
                            style: TextStyle(
                              color: black,
                            ),
                          ),
                          
                        ],
                      ),
                      
                      Text(
                        item.time_used.toString() + " years used",
                        textScaleFactor: 0.8,
                        style: TextStyle(color: black),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: black,
                            size: 20,
                          ),
                          Text(
                            (listType == true)
                                ? (item.distance / 1000).round().toString() +
                                    " km"
                                : item.address.city,
                            style: TextStyle(color: black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            top: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                item.imgs[0],
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget portraitItemCard(Item item, model.User cUser, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ItemDescription(
                citem: item,
                cuser: cUser,
              )));
    },
    child: Container(
      height: MediaQuery.of(context).size.width * 0.8,
      width: MediaQuery.of(context).size.width * 0.4,
      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.04),
      // margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.01),
      child: Neumorphic(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        margin: const EdgeInsets.only(top: 20, bottom: 20),
        // decoration: BoxDecoration(
        //   color: secondary,
        //   borderRadius: BorderRadius.circular(20),
        // ),

        style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          surfaceIntensity: .1,
          color: secondary,
          // color: pink,
          shadowLightColor: secondaryLight,
          shadowDarkColor: secondaryDark,
          depth: 18,
        ),
        child: Column(
          children: [
            Container(
              // left: 10,
              // top: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.025),
                child: Image.network(
                  item.imgs[0],
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        item.name,
                        textScaleFactor: 1.5,
                        style: TextStyle(
                          color: black,
                        ),
                      ),
                     
                    ],
                  ),
                  
                  Text(
                    item.time_used.toString() + " years old",
                    textScaleFactor: 0.8,
                    style: TextStyle(color: black),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: black,
                        size: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Text(
                        item.address.city,
                        style: TextStyle(color: black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
