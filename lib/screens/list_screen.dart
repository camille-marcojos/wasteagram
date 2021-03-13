import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wasteagram/screens/post_details_screen.dart';
import '../models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'new_post_screen.dart';
import '../models/image.dart';


class ListScreen extends StatefulWidget {

  final String title = 'Wasteagram';
  static const routeName = '/';

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    DateTime date = document['date'].toDate();
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              DateFormat('EEEE, MMMM d, yyyy').format(date), style: TextStyle(fontSize: 20)
            ),
          ),
          Container( 
            padding: const EdgeInsets.all(10.0),
            child: Text(document['quantity'].toString(), style: Theme.of(context).textTheme.headline5
            ),
          ),
        ],
      ),
      onTap: () {
        pushViewPostDetails(context, document);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
        .collection('post')
        .orderBy('date', descending: true)
        .snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data.docs != null && snapshot.data.docs.length > 0){
            return ListView.builder(
            itemExtent: 60,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) =>
              _buildListItem(context, snapshot.data.docs[index])
            );
          } else{
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Go to select picture gallery
          pushNewPost(context);   
        },
        tooltip: 'Add New Post',
        child: Icon(Icons.camera_alt),
      ), 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

void pushViewPostDetails(BuildContext context, DocumentSnapshot postInfo) {
  Navigator.push(
    context, MaterialPageRoute(
      builder: (context) => PostDetailsScreen(postInfo: postInfo)
    ));
}

void pushNewPost(BuildContext context) {
  
  Navigator.of(context).pushNamed(NewPostScreen.routeName);
}

