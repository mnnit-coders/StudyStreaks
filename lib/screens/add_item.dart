import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../widgets/show_snackbar.dart';
import '../widgets/text_field_ui.dart';
import 'home_page.dart';

class AddItem extends StatefulWidget {
  final User cUser;
  final ValueSetter setIndex;
  const AddItem({
    Key? key,
    required this.cUser,
    required this.setIndex,
  }) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  bool _isLoading = false;
  final TextEditingController _time_usedTextController =
      TextEditingController();
  final TextEditingController _descTextController = TextEditingController();

  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _typeTextController = TextEditingController();
  final ImagePicker imgPicker = ImagePicker();
  List<XFile> imageFiles = [];

  late GeoPoint location;
  TextEditingController _cityTextController = TextEditingController();
  TextEditingController _stateTextController = TextEditingController();
  TextEditingController _countryTextController = TextEditingController();
  TextEditingController _zipCodeTextController = TextEditingController();
  DateTime datePosted = DateTime.now();

  @override
  void initState() {
    super.initState();

    _cityTextController =
        TextEditingController(text: widget.cUser.address.city);
    _stateTextController =
        TextEditingController(text: widget.cUser.address.state);
    _countryTextController =
        TextEditingController(text: widget.cUser.address.country);
    _zipCodeTextController =
        TextEditingController(text: widget.cUser.address.zipCode.toString());
    location = widget.cUser.address.location;
  }

  @override
  dispose() {
    super.dispose();

    _time_usedTextController.dispose();
    _descTextController.dispose();
    _nameTextController.dispose();
    _typeTextController.dispose();
    _cityTextController.dispose();
    _stateTextController.dispose();
    _countryTextController.dispose();
    _zipCodeTextController.dispose();
  }

