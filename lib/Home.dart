import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pathprovider/Tarefa.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
class Home extends StatefulWidget {

  @override
  _State createState() => _State();
}

class _State extends State<Home> {
  List<Tarefa> listaTarefas = [];
  var tituloController = TextEditingController();
  var stringResult = "";


  _escreverLista() async{
    var diretorio = await getApplicationDocumentsDirectory();
    var caminho = "${diretorio.path}/dados.json";
    var arquivo = File(caminho);
    var listasalvar = [];
    for(var tarefa in listaTarefas){
      var mapTarefa = Map();
      mapTarefa['titulo'] = tarefa.titulo;
      mapTarefa['realizada'] = tarefa.Realizada;
      listasalvar.add(mapTarefa);
    }
    var listaSalvarEncode = json.encode(listasalvar);
    arquivo.writeAsString(listaSalvarEncode);

  }

  _adicionarTarefa(){
    if(tituloController.text == ""){
      setState(() {
        stringResult = "Você não digitou o titulo";
      });
    }
    else{
      setState(() {
        stringResult = "";
      });
      var tarefaAdd = Tarefa(tituloController.text, false);
      setState(() {
        listaTarefas.add(tarefaAdd);
        tituloController.text = "";
      });
      _escreverLista();
      Navigator.pop(context);

    }

  }

  _lerLista() async{
    var diretorio = await getApplicationDocumentsDirectory();
    var caminho = "${diretorio.path}/dados.json";
    var arquivo = File(caminho);
    listaTarefas = [];
    var arquivoLer = await arquivo.readAsString();
    var arquivoMapJson = jsonDecode(arquivoLer);
    for(var tarefa in arquivoMapJson){
      var tarefaAdd = Tarefa(tarefa['titulo'], tarefa['realizada']);
      setState(() {
        listaTarefas.add(tarefaAdd);
      });
      print(tarefaAdd.titulo);
    }
  }

  _apagarDaLista(int index){
    setState(() {
      listaTarefas.removeAt(index);
    });
    _escreverLista();
  }
  @override
  void initState() {
    _lerLista();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: Text("Lista de tarefasa"), backgroundColor: Colors.purple,),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder: (context){
            return AlertDialog(
              title: Text("Escreva o titulo da nova tarefa"),
              content: TextField(
                controller: tituloController,
                decoration: InputDecoration(label: Text("Titulo")),
              ),
              actions: [
                FlatButton(onPressed: (){
                  _adicionarTarefa();
                }, child: Text("Adicionar"),
                color: Colors.purple,)
              ],
            );
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
      body: Padding(padding: EdgeInsets.all(16),
      child: Expanded(
        child:
        ListView.builder(
            itemCount: listaTarefas.length,
            itemBuilder: (context,index){
              var tarefa = listaTarefas[index];
              return
                Dismissible(  background: Container(
                      color: Colors.red,
                    ),
                    key: ValueKey<Tarefa>(listaTarefas[index]),
                    onDismissed: (DismissDirection direction) {
                      _apagarDaLista(index);
                      },
                    child:
                Container(
                width: double.infinity,
                height: 40,
                child:
                Padding(padding: EdgeInsets.only(left: 5,right: 5),
                child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tarefa.titulo),
                      Checkbox(value: tarefa.Realizada, onChanged: (value){
                        setState(() {
                          if(value != null)
                          tarefa.Realizada = value;
                        });
                        _escreverLista();
                      }),
                    ],
                  ),),
              )
                );
            }),
      )),
    );
  }
}
