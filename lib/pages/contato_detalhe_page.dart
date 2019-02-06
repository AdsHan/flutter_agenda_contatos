import 'dart:io';
import 'package:flutter/material.dart';
import '../helpers/contatos_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContatoDetalhePage extends StatefulWidget {
  final Contato contatoParam;

  // Recebe os dados do contato como parâmetro (o {} torna ele opcional)
  ContatoDetalhePage({this.contatoParam});

  @override
  _ContatoDetalhePageState createState() => _ContatoDetalhePageState();
}

class _ContatoDetalhePageState extends State<ContatoDetalhePage> {
  bool _usuarioEditado = false;

  final _nomeControler = TextEditingController();
  final _emailControler = TextEditingController();
  final _telefoneControler = TextEditingController();

  final _nameFocus = FocusNode();

  // Contato que stamos editando na nossa página
  Contato _editContato;

  @override
  void initState() {
    super.initState();
    // 'widget' se refete a classe acima (class ContatoDetalhePage extends StatefulWidget)
    if (widget.contatoParam == null) {
      // Se eu não passei um contato para editar, ele vai criar um novo
      _editContato = Contato();
    } else {
      _editContato = Contato.fromMap(widget.contatoParam.toMap());
      _nomeControler.text = _editContato.nome;
      _emailControler.text = _editContato.email;
      _telefoneControler.text = _editContato.telefone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editContato.nome ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editContato.nome != null && _editContato.nome.isNotEmpty) {
              // Irá remover a tela e retornar para anterior
              Navigator.pop(context, _editContato);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editContato.foto != null
                              ? FileImage(File(_editContato.foto))
                              : AssetImage("assets/person.png"))),
                ),
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.camera).then((arquivo) {
                    if (arquivo == null) return;
                    setState(() {
                      _editContato.foto = arquivo.path;
                    });
                  });
                },
              ),
              Divider(),
              TextField(
                controller: _nomeControler,
                focusNode: _nameFocus,
                decoration: InputDecoration(
                    labelText: "Nome", border: OutlineInputBorder()),
                onChanged: (text) {
                  _usuarioEditado = true;
                  setState(() {
                    _editContato.nome = text;
                  });
                },
              ),
              Divider(),
              TextField(
                  controller: _emailControler,
                  decoration: InputDecoration(
                      labelText: "Email", border: OutlineInputBorder()),
                  onChanged: (text) {
                    _usuarioEditado = true;
                    _editContato.email = text;
                  },
                  keyboardType: TextInputType.emailAddress),
              Divider(),
              TextField(
                  controller: _telefoneControler,
                  decoration: InputDecoration(
                      labelText: "Telefone", border: OutlineInputBorder()),
                  onChanged: (text) {
                    _usuarioEditado = true;
                    _editContato.telefone = text;
                  },
                  keyboardType: TextInputType.phone),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_usuarioEditado) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("As alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    // Um para remover a janela de diálogo, outro para a janela de detalhe
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      // Não sair automaticamente (vai sair pelo Navigator.pop)
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
