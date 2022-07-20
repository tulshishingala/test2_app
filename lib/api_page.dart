
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class AddUpdateScreen extends StatefulWidget {
  final String? name;
  final String? url;
  final String? id;
  const AddUpdateScreen({Key? key, this.name, this.url, this.id})
      : super(key: key);
  @override
  State<AddUpdateScreen> createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  String? name = '';
  String? url = '';
  bool _isLoading = false;
  @override
  void initState() {
    if (widget.name != null && widget.url != null) {
      setState(() {
        name = widget.name;
        url = widget.url;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: name,
            decoration: const InputDecoration(hintText: 'Name'),
            onChanged: (n) => name = n,
          ),
          TextFormField(
            initialValue: url,
            decoration: const InputDecoration(hintText: 'Url'),
            onChanged: (u) => url = u,
          ),
          TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (widget.name != null && widget.url != null) {
                        updateUser();
                      } else {
                        addUser();
                      }
                    },
              child: const Text("Submit"))
        ],
      ),
    );
  }

  void addUser() async {
    if (name!.isNotEmpty && url!.isNotEmpty) {
      setState(() => _isLoading = true);
      http.Response res = await http.post(
        Uri.parse('$baseUrl/users'),
        body: {
          "name": "$name",
          "avatar": "$url",
        },
      );

      if (res.statusCode == 201) {
        Navigator.pop(context, true);
        // https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/559.jpg
        setState(() => _isLoading = false);
      }
    }
  }

  void updateUser() async {
    if (name!.isNotEmpty && url!.isNotEmpty) {
      setState(() => _isLoading = true);
      http.Response res = await http.put(
        Uri.parse('$baseUrl/users/${widget.id}'),
        body: {
          "name": "$name",
          "avatar": "$url",
        },
      );
      print(res.statusCode);
      if (res.statusCode == 200) {
        Navigator.pop(context, true);
        // https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/559.jpg
        setState(() => _isLoading = false);
      }
    }
  }
}