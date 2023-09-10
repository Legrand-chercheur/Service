import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/principale/accueil.dart';

class Plies extends StatefulWidget {
  int id_user;
  Plies({required this.id_user});

  @override
  State<Plies> createState() => _PliesState();
}

TextEditingController depart = TextEditingController();
TextEditingController arrive = TextEditingController();
TextEditingController description = TextEditingController();

class _PliesState extends State<Plies> {

  String? pdfPath;
  final String baseUrl = 'http://10.0.2.2:8000/api';

  snackbar (text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content:Text(text,style: TextStyle(
          color: Colors.white
      ),),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> enregistrerDemande(int service_id) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/enregistrer_demande'),
        body: {
          'depart': depart.text,
          'arrive': arrive.text,
          'description': description.text,
          'nom_doc': "null",
          'chemin_doc': "null",
          'service_id': service_id.toString(),
          'user_id': widget.id_user.toString(),
        },
      );

      if (response.statusCode == 201) {
        snackbar('Demande enregistrée avec succès');
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Acceuil()), (route) => false);
        // Réinitialisez les champs après l'enregistrement
        depart.clear();
        arrive.clear();
        description.clear();
        setState(() {
          pdfPath = null;
        });
      } else {
        snackbar('Échec de la requête de demande : ${response.statusCode}');
        throw Exception('Échec de l\'enregistrement de la demande.');
      }
    } catch (e) {
      snackbar('Erreur lors de l\'enregistrement : $e');
      // Gérer l'erreur ici
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
                ),
                Container(
                  width: size.width,
                  height: size.height,
                  child: Column(
                    children: [
                      SizedBox(height: 150,),
                      Container(
                        width: size.width/1.1,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black12
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: depart,
                              decoration: InputDecoration(
                                  hintText: 'Adresse de recuperation',
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
                        width: size.width/1.1,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black12
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: arrive,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: 'Adresse de livraison',
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
                        width: size.width/1.1,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black12
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: description,
                              decoration: InputDecoration(
                                  hintText: 'Description de la course',
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
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: (){
                          enregistrerDemande(1);
                        },
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.redAccent
                          ),
                          child: Icon(Icons.send_rounded, color: Colors.white,),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Positioned(
                top: size.height/8,
                left: size.width/4.5,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                          image: AssetImage('images/letter.png'),
                          fit: BoxFit.cover
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
