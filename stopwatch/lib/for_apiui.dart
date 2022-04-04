//api integration example

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stopwatch/main.dart';

class myapi extends StatefulWidget {
  const myapi({Key? key}) : super(key: key);

  @override
  State<myapi> createState() => _myapiState();
}

class _myapiState extends State<myapi> {
  late Map mapresponse;
  late Map dataresponse;
  late List mylist = [];

  Future apicall() async {
    http.Response response;
    response = await http.get(Uri.parse("https://reqres.in/api/users?page=2"));
    if (response.statusCode == 200) {
      setState(() {
        mapresponse = jsonDecode(response.body);
        mylist = mapresponse['data'];
      });
    } else {
      const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  void initState() {
    apicall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: mylist != null
              ? ListView.builder(
                  itemCount: mylist.length,
                  itemBuilder: ((context, index) {
                    return Container(
                        decoration: const BoxDecoration(color: Colors.green),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                formvalidation()));
                                    setState(() {});
                                  },
                                  child: Text(
                                    "log out",
                                    style: TextStyle(fontSize: 20),
                                  )),
                            ),
                            SizedBox(
                                height: 150,
                                width: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    mylist[index]['avatar'],
                                    fit: BoxFit.fill,
                                  ),
                                )),
                            Text(mylist[index]['id'].toString()),
                            Text(mylist[index]['email'].toString()),
                            Text(mylist[index]['first_name'].toString()),
                            Text(mylist[index]['last_name'].toString()),
                          ],
                        ));
                  }))
              : const Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
