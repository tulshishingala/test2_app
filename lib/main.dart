import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test2_app/DetailPage.dart';
import 'package:test2_app/api_page.dart';
import 'package:test2_app/model.dart';


void main() {
  runApp(const MyApp());
}

String baseUrl = 'https://628dd36fa339dfef87a10005.mockapi.io';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User> users = [];
  User? user;
  bool _isLoading = false;
  bool _isDeleting = false;
  String name = '';
  String imgUrl = '';

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => showAlert(), child: const Icon(Icons.add)),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) => ListTile(
                      onLongPress: () {
                        showUpdateAlert(
                          name: users[index].name,
                          url: users[index].url,
                          id: users[index].id,
                        );
                      },
                      onTap: () {
                        //inavigate with id
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DetailPage(id: users[index].id)));
                      },
                      leading: Image.network(
                        '${users[index].url}',
                        height: 100,
                        width: 100,
                        errorBuilder: (context, builder, st) =>
                            const Icon(Icons.hide_image_outlined),
                      ),
                      trailing: IconButton(
                          onPressed: _isDeleting
                              ? null
                              : () {
                                  deleteEntry(users[index].id);
                                },
                          icon: Icon(
                            Icons.delete,
                            color: _isDeleting ? Colors.grey : Colors.red,
                          )),
                      title: Text('${users[index].name}'),
                      subtitle: Text('${users[index].createdAt}'),
                    )));
  }

  void getUsers() async {
    setState(() => _isLoading = true);
    users.clear();
    http.Response res = await http.get(Uri.parse('$baseUrl/users'));

    if (res.statusCode == 200) {
      var decoded = jsonDecode(res.body);
      decoded.forEach((v) {
        setState(() {
          users.add(User(
            id: v['id'],
            name: v['name'],
            url: v['avatar'],
            createdAt: v['createdAt'],
          ));
        });
      });
      setState(() => _isLoading = false);
    }
  }

  showAlert() async {
    var res = await showDialog(
        context: context, builder: (context) => const AddUpdateScreen());
    if (res != null && res == true) {
      getUsers();
    }
  }

  showUpdateAlert({name, url, id}) async {
    var res = await showDialog(
        context: context,
        builder: (context) => AddUpdateScreen(
              name: name,
              url: url,
              id: id,
            ));
    if (res != null && res == true) {
      getUsers();
    }
  }

  void deleteEntry(String? id) async {
    setState(() => _isDeleting = true);
    http.Response res = await http.delete(Uri.parse('$baseUrl/users/$id'));

    if (res.statusCode == 200) {
      getUsers();
      setState(() => _isDeleting = false);
    }
  }
}