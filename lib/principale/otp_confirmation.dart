import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../login/login.dart';

class OTP extends StatefulWidget {
  var email, pseudo, telephone, password, code, prenom;
  OTP({required this.email, required this.pseudo, required this.telephone, required this.password, required this.code, required this.prenom});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {

  String _errorMessage = '';
  String code = '';
  int IntCode = 0;
  Future<void> registerUser() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/register'),
      body: {
        'nom': widget.pseudo,
        'prenom': widget.prenom,
        'email':widget.email,
        'tel': widget.telephone,
        'password': widget.password,
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Row(
              children: [
                IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back)
                ),
                SizedBox(width: 30,),
                Text('Code de verification')
              ],
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text('Entrer le code de verification que vous avez recu par mail! $code',style: TextStyle(
                  fontSize: 14
              ),),
            ),
            SizedBox(height: 60,),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 64,
                    width: 68,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: true,
                        onSaved: (code1){},
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                            code = code + value;
                          }
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(counterText: "",border: InputBorder.none),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  Container(
                    height: 64,
                    width: 68,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: true,
                        onSaved: (code2){},
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                            code = code + value;
                          }
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(counterText: "",border: InputBorder.none),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  Container(
                    height: 64,
                    width: 68,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: true,
                        onSaved: (code3){},
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                            code = code + value;
                          }
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(counterText: "",border: InputBorder.none),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  Container(
                    height: 64,
                    width: 68,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: true,
                        onSaved: (code4){},
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                            code = code + value;
                            IntCode = int.parse(code);
                          }
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(counterText: "",border: InputBorder.none),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 65),
              child: Row(
                children: [
                  Text('Vous n\'avez pas recu de code?'),
                  TextButton(
                    onPressed: (){
                      code = "";
                      IntCode = 0;
                    },
                    child: Text('Renvoyer le code',style: TextStyle(
                        color: Colors.redAccent
                    ),),)
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/6,),
            GestureDetector(
              onTap: (){
                if(IntCode == widget.code){
                  registerUser();
                }else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('confirmation'),
                        content: Text('Le code ne correspond pas, Reesayer...'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              code = "";
                              IntCode = 0;
                            },
                            child: Text('Fermer'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width/1.1,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text('Confirmer',style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
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
