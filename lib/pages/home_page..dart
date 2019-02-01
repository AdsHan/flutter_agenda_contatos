import 'dart:io';

import 'package:flutter/material.dart';

import '../helpers/contatos_helper.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ContatosHelper helper = ContatosHelper();

  List<Contato> contatos = List();

  @override
  void initState() {
    super.initState();

/*
    Contato c = Contato();
    c.nome = "Capitão Carverna";
    c.email = "caverna@gmail.com";
    c.telefone = "999999999";
    c.foto = "img/teste";
    helper.salvaContato(c);
*/

    helper.getAllContato().then((list) {
      setState(() {
        contatos = list;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contatos.length,
          itemBuilder: (context, index) {
            return _montaContatoCard(context, index);
          }
      )
    );
  }



  Widget _montaContatoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contatos[index].foto != null ? FileImage(File(contatos[index].foto)) : AssetImage("assets/person.png")
                    )
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contatos[index].nome ?? "",
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(contatos[index].email ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(contatos[index].telefone ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              )



            ],
          ),
        ),
      ),
    );
  }


}


