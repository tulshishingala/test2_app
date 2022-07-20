import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test2_app/model.dart';
import 'main.dart';


class DetailPage extends StatefulWidget {
  final String? id;
  const DetailPage({Key? key, this.id}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  User? user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Text("${user?.name}")]),
    );
  }

  void getUser() async {
    http.Response res =
        await http.get(Uri.parse('$baseUrl/users/${widget.id}'));

    print(widget.id);
    print(res.statusCode);
    if (res.statusCode == 200) {
      var decoded = jsonDecode(res.body);
      setState(() {
        user = User(
          name: decoded['name'],
          url: decoded['avatar'],
          createdAt: decoded['createdAt'],
        );
      });
    }
  }
}
