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
  // **MOCK DATA**
  // List<Post> _posts = [
  //   Post(
  //     date: DateTime(1989, 11, 9), 
  //     imageURL: 'http//www.example1.com',
  //     quantity: 3,
  //     latitude: 34.15480876161727,
  //     longitude: -118.12227740472635
  //     ),
  //   Post(
  //     date: DateTime(1990, 1, 9), 
  //     imageURL: 'http//www.example2.com',
  //     quantity: 5,
  //     latitude: 50.15480876161727,
  //     longitude: -100.12227740472635
  //     ),
  //   Post(
  //     date: DateTime(1987, 06, 03), 
  //     imageURL: 'http//www.example3.com',
  //     quantity: 1,
  //     latitude: 65.15480876161727,
  //     longitude: -150.12227740472635
  //     ),
  // ];

 ImageInformation imageInfo = ImageInformation();

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    DateTime date = document['date'].toDate();
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              DateFormat('EEEE, MMMM d, yyyy').format(date), style: TextStyle(fontSize: 20)
              //DateFormat('EEEE, MMMM d, yyyy').format(document['date']), style: TextStyle(fontSize: 20)
            ),
          ),
          Container( 
            padding: const EdgeInsets.all(10.0),
            child: Text(document['quantity'].toString(), style: Theme.of(context).textTheme.headline6
            ),
          ),
        ],
      ),
      onTap: () {
        pushViewPostDetails(context, document);
      }
    );
  }

  bool isLoading;

  @override
  Widget build(BuildContext context) {
    if(isLoading == true)
      return Center(child: CircularProgressIndicator());
    else return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('post').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data.docs != null && snapshot.data.docs.length > 0){
            return ListView.builder(
            itemExtent: 80,
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
        onPressed: () async {
          // Go to select picture gallery
          final _picker = ImagePicker();
          PickedFile image = await _picker.getImage(source: ImageSource.gallery);

          // setState(() {
          //   isLoading = true; //add this line
          // });

          Reference storageReference = FirebaseStorage.instance.ref().child(DateTime.now().toString());
          await storageReference.putFile(File(image.path));

          final url = await storageReference.getDownloadURL();
          final _image = File(image.path);
          print(url);   

          imageInfo.url = url;
          imageInfo.imageFile = _image;
          
          setState(() {
            isLoading = false; //add this line
            Navigator.push(
              context, MaterialPageRoute(
                builder: (context) => NewPostScreen(),
                settings: RouteSettings(
                              arguments: imageInfo,
                            ),
              ));       
          });

          
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
  
  Navigator.push(
    context, MaterialPageRoute(
      builder: (context) => NewPostScreen(),
      settings: RouteSettings(
                    
                  ),
    ));
}

