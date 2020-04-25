import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blog/UI/Services/curd.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  bool _isLoading = false;
  String autherName, title, desc;

  CrudMethod crudMethod = CrudMethod();

  File _image;
  Future getImage() async {
    debugPrint("inside Get Method");
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  blogSpot() async {
    debugPrint("inside blogSpot Method");
    if (_image != null) {
      setState(() {
        debugPrint("loadding progress indicator start");
        _isLoading = true;
      }); 

      //Upload Image to Firebase Storage
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)},jpg");

      final StorageUploadTask task = firebaseStorageRef.putFile(_image);

      var downloadURL = await (await task.onComplete).ref.getDownloadURL();
      print("URL = $downloadURL");
      
      Map<String, String> blogMap = {
        "imageURl": downloadURL,
        "auther": autherName,
        "title": title,
        "desc": desc
      };
      crudMethod.addData(blogMap).then((result) {
        Navigator.pop(context);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _isLoading == true
                  ? null
                  : IconButton(
                      icon: Icon(Icons.file_upload),
                      onPressed: () {
                        print("Upload File Button Press");
                        blogSpot();
                      }),
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Flutter",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Blog",
                style: TextStyle(color: Colors.blue),
              ),
            ],
          )
        ),

      body: _isLoading == true
          ? Container(
              alignment: Alignment.center, child: CircularProgressIndicator()
          )
          : ListView(
              children: <Widget>[

                // Upload image White Box
                _image != null
                    ? Container(
                        margin: EdgeInsets.all(16.0),
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.file(
                            _image,
                            fit: BoxFit.cover,
                          ),
                        ))
                    : GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          margin: EdgeInsets.all(16.0),
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Icon(Icons.add_a_photo, color: Colors.black45),
                        ),
                      ),

                SizedBox(
                  height: 12.0,
                ),

                //Auther Name Text Form Field
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Auther Name"
                    ),
                    onChanged: (val) {
                      autherName = val;
                    },
                  ),
                ),

                //Blog Title Text Form Field
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Title"),
                    onChanged: (val) {
                      title = val;
                    },
                  ),
                ),

                //Blog Description Text Form Field
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Description"),
                    onChanged: (val) {
                      desc = val;
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
