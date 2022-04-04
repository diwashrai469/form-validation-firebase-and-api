import 'package:flutter/material.dart';
import 'package:stopwatch/for_apiui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Form validation",
    initialRoute: "1",
    routes: {"//": (context) => myapi(), "1": ((context) => formvalidation())},
  ));
}

class formvalidation extends StatefulWidget {
  const formvalidation({Key? key}) : super(key: key);

  @override
  State<formvalidation> createState() => _formvalidationState();
}

class _formvalidationState extends State<formvalidation> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errormessage = '';
  String errorsigninmessgae = '';
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.blueGrey,
        child: Form(
          key: _key,
          child: Center(
            child: Container(
              height: 350,
              width: 450,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      controller: emailcontroller,
                      decoration: const InputDecoration(
                          label: Text("Email"),
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.black),
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email is empty.";
                        } else if (!value.contains('@gmail.com')) {
                          return "invalid email.";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      controller: passwordcontroller,
                      decoration: const InputDecoration(
                          label: Text("Password"),
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.black),
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is empty.";
                        } else if (value.length < 6) {
                          return "Password length should be greater then 6.";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        errormessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        errorsigninmessgae,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 45,
                          width: 100,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              onPressed: () async {
                                if (_key.currentState!.validate()) {
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: emailcontroller.text,
                                            password: passwordcontroller.text);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => myapi()));
                                  } on FirebaseAuthException catch (error) {
                                    errorsigninmessgae =
                                        "The email you entered isn’t connected to an account.";
                                  }
                                }

                                setState(() {});
                              },
                              child: const Text(
                                "Log In",
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                        SizedBox(
                          height: 45,
                          width: 110,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              onPressed: () async {
                                if (_key.currentState!.validate()) {
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: emailcontroller.text,
                                            password: passwordcontroller.text);
                                  } on FirebaseAuthException catch (error) {
                                    errormessage = error.message!;
                                  }

                                  setState(() {});
                                }

                                passwordcontroller.clear();
                              },
                              child: const Text(
                                "Sigh Up",
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                      ])
                ],
              ),
            ),
          ),
        ));
  }
}
