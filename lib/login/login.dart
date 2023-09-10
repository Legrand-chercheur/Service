import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../principale/accueil.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool chargement = false;

  TextEditingController email = TextEditingController();
  TextEditingController mdp = TextEditingController();

  Map<String, dynamic> user = {};
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<void> Connexion(String email, String mdp) async {
    setState(() {
      chargement = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'email': email,
          'password': mdp,
        },
      );

      if (response.statusCode == 200) {
        final dynamic userData = json.decode(response.body);

        if (userData != null) {
          setState(() {
            user = userData;
            chargement = false;
          });

          // Enregistrez les données dans les SharedPreferences
          final SharedPreferences sauvegarde = await SharedPreferences.getInstance();
          sauvegarde.setInt('userId', user['id']);
          sauvegarde.setString('userName', user['nom']); // Assurez-vous que le champ est correct
          sauvegarde.setString('userLastname', user['prenom']); // Assurez-vous que le champ est correct
          sauvegarde.setString('userEmail', user['email']);

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Acceuil()),
                (route) => false,
          );
        }
      } else {
        print('Échec de la connexion');
        setState(() {
          chargement = false;
        });
        throw Exception('Connexion échouée. Vérifiez vos identifiants.');
      }
    } catch (e) {
      print('Erreur lors de la connexion : $e');
      setState(() {
        chargement = false;
      });
      throw Exception('Une erreur est survenue lors de la connexion.');
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
                  height: size.height/2.7,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    image: DecorationImage(
                        image: AssetImage('images/login.jpg'),
                        fit: BoxFit.cover
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 170),
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
                  height: size.height/1.7,
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
                            Text('Connectez vous ici',style: TextStyle(
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
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Row(
                          children: [
                            TextButton(onPressed: (){}, child: Text('Mot de passe oublie?',style: TextStyle(
                              color: Colors.redAccent
                            ),)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      chargement == false
                          ?GestureDetector(
                        onTap: (){
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                          Connexion(email.text,mdp.text);
                        },
                        child: Container(
                          width: size.width/1.2,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.redAccent
                          ),
                          child: Center(
                            child: Text('Connexion',style: TextStyle(
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
              bottom: size.height/2.1,
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
