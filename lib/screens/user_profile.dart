import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/user.dart' as model;

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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
