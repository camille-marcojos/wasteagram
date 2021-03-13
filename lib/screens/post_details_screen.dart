import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetailsScreen extends StatelessWidget {
  static const routeName = 'postDetails';
  final String title = 'Wasteagram';
  final DocumentSnapshot postInfo;

  PostDetailsScreen({Key key, this.postInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = postInfo['date'].toDate();
    return Scaffold(
      appBar: AppBar( 
        title: Text(title)
      ),
      body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    postDate(context, date),
                    image(context),
                    quantityAvailable(context, postInfo),
                    location(context, postInfo),
                  ]
                ),
    );
  }


  Widget location(BuildContext context, DocumentSnapshot postInfo){
    return Text(
      'Location: ${postInfo['latitude'].toStringAsFixed(6)}, ${postInfo['longitude'].toStringAsFixed(6)}', style: TextStyle(fontSize: 12)
    );
  }

  Widget quantityAvailable(BuildContext context, DocumentSnapshot postInfo){
    return Text(
      '${postInfo['quantity']} items', style: Theme.of(context).textTheme.headline4
    );
  }

  Widget postDate(BuildContext context, DateTime date){
    return Text(
        DateFormat('EEEE, MMMM d, yyyy').format(date), style: Theme.of(context).textTheme.headline5
      );
  }

  Widget image(BuildContext context){
    return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(child: CircularProgressIndicator()),
            Center(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: postInfo['imageURL'],
              ),
            ),
          ],
        );
  }


}



