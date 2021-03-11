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
  ImageInformation imageInfo = ImageInformation();

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
            appBar: AppBar(title: Text(title)),
            body: FutureBuilder(
              future: getImage(),
              builder: (context, AsyncSnapshot<ImageInformation> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  Image.file(snapshot.data.imageFile),
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
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('Save Entry')
                        )
                      ],
                    ),
                  ),
                )
            ],)
          ];
              } else if (snapshot.hasError) {
                children = <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ];
              } else {
                children = <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                )
              );
            }),
      );
  }
}

List<Widget> newPostForm = [
  
];