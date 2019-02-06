import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/contatos_helper.dart';
import 'contato_detalhe_page.dart';

// Conjunto de constantes
enum OrderOptions { orderaz, orderza }

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

    _buscaTodosContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contatos"),
          backgroundColor: Colors.red,
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                    const PopupMenuItem<OrderOptions>(
                      child: Text("Ordernar A-Z"),
                      value: OrderOptions.orderaz,
                    ),
                    const PopupMenuItem<OrderOptions>(
                      child: Text("Ordernar Z-A"),
                      value: OrderOptions.orderza,
                    ),
                  ],
              onSelected: _orderList,
            )
          ],
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showContatoDetalhePage();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
        ),
        body: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: contatos.length,
            itemBuilder: (context, index) {
              return _montaContatoCard(context, index);
            }));
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
                        image: contatos[index].foto != null
                            ? FileImage(File(contatos[index].foto))
                            : AssetImage("assets/person.png"))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contatos[index].nome ?? "",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contatos[index].email ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      contatos[index].telefone ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _ShowOptions(context, index);
      },
    );
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contatos.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contatos.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void _buscaTodosContatos() {
    helper.getAllContato().then((list) {
      setState(() {
        contatos = list;
      });
    });
  }

  void _ShowOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Ligar",
                            style:
                                TextStyle(color: Colors.red, fontSize: 20.0)),
                        onPressed: () {
                          launch("tel:${contatos[index].telefone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Editar",
                            style:
                                TextStyle(color: Colors.red, fontSize: 20.0)),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContatoDetalhePage(contato: contatos[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Excluir",
                            style:
                                TextStyle(color: Colors.red, fontSize: 20.0)),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            helper.deletaContato(contatos[index].id);
                            contatos.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showContatoDetalhePage({Contato contato}) async {
    final contatoModificado = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContatoDetalhePage(contatoParam: contato)));

    if (contatoModificado != null) {
      // Se originalmente eu tinha enviado um contato (alteração)
      if (contato != null) {
        await helper.atualizaContato(contatoModificado);
      } else {
        await helper.salvaContato(contatoModificado);
      }
      _buscaTodosContatos();
    }
  }
}
