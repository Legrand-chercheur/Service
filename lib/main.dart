import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/login/login.dart';
import 'package:untitled2/principale/accueil.dart';

import 'login/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    int? userId = 0;

    void session() async{
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getInt('userId');
    }
    session();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: userId == null ?const Commencer():const Acceuil(),
    );
  }
}

class Commencer extends StatefulWidget {
  const Commencer({super.key});

  @override
  State<Commencer> createState() => _CommencerState();
}

class _CommencerState extends State<Commencer> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/login.png'),
              fit: BoxFit.cover
          )
        ),
        child: Column(
          children: [
            SizedBox(height: size.height/4,),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                image: DecorationImage(
                  image: AssetImage('images/logo.jpeg'),
                  fit: BoxFit.contain
                )
              ),
            ),
            SizedBox(height: size.height/3.3,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
              },
              child: Container(
                width: size.width/1.2,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.redAccent
                ),
                child: Center(
                  child: Text('Se connecter',style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),),
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
              },
              child: Container(
                width: size.width/1.2,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white
                ),
                child: Center(
                  child: Text('S\'inscrire',style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

