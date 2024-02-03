import 'package:flutter/material.dart';


class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  @override
  Widget build(BuildContext context) {
   return  Scaffold(
        appBar: AppBar(
        title: Text("로그인 창", style: TextStyle(fontSize: 20, color: Colors.white),),
        backgroundColor: Colors.red,
      ),
      );
    }
}