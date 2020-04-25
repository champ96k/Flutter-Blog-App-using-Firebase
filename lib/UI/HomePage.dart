import 'package:flutter/material.dart';
import 'package:flutter_blog/UI/CreatePost.dart';
import 'package:flutter_blog/UI/Services/curd.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Create Object of CrudMethod
  CrudMethod crudMethod = CrudMethod();

  Stream blogStream;

  @override
  void initState() {
    debugPrint("Inside Init Method");
    super.initState();
    crudMethod.getData().then((result) {
      blogStream = result;
      debugPrint("getData Method call");
    });
  }

  Widget blogList() {
    return Container(
      child: blogStream != null  
          ? Column(
              children: <Widget>[
                StreamBuilder(
                  stream: blogStream,
                  builder: (context, snapshot) {
                    return Container(
                      //This Container Takes whole Screen 
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                       height: MediaQuery.of(context).size.height-100, 
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return BlogTile(
                            // BlogTile take only the box contain image, title, Auther. and Description
                            imgUrl: snapshot.data.documents[index].data['imageURl'],
                            autherName: snapshot.data.documents[index].data['auther'],
                            title: snapshot.data.documents[index].data['title'],
                            desc: snapshot.data.documents[index].data['desc'],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
           )
           //When the data is Not available 
          : Container(
              alignment: Alignment.center,
              child: Text("Loading"),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          )),
      body: blogList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePost()));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class BlogTile extends StatelessWidget {
  final imgUrl, autherName, title, desc;

  // Named Constructor
  BlogTile({@required this.imgUrl,@required this.autherName,@required this.title, @required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      height: 150,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            child: CachedNetworkImage(
              imageUrl : imgUrl,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.black45.withOpacity(0.3)),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(title,
                textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  autherName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                ),
                Text(desc,
                textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
