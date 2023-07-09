import 'dart:convert';

import 'package:aplikasi/detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _posts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Http')),
      body: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Container(
                color: Colors.amber,
                height: 100,
                width: 100,
                child: _posts[index]['urlToImage'] != null
                    ? Image.network(
                        _posts[index]['urlToImage'],
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : const Center(),
              ),
              title: Text('${_posts[index]['title']}',
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                '${_posts[index]['description']}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => Detail(
                              url: _posts[index]['url'],
                              title: _posts[index]['title'],
                              content: _posts[index]['content'],
                              publishedAt: _posts[index]['publishedAt'],
                              author: _posts[index]['author'],
                              urlToImage: _posts[index]['urlToImage'],
                              articelData: _posts[index],
                            ))
                    // MaterialPageRoute(builder: (c) => const Detail(articelData: _posts[index][''])),
                    );
              },
            );
          }),
    );
  }

  Future _getData() async {
    try {
      const baseUrl =
          'https://newsapi.org/v2/everything?q=tesla&from=2023-06-09&sortBy=publishedAt&apiKey=8630b7cbc7ce47dda57052ae1623fe22';
      final response = await http.get(Uri.parse(baseUrl));
      // final response = await http.get(
      //     'https://newsapi.org/v2/everything?q=tesla&from=2023-06-09&sortBy=publishedAt&apiKey=8630b7cbc7ce47dda57052ae1623fe22');
      if (response.statusCode == 200) {
        // print(response.body);
        final data = jsonDecode(response.body);
        setState(() {
          _posts = data['articles'];
        });
        print(_posts);
      }
    } catch (e) {
      print(e);
    }
  }
}
