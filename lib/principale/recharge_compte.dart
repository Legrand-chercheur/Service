import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Recharger_compte extends StatefulWidget {
  int id_user;
  Recharger_compte({required this.id_user});

  @override
  State<Recharger_compte> createState() => _Recharger_compteState();
}

TextEditingController recharger = TextEditingController();

class _Recharger_compteState extends State<Recharger_compte> {


  final String baseUrl = 'http://10.0.2.2:8000/api';

  double Compte = 0.0; // Variable pour stocker le solde

  snackbar (text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content:Text(text,style: TextStyle(
          color: Colors.white
      ),),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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

  Future<void> ajouterSolde(int userId, String montant) async {
    final response = await http.post(
      Uri.parse('$baseUrl/comptes/ajouter-solde/$userId'),
      body: {
        'solde': montant,
      },
    );

    if (response.statusCode == 200) {
      snackbar('Solde ajouté avec succès');
      recharger.text = "";
    } else {
      snackbar('Échec de la requête');
      throw Exception('Échec de l\'ajout du solde.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      recupererSolde(widget.id_user);
    });
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
                  height: size.height/3,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      image: DecorationImage(
                          image: AssetImage('images/register.png'),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height,
                  child: Column(
                    children: [
                      SizedBox(height: 100,),
                      Text('Recharger compte',style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 25
                      ),),
                      SizedBox(height: 20,),

                      Container(
                        width: size.width/1.1,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black12
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width/1.4,
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20, top: 5),
                                  child: TextField(
                                    controller: recharger,
                                    decoration: InputDecoration(
                                        hintText: '0000000',
                                        hintStyle: TextStyle(
                                            color: Colors.redAccent
                                        ),
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),
                              ),
                              Text('Fcfa',style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),)
                            ],
                          ),
                        )
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text('Recharger mon compte',style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15
                      ),),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                ajouterSolde(widget.id_user, recharger.text);
                              },
                              child: Container(
                                width: size.width/2.4,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.red
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Avec',style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),),
                                    SizedBox(width: 15,),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(image: AssetImage('images/airtel.png'))
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                ajouterSolde(widget.id_user, recharger.text);
                              },
                              child: Container(
                                width: size.width/2.4,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Color.fromRGBO(0, 102, 180, 1)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Avec',style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                    ),),
                                    SizedBox(width: 15,),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(image: AssetImage('images/moov.png'))
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Positioned(
                top: size.height/4.5,
                left: size.width/4.5,
                child: Container(
                  width: 230,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(100),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Solde actuel',style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),),
                      Text('$Compte Fcfa',style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),),
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
