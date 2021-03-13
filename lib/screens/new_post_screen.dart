import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import '../models/image.dart';
import '../models/post.dart';


class NewPostScreen extends StatefulWidget {
  static const String routeName = 'newPost';
  
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {

  final String title = 'New Post';
  final formKey = GlobalKey<FormState>();
  ImageInformation imageInfo = ImageInformation();
  final post = Post();
  LocationData locationData;
  var locationService = Location();

  Future<ImageInformation> getImage() async {
    final _picker = ImagePicker();
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);

    Reference storageReference = FirebaseStorage.instance.ref().child(DateTime.now().toString());
    await storageReference.putFile(File(image.path));

    final url = await storageReference.getDownloadURL();
    final _image = File(image.path);
    print(url);   

    imageInfo.url = url;
    imageInfo.imageFile = _image;
    return imageInfo;

    
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
            appBar: AppBar(title: Text(title)),
            body: FutureBuilder(
              future: getImage(),
              builder: (context, AsyncSnapshot<ImageInformation> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(snapshot.data.url), fit: BoxFit.cover),
                    ),
                  ),
                  //Image.file(snapshot.data.imageFile),
                  SizedBox(height: 40),
                  Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child:
                                   TextFormField(
                                      style: TextStyle(fontSize: 25),
                                      autofocus: true,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: 'Number of Wasted Items', 
                                        hintStyle: TextStyle(fontSize: 20.0),
                                        border: UnderlineInputBorder(),
                                        ),
                                      onSaved: (value) async {
                                        // Save value  to some object
                                        post.quantity = int.parse(value);
                                        post.imageURL = snapshot.data.url;
                                        post.date = DateTime.now();
                                        locationData = await retrieveLocation(locationService, locationData, post);
                                        post.latitude = locationData.latitude;
                                        post.longitude = locationData.longitude;
                                        FirebaseFirestore.instance.collection('post').add(post.toJson());
                                        //print(post);
                                      },
                                      validator: (value){
                                        if(value.isEmpty){
                                          return 'Please enter a number.';
                                        }
                                        return null;
                                      }
                                    ),
                                ),
                          ],
                        ),
                      ),
                    ),],
                  ),
              ];
              } else if (snapshot.hasError) {
                children = <Widget>[].where((child) => child != null).toList(); 
                Future.microtask(() => Navigator.pop(context));
              } else {
                children = [CircularProgressIndicator(),];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                )
              );
            }),
            bottomSheet: InkWell(
                  onTap:(){
                      if(formKey.currentState.validate()){
                        formKey.currentState.save();
                        Navigator.of(context).pop();
                      }
                    },
                  child: Container(
                    padding: EdgeInsets.all(25),
                    color: Colors.blue,
                    child: Row(children: [Expanded(child: Icon(Icons.cloud_upload, size: 70))]),
            ),
          ),
      );
  }
}


  Future<LocationData> retrieveLocation(Location locationService, LocationData locationData, Post post) async {
      // In order to request location, you should always check manually Location Service status and Permission status
      try {
        var _serviceEnabled = await locationService.serviceEnabled();
        if(!_serviceEnabled) {
          _serviceEnabled = await locationService.requestService();
          if(!_serviceEnabled) {
            print('Failed to enabled service. Returning.');
            return null;
        }
        }

        var _permissionGranted = await locationService.hasPermission();
        if(_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await locationService.requestPermission();
          if(_permissionGranted != PermissionStatus.granted) {
            print('Location service permission not granted. Returning');
          }
        }

        locationData = await locationService.getLocation();
      } on PlatformException catch (e) {
        print('Error: ${e.toString()}, code: ${e.code}');
        locationData = null;
      }

      locationData = await locationService.getLocation();
      return locationData;

  }

