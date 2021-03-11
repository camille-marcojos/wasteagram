import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/image.dart';


class NewPostScreen extends StatefulWidget {
  static const String routeName = 'newPost';
  
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {

  final String title = 'New Post';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ImageInformation image = ModalRoute.of(context).settings.arguments;
    if(image.url == null){
      print('image url is null');
      return Center(child: CircularProgressIndicator());
    }
    else{
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(image.imageFile),
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Number of Wasted Items', 
                                hintStyle: TextStyle(fontSize: 20.0),
                                border: UnderlineInputBorder(),
                                ),
                              onSaved: (value) {
                                // Save value  to some object
                              },
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Please enter a number.';
                                }
                                return null;
                              }
                            ),
                          ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: (){
                            if(formKey.currentState.validate()){
                              formKey.currentState.save();
                              //Navigator.of(context).pop();
                            }
                          },
                          child: Text('Save Entry')
                        )
                      ],
                    ),
                  ),
                )
            ],)
          ]
          ),
        ),
      );
    }
  }
}

// Widget showImage(BuildContext context, File image){

//   if(image != null)
//     return Image.file(File(image.path));
//   else {
//     print('No image selected.');
//     return Center(child: CircularProgressIndicator());
//   }
// }
