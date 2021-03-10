import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetailsScreen extends StatelessWidget {
  static const routeName = 'postDetails';
  final String title = 'Wasteagram';

  DocumentSnapshot postInfo;

  PostDetailsScreen({Key key, this.postInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = postInfo['date'].toDate();

    return Scaffold(
      appBar: AppBar( 
        title: Text(title)
      ),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Text(
              DateFormat('EEEE, MMMM d, yyyy').format(date), style: Theme.of(context).textTheme.headline6
              //DateFormat('EEEE, MMMM d, yyyy').format(postInfo['date']), style: Theme.of(context).textTheme.headline6
            ),
            Text(
              '${postInfo['imageURL']}', style: Theme.of(context).textTheme.headline6
            ),
            Text(
              '${postInfo['quantity']}', style: Theme.of(context).textTheme.headline6
            ),
            Text(
              '${postInfo['latitude'].toStringAsFixed(6)}, ${postInfo['longitude'].toStringAsFixed(6)}', style: TextStyle(fontSize: 12)
            ),
          ]
        ),
      )
    );
  }
}