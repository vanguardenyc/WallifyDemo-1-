import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallify_demo/wallpaper/fullscreen_image.dart';

class WallScreen extends StatefulWidget {
  @override
  _WallScreenState createState() => _WallScreenState();
}

//Firebase linking started
class _WallScreenState extends State<WallScreen> {
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpapersList;
  final CollectionReference collectionReference =
      Firestore.instance.collection("wallpapers");

@override
  void initState() {
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot){
     setState(() { 
       wallpapersList = datasnapshot.documents;
     });
    });
  }
  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
//Firebase linking ended

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Wallify"),),
      body: wallpapersList !=null?
      new StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: 4,
        itemCount: wallpapersList.length,
        itemBuilder: (context, i){
          String imgPath = wallpapersList[i].data['url'];
          return new Material(
            elevation: 8.0,
            borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
            child: new InkWell(
              onTap: () => Navigator.push(context, new MaterialPageRoute(
                builder: (context) => new FullScreenImagePage(imgPath)
              )),
            ),
          );
        }, staggeredTileBuilder: (i) => new StaggeredTile.count(2,i.isEven ? 2:3),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ): new Center(child: new CircularProgressIndicator(),)
    );
  }
}
