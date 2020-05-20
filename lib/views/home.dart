import 'package:blogapp/services/crud.dart';
import 'package:blogapp/views/create_blog.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  CrudMethod crudMethod = new CrudMethod();

  Stream blogStream;

  // ignore: non_constant_identifier_names
  Widget BlogList() {
    return Container(
      child: blogStream != null
          ? Column(
        children: <Widget>[
          StreamBuilder(
            stream: blogStream,
            builder: (context, snapshot) {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return BlogTile(
                      authorName: snapshot
                          .data.documents[index].data['authorName'],
                      title: snapshot.data.documents[index].data["title"],
                      description:
                      snapshot.data.documents[index].data['desc'],
                      imgUrl:
                      snapshot.data.documents[index].data['imgUrl'],
                    );
                  });
            },
          )
        ],
      )
          : Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState() {
    crudMethod.getData().then((result) {
      setState(() {
        blogStream = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Blog",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "App",
              style: TextStyle(fontSize: 22, color: Colors.blue),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: BlogList(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateBlog()));
              },
              child: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class BlogTile extends StatelessWidget {
  String imgUrl, title, description, authorName;
  BlogTile(
      {@required this.imgUrl,
        @required this.title,
        @required this.description,
        @required this.authorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 150,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 170,
            decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6)),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(authorName)
              ],
            ),
          )
        ],
      ),
    );
  }
}
