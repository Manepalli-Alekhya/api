import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:PostViewer(),
    );
  }
}

//String Response;




class Post {
  String title;
  String id;
  String desc;
  Post({required this.id, required this.title, required this.desc});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
      id: json['id'],
      desc: json['desc'],
    );
  }
}
class PostViewer extends StatefulWidget {
  const PostViewer({super.key});

  @override
  State<PostViewer> createState() => _PostViewerState();
}

class _PostViewerState extends State<PostViewer> {
  List<dynamic> decode(Response res) {
    List<dynamic> posts = jsonDecode(res.body);
    print(posts);
    return posts;
  }

  Future<Response> getData() async {
    Response res =
    await get(Uri.parse("https://632583f24cd1a2834c3f5cc3.mockapi.io/api/forms/data"));
    if (res.statusCode == 200) {
      decode(res);
      return res;
    } else {
      print("Not able to get data");
      return res;
    }
  }



  Future<List<Post>> getPosts() async {
    Response res = await getData();
    return convertMapToObject(decode(res));
  }

  List<Post> convertMapToObject(List<dynamic> posts) {
    List<Post>? postsObj =
    posts.map((dynamic item) => Post.fromJson(item)).toList();
    return postsObj;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getPosts(),
        builder: (context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.hasError) {
            return Text("Failed to get data");
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].title),
                  subtitle: Text(snapshot.data![index].desc),
                  leading: Text((snapshot.data![index].id).toString()),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}