  addItem() async {
    setState(() {
      _isLoading = true;
    });
    if (imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        showCustomSnackBar(
          ctype: ContentType.help,
          message: "Please add item images and try again.",
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (_nameTextController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        showCustomSnackBar(
          ctype: ContentType.help,
          message: "Please add item name and try again.",
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_descTextController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        showCustomSnackBar(
          ctype: ContentType.help,
          message: "Please add item description and try again.",
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (_time_usedTextController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        showCustomSnackBar(
          ctype: ContentType.help,
          message: "plz enter time used and, Try again",
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    var res = await FireStoreMethods().uploadItem(
      time_used: double.parse(_time_usedTextController.text),
      desc: _descTextController.text,
      imgs: imageFiles,
      name: _nameTextController.text,
      type: _typeTextController.text,
      oldOwner: "${widget.cUser.firstName} ${widget.cUser.lastName}",
      oldOwnerUID: widget.cUser.uid,
      location: location,
      city: _cityTextController.text,
      state: _stateTextController.text,
      country: _countryTextController.text,
      zipCode: int.parse(_zipCodeTextController.text),
    );
    print(res);
    if (res == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        showCustomSnackBar(
          ctype: ContentType.success,
          message:"Item Added."
        ),
      );
      widget.setIndex(1);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        showCustomSnackBar(
          ctype: ContentType.failure,
          message: "Some error occurred, Try again + " + res,
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  responseImageSelection() async {
    String s = await openImages();
    if (s == "success") {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   showCustomSnackBar(
      //     ctype: ContentType.success,
      //     message: "So Cute!!!",
      //   ),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        showCustomSnackBar(
          ctype: ContentType.failure,
          message: "Some error occurred, Try again",
        ),
      );
    }
  }

  Future<String> openImages() async {
    try {
      var pickedFiles = await imgPicker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedFiles != null) {
        imageFiles = pickedFiles;
        setState(() {});
        return "success";
      } else {
        return "No image is selected.";
      }
    } catch (e) {
      return "error while picking file.";
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          "Add item",
          style: TextStyle(
            color: primary,
          ),
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.barsStaggered,
            color: primary,
          ),
          onPressed: () {
            zoomDrawerController.toggle!();
          },
        ),
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(
            _width * 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_width * 10),
              topRight: Radius.circular(_width * 10),
            ),
            color: secondary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.only(left: _width * 5),
                  child: Text(
                    "Enter details about item",
                    textScaleFactor: 1.2,
                    style: TextStyle(color: black),
                  ),
                ),
              ),
              if (imageFiles.isNotEmpty)
                Container(
                  padding: EdgeInsets.only(left: _width * 5),
                  child: Text(
                    "Item Photos:",
                    style: TextStyle(color: black),
                  ),
                ),
              Wrap(
                children: imageFiles.map((imageone) {
                  return Container(
                      child: Card(
                    child: Container(
                      height: _width * 27,
                      width: _width * 27,
                      child: Image.file(
                        File(imageone.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ));
                }).toList(),
              ),
              SizedBox(
                height: _width * 7,
              ),
              InkWell(
                onTap: () => responseImageSelection(),
                child: Container(
                  width: _width * 100,
                  height: _width * 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_width * 7.5),
                      color: white),
                  child: Center(
                    child: Text(
                      "Upload Item's photos",
                      textScaleFactor: 1.2,
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        // fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: _width * 7,
              ),
              Container(
                padding: EdgeInsets.only(left: _width * 5),
                child: Text(
                  "Item Name:",
                  style: TextStyle(color: black),
                ),
              ),
              textFieldUi('Eg: Harry Potter book', FontAwesomeIcons.paw, false,
                  _nameTextController, TextInputType.name),
              SizedBox(
                height: _width * 7,
              ),
              
              Container(
                padding: EdgeInsets.only(left: _width * 5),
                child: Text(
                  "Item Type:",
                  style: TextStyle(color: black),
                ),
              ),
              textFieldUi('Eg: book', FontAwesomeIcons.cat, false,
                  _typeTextController, TextInputType.name),
              SizedBox(
                height: _width * 7,
              ),
              Container(
                padding: EdgeInsets.only(left: _width * 5),
                child: Text(
                  "Description:",
                  style: TextStyle(color: black),
                ),
              ),
              textFieldUi('...', FontAwesomeIcons.pager, false,
                  _descTextController, TextInputType.name),
              SizedBox(
                height: _width * 7,
              ),
              Container(
                padding: EdgeInsets.only(left: _width * 5),
                child: Text(
                  "Time used:",
                  style: TextStyle(color: black),
                ),
              ),
              textFieldUi("Eg: '2.5' years", FontAwesomeIcons.arrowUpRightDots, false,
                  _time_usedTextController, TextInputType.number),
              SizedBox(
                height: _width * 7,
              ),
             
              SizedBox(
                height: _width * 7,
              ),
              Container(
                padding: EdgeInsets.only(left: _width * 5),
                child: Text(
                  "City:",
                  style: TextStyle(color: black),
                ),
              ),
              textFieldUi('City', FontAwesomeIcons.city, false,
                  _cityTextController, TextInputType.name),
              SizedBox(
                height: _width * 7,
              ),
              Container(
                padding: EdgeInsets.only(left: _width * 5),
                child: Text(
                  "State:",
                  style: TextStyle(color: black),
                ),
              ),
              textFieldUi('State', FontAwesomeIcons.locationDot, false,
                  _stateTextController, TextInputType.name),
              SizedBox(
                height: _width * 7,
              ),
              Container(
                padding: EdgeInsets.only(left: _width * 5),
                child: Text(
                  "Country:",
                  style: TextStyle(color: black),
                ),
              ),
              textFieldUi('Country', FontAwesomeIcons.globe, false,
                  _countryTextController, TextInputType.name),
              SizedBox(
                height: _width * 7,
              ),
              Container(
                padding: EdgeInsets.only(left: _width * 5),
                child: Text(
                  "Zip Code:",
                  style: TextStyle(color: black),
                ),
              ),
              textFieldUi('Zipcode', FontAwesomeIcons.mapLocationDot, false,
                  _zipCodeTextController, TextInputType.number),
              SizedBox(
                height: _width * 7,
              ),
              Container(
                width: _width * 100,
                height: _width * 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_width * 7.5)),
                child: ElevatedButton(
                  onPressed: () => addItem(),
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
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: white,
                          ),
                        )
                      : const Text(
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
            ],
          ),
        ),
      ),
    );
  }
}
