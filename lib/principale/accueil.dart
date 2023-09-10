import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/principale/factures.dart';
import 'package:untitled2/principale/recharge_compte.dart';
import 'package:http/http.dart' as http;
import 'documents.dart';
import 'livraison_colis.dart';
import 'livraison_plies.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  int? userId = 0;
  String? userName = '';
  String? userLastName = '';
  String? userEmail = '';

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void session() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
      userName = prefs.getString('userName');
      userLastName = prefs.getString('userLastname');
      userEmail = prefs.getString('userEmail');
      recupererSolde(prefs.getInt('userId')!);
      print(userName!+userEmail!);
    });
  }

  final String baseUrl = 'http://10.0.2.2:8000/api';

  double Compte = 0.0; // Variable pour stocker le solde

  Future<void> recupererSolde(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/comptes/solde'),
      body: {
        'user_id': userId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);

      if (responseData != null && responseData['solde'] != null) {
        setState(() {
          Compte = double.parse(responseData['solde'].toString());
        });
        print('Solde récupéré avec succès : $Compte');
      } else {
        print('Échec de la récupération du solde : données non valides');
        throw Exception('Échec de la récupération du solde.');
      }
    } else {
      print('Échec de la requête : ${response.statusCode}');
      throw Exception('Échec de la récupération du solde.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    session();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    recupererSolde(userId!);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.redAccent,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Action when Item 1 is tapped
                Navigator.pop(context); // Close the drawer
                // Perform any other action you want
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Action when Item 2 is tapped
                Navigator.pop(context); // Close the drawer
                // Perform any other action you want
              },
            ),
          ],
        ),
      ),
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
                    padding: const EdgeInsets.only(bottom: 90),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => openDrawer(context),
                            icon: Icon(Icons.menu_outlined,color: Colors.white,),
                        ),
                        Text('App name',style: TextStyle(
                          color: Colors.white
                        ),)
                      ],
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height,
                  child: Column(
                    children: [
                      SizedBox(height: 100,),
                      Container(
                        width: size.width/1.1,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Plies(id_user: userId!,)));
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/letter.png'),
                                        fit: BoxFit.cover
                                    )
                                  ),
                                ),
                              ),
                              Text('Livraison des plies',style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 12
                              ),),
                              IconButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Plies(id_user: userId!,)));
                                },
                                icon: Icon(Icons.arrow_forward_ios_rounded,color: Colors.redAccent,),color: Colors.redAccent,)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: size.width/1.1,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/boite.png'),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              Text('Livraison des colis',style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              ),),
                              IconButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Colis(id_user: userId!,)));
                                },
                                icon: Icon(Icons.arrow_forward_ios_rounded,color: Colors.redAccent,),color: Colors.redAccent,)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: size.width/1.1,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/doc.png'),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              SizedBox(width: 5,),
                              Text('Legaliser un document',style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              ),),
                              IconButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Document(id_user: userId!,)));
                                },
                                icon: Icon(Icons.arrow_forward_ios_rounded,color: Colors.redAccent,),color: Colors.redAccent,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: size.width/1.1,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/facture.png'),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              Text('Payer vos factures',style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              ),),
                              IconButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Facture(id_user: userId!,)));
                                },
                                icon: Icon(Icons.arrow_forward_ios_rounded,color: Colors.redAccent,),color: Colors.redAccent,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
                top: size.height/8,
                left: size.width/20,
                child: Container(
                  width: size.width/1.1,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 70),
                                  child: Text('$userName $userLastName'),
                                ),
                                Text(userEmail!),
                              ],
                            ),
                            TextButton(
                                onPressed: (){},
                                child: Text('Gerer mon compte',style: TextStyle(
                                  color: Colors.green
                                ),),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Divider(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.monetization_on, color: Colors.redAccent,),
                                              SizedBox(width: 5,),
                                              Text('Solde de votre compte',style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('CFA',style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold
                                    ),),
                                    SizedBox(width: 5,),
                                    Text('$Compte',style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    ),)
                                  ],
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent), // Définit la couleur de fond à noir
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // Supprime les bordures
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Recharger_compte(id_user: userId!,)));
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                child: Center(child: Icon(Icons.add,color: Colors.white,),),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
