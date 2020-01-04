import 'package:blogger/Post.dart';
import 'package:blogger/UploadPhoto.dart';
import 'package:flutter/material.dart';
import 'package:blogger/Authentication.dart';
import 'package:firebase_database/firebase_database.dart';
class HomePage extends StatefulWidget {
  HomePage({
    this.auth,
    this.onSignedOut,
  });
  final AuthImplementaion auth;
  final VoidCallback onSignedOut;
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}
class _HomePageState extends  State<HomePage>{
  List<Posts> postsList = [];
  @override
  void initState() {
    super.initState();
    DatabaseReference postRef = FirebaseDatabase.instance.reference().child("Posts");
    postRef.once().then((DataSnapshot snap){
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      postsList.clear();
      for(var individualKey in KEYS){
        Posts posts = new Posts(
          DATA[individualKey]["image"],
          DATA[individualKey]["description"],
          DATA[individualKey]["date"],
          DATA[individualKey]["time"],
        );
        postsList.add(posts);
      }
      setState(() {
        print('Length: $postsList.length');
      });
    });
  }
  void _logoutUser() async{
    try{
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xff21254a),
      body: new Container(
       decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage("images/back.png"),fit: BoxFit.fill),),
          child: postsList.length == 0 ? null : new ListView.builder(
          itemCount: postsList.length,
          itemBuilder: (_, index){
            return postsUI(postsList[index].image, postsList[index].description, postsList[index].date, postsList[index].time);
          },
        ),
        ),
      bottomNavigationBar: new BottomAppBar(
        color: Color(0xff21254a),
        child: new Container(
          margin: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new IconButton(
                icon: new Icon(Icons.add_photo_alternate),
                color: Color(0xff833ac7),
                iconSize: 30.0,
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context){
                      return new UploadPhotoPage();
                    })
                  );
                },
              ),
              new IconButton(
                icon: new Icon(Icons.exit_to_app),
                color: Color(0xff833ac7),
                iconSize: 30.0,
                onPressed: _logoutUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget postsUI(String image, String description, String date, String time){
    return new Card(
      elevation: 10.0,
      color: Color(0xff21254a),
      margin: EdgeInsets.all(20.0),
      child: new Container(
        padding: new EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Color(0xff21254a)
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Image.network(
                  image, fit: BoxFit.cover,
                ),
                SizedBox(height: 20.0,),
                new Text(
                  description,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.0,),
                new Text(
                  date,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,                  
                ),
                new Text(
                  time,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 2.0,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
