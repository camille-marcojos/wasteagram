import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:wasteagram/screens/post_details_screen.dart';
import 'models/post.dart';
import 'screens/list_screen.dart';
import 'screens/new_post_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  static final routes = {
    ListScreen.routeName: (context) => ListScreen(),
    PostDetailsScreen.routeName: (context) => PostDetailsScreen(),
    NewPostScreen.routeName: (context) => NewPostScreen()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      routes: routes
    );
  }
}


