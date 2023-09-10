import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/principale/accueil.dart';

class Facture extends StatefulWidget {
  int id_user;
  Facture({required this.id_user});

  @override
  State<Facture> createState() => _FactureState();
}

TextEditingController depart = TextEditingController();
TextEditingController arrive = TextEditingController();
TextEditingController description = TextEditingController();

class _FactureState extends State<Facture> {

  String selectedFileName = '';
  String? pdfPath;

  snackbar (text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content:Text(text,style: TextStyle(
          color: Colors.white
      ),),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name ?? '';
        pdfPath = result.files.single.path;
      });
    }
  }

  Future<void> enregistrerDemande(int service_id, String nom_doc, String chemin_doc) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/enregistrer_demande'),
        body: {
          'depart': depart.text,
          'arrive': arrive.text,
          'description': description.text,
          'nom_doc': nom_doc,
          'chemin_doc': chemin_doc,
          'service_id': service_id.toString(),
          'user_id': widget.id_user.toString(),
        },
      );

      if (response.statusCode == 201) {
        snackbar('Demande enregistrée avec succès');
        // Réinitialisez les champs après l'enregistrement
        depart.clear();
        arrive.clear();
        description.clear();
        setState(() {
          selectedFileName = '';
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

  Future<void> envoyerDocumentPDF(int service_id) async {
    try {
      if (pdfPath != null) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('http://10.0.2.2:8000/api/enregistrer_document'),
        );

        request.files.add(await http.MultipartFile.fromPath(
          'document',
          pdfPath!,
          filename: selectedFileName,
        ));

        final response = await request.send();

        if (response.statusCode == 201) {
          final responseBody = await response.stream.bytesToString();
          final jsonResponse = json.decode(responseBody);
          final cheminDoc = jsonResponse['chemin_doc'];
          final nouveauNom = jsonResponse['nouveau_nom'];
          print('Chemin du document : $cheminDoc');
          enregistrerDemande(service_id, nouveauNom, cheminDoc);
          snackbar('Document PDF enregistré avec succès');
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Acceuil()), (route) => false);
        } else {
          snackbar('Échec de la requête d\'enregistrement du document : ${response.statusCode}');
          throw Exception('Échec de l\'enregistrement du document.');
        }
      }
    } catch (e) {
      snackbar('Erreur lors de l\'enregistrement du document : $e');
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
                                      color: Colors.redAccent,
                                      fontSize: 12
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
                                      color: Colors.redAccent,
                                      fontSize: 12
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
                                      color: Colors.redAccent,
                                      fontSize: 12
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
                            padding: const EdgeInsets.only(left: 20,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(selectedFileName==''?'Choisissez votre document':selectedFileName, style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10
                                ),),
                                GestureDetector(
                                  onTap: pickFile,
                                  child: Container(
                                    width: 60,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.redAccent
                                    ),
                                    child: Icon(Icons.add, color: Colors.white,),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: (){
                          envoyerDocumentPDF(4);
                        },
                        child: Container(
                          width: 100,
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
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                          image: AssetImage('images/facture.png'),
                          fit: BoxFit.contain
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
