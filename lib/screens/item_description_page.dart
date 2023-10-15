// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/item.dart';
import '../models/user.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../widgets/show_snackbar.dart';

class ItemDescription extends StatefulWidget {
  Item citem;
  User cuser;

  ItemDescription({
    Key? key,
    required this.citem,
    required this.cuser,
  }) : super(key: key);
  @override
  State<ItemDescription> createState() => _ItemDescriptionState();
}

class _ItemDescriptionState extends State<ItemDescription> {
  int _current = 0;
  bool isFavItem = false;
  final CarouselController _controller = CarouselController();
  bool isLoadingFav = false;
  bool isLoadingDonat = false;

  @override
  void initState() {
    super.initState();
    isFavItem = (widget.cuser.favItemList.contains(widget.citem.itemId));
  }

  confirmDialog(width) {
    print("Kuchbhi");
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(width * 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirm Donation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: width * 5,
              ),
            ),
            SizedBox(height: width * 3),
            Text(
              'Are you sure you want to send adoption request?',
              style: TextStyle(fontSize: width * 4),
            ),
            SizedBox(height: width * 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    // Perform action when Cancel is tapped
                    Navigator.of(context).pop(false);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 4,
                      vertical: width * 2,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: width * 4,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 2),
                InkWell(
                  onTap: () {
                    // Perform action when Confirm is tapped

                    sendRequest();

                    Navigator.of(context).pop(true);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 4,
                      vertical: width * 2,
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: width * 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  sendRequest() async {
    setState(() {
      isLoadingDonat = true;
    });
    try {
      String res = await FireStoreMethods()
          .sendDonationRequest(widget.citem, widget.cuser);
      if (res == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
            message:
                "Donation request sent successfully, wait till the owner responds. Meanwhile, you can also contact the owner for better understanding.",
            ctype: ContentType.success));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            showCustomSnackBar(message: res, ctype: ContentType.failure));
      }
    } catch (e) {}
    setState(() {
      isLoadingDonat = false;
    });
  }

  changeFavList() async {
    setState(() {
      isLoadingFav = true;
    });
    try {
      String res = await FireStoreMethods()
          .changeFavList(widget.cuser, widget.citem.itemId, isFavItem);
      if (res == 'success') {
        isFavItem ^= true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            showCustomSnackBar(message: res, ctype: ContentType.failure));
      }
    } catch (e) {}
    setState(() {
      isLoadingFav = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width / 100;
    var _height = MediaQuery.of(context).size.height / 100;
    // print(widget.citem.desc);
    return Scaffold(
      backgroundColor: secondary,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                          height: _width * 110,
                          // aspectRatio: 1,
                          enableInfiniteScroll: false,
                          enlargeCenterPage: true,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          }
                          // width: MediaQuery.of(context).size.width,
                          ),
                      items: widget.citem.imgs
                          .map((item) => Container(
                                child: Center(
                                    child: Image.network(
                                  item,
                                  fit: BoxFit.cover,
                                  height: _width * 110,
                                  width: _width * 100,
                                )),
                              ))
                          .toList(),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 20,
                      child: Row(
                        children:
                            widget.citem.imgs.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(entry.key),
                            child: Container(
                              width: 12.0,
                              height: 12.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: white.withOpacity(
                                      _current == entry.key ? 1 : 0.5)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                // Flexible(flex: 1, child: Container()),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Neumorphic(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 20),
                    margin: const EdgeInsets.only(top: 20),
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
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: black,
                                    size: 20,
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.citem.address.city,
                                      style: TextStyle(
                                        color: black,
                                      ),
                                    ),
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
                // Flexible(flex: 1, child: Container()),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Row(
                      children: [
                        //image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.07),
                          child: //Image.network(
                              // 'assets/images/owl.jpg',
                              // height: 50,
                              // width: 50,
                              // fit: BoxFit.cover,
                              // ),
                              Image.asset(
                            'assets/images/owl.jpg',
                            height: _width * 14,
                            width: _width * 14,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.citem.oldOwner,
                              textScaleFactor: 1.4,
                              style: TextStyle(
                                color: black.withOpacity(0.5),
                              ),
                            ),
                            Text(
                              "Owner",
                              style: TextStyle(
                                color: black.withOpacity(0.5),
                              ),
                            )
                          ],
                        ),
                        //column

                        Flexible(child: Container(), flex: 1),
                        Text(
                          "${widget.citem.datePosted.day} ${widget.citem.datePosted.month} ${widget.citem.datePosted.year}",
                          textScaleFactor: 1.2,
                          style: TextStyle(
                            color: black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Text(
                      widget.citem.desc,
                      textScaleFactor: 1.2,
                      style: TextStyle(
                        color: black.withOpacity(0.5),
                      ),
                    )
                  ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_width * 8),
                      topRight: Radius.circular(_width * 8),
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            changeFavList();
                          },
                          child: (isLoadingFav)
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: white,
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(10),
                                  width: _width * 20,
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(18)),
                                  child: Icon(
                                    isFavItem
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
                                    color: white,
                                  ),
                                ),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => confirmDialog(_width)
                                // )
                                );
                          },
                          child: (isLoadingDonat)
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: white,
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(10),
                                  width: _width * 65,
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(18)),
                                  child: const Center(
                                      child: Text(
                                    "Donat",
                                    textScaleFactor: 1.3,
                                    style: TextStyle(color: white),
                                  )),
                                ),
                        )
                      ]),
                ),
              ],
            ),
            Positioned(
                top: 15,
                left: 10,
                child: FloatingActionButton(
                  elevation: 0,
                  // backgroundColor: black.withOpacity(0.2),
                  backgroundColor: Colors.transparent,
                  child: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  // shape: ShapeBorder.,
                ))
          ],
        ),
      ),
    );
  }
}
