import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/login/login.dart';

import '../principale/accueil.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool chargement = false;

  Map<String, dynamic> user = {};
  final String baseUrl = 'http://10.0.2.2:8000/api';

  TextEditingController email = TextEditingController();
  TextEditingController mdp = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController tel = TextEditingController();

  snackbar (text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content:Text(text,style: TextStyle(
          color: Colors.white
      ),),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> registerUser() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/register'),
      body: {
        'nom': nom.text,
        'prenom': prenom.text,
        'email': email.text,
        'tel': tel.text,
        'password': mdp.text,
      },
    );

    if (response.statusCode == 201) {
      // L'inscription a réussi, vous pouvez afficher un message à l'utilisateur
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false);
      print('c\'est top');
    } else {
      throw Exception('Échec de l\'inscription');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: size.width,
                  height: size.height/4,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      image: DecorationImage(
                          image: AssetImage('images/register.png'),
                          fit: BoxFit.cover
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white,)
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height/1.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: Row(
                          children: [
                            Text('Incrivez vous ici',style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 30,
                                fontWeight: FontWeight.bold
                            ),),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width/2.5,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black12
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextField(
                                  controller: nom,
                                  decoration: InputDecoration(
                                      hintText: 'Nom',
                                      hintStyle: TextStyle(
                                          color: Colors.redAccent
                                      ),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Container(
                            width: size.width/2.5,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black12
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextField(
                                  controller: prenom,
                                  decoration: InputDecoration(
                                      hintText: 'Prenom',
                                      hintStyle: TextStyle(
                                          color: Colors.redAccent
                                      ),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: size.width/1.2,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black12
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: email,
                              decoration: InputDecoration(
                                  hintText: 'Adresse mail',
                                  hintStyle: TextStyle(
                                      color: Colors.redAccent
                                  ),
                                  border: InputBorder.none
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: size.width/1.2,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black12
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: tel,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: 'Tel',
                                  hintStyle: TextStyle(
                                      color: Colors.redAccent
                                  ),
                                  border: InputBorder.none
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: size.width/1.2,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black12
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: mdp,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: 'Mot de passe',
                                  hintStyle: TextStyle(
                                      color: Colors.redAccent
                                  ),
                                  border: InputBorder.none
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      chargement == false
                          ?GestureDetector(
                        onTap: (){
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>Acceuil()));
                          registerUser();
                        },
                        child: Container(
                          width: size.width/1.2,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.redAccent
                          ),
                          child: Center(
                            child: Text('S\'inscrire',style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                      )
                          :Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(2000),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
                bottom: size.height/1.6,
                left: size.width/3.1,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(2000),
                    image: DecorationImage(
                        image: AssetImage('images/logo.jpeg'),
                        fit: BoxFit.cover
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
