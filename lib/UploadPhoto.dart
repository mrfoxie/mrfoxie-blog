import 'package:blogger/HomePage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
class UploadPhotoPage extends StatefulWidget {
  UploadPhotoPage({Key key}) : super(key: key);

  @override
  UploadPhotoPageState createState() => UploadPhotoPageState();
}

class UploadPhotoPageState extends State<UploadPhotoPage> {
  File sampleImage;
  String _myValue;
  String url;
  final formKey = new GlobalKey<FormState>();
  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }
  bool validateAndSave(){
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
  void uploadStatusImage() async{
    if (validateAndSave()) {
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Image");
      var timeKey = new DateTime.now();
      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);
      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = ImageUrl.toString();
      print("Image Url: " + url);
      goToHomePage();
      savetoDatabase(url);
    } else {
    }
  }
  void savetoDatabase(url){
    var dbTimeKey = new DateTime.now();
    var formateDate = new DateFormat("MMM dd, yyyy");
    var formateTime = new DateFormat("E, h:mm");
    String date = formateDate.format(dbTimeKey);
    String time = formateTime.format(dbTimeKey);
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var data = {
      "image": url,
      "description": _myValue,
      "date": date,
      "time": time,
    };
    ref.child("Posts").push().set(data);
  }
  void goToHomePage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context){
        return HomePage();
      }),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 50.0),
        decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage("images/back.png"),fit: BoxFit.fill),),
        child: new Center(
          child: sampleImage == null ? Text("Select a image from gallary", style: TextStyle(color: Color(0xffeeeeee)),): enableUpload(),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'An Image',
        child: new Icon(Icons.add, color: Colors.white70,),
        backgroundColor: Color(0xff833ac7),
      ),
    );
  }
  Widget enableUpload(){
    FocusNode myFocusNode = new FocusNode();
    return new Container(
      child: new Form(
        key: formKey,
      child: Column(
        children: <Widget>[
          Image.file(sampleImage, width: 660, height: 330,),
          SizedBox(height: 20.0,),
          TextFormField(
            style: TextStyle(color: Color(0xffeeeeee)),
            decoration: new InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
              Icons.description,
                color: Color(0xffeeeeee),
              ),
              labelText: 'Title',
              labelStyle: TextStyle(
              color:
                  myFocusNode.hasFocus ? Color(0xffeeeeee) : Color(0xffeeeeee)),
          fillColor: Color.fromARGB(255, 255, 100, 0),
            ),
            maxLines: 1,
            validator: (value){
              return value.isEmpty ? 'Description is been required' : null;
            },
            onSaved: (value){
              return _myValue = value;
            },
          ),
          SizedBox(height: 10.0,),
          FlatButton(
          onPressed: uploadStatusImage,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff833ac7), Color(0xff5e3fd8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                "Add New Post.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        ],
      ),
      ),
    ); 
  }
}