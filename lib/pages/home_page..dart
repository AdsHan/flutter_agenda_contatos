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
            
          }
      )
    );
  }
}
