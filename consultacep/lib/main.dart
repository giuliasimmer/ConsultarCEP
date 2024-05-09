import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main(List<String> args) {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _cepController = TextEditingController();
  String _valorRetorno = "";

  void _buscarCep() async {
    String cep = _cepController.text;
    var _urlApi = Uri.parse("https://viacep.com.br/ws/$cep/json/");
    http.Response resposta = await http.get(_urlApi);

    String endereco = "";

    if (resposta.statusCode == 200) {
      Map<String, dynamic> dadosCep = json.decode(resposta.body);

      if (dadosCep.containsKey("erro")) {
        endereco = 'CEP não encontrado ou não existe, tente novamente.';
      } else {
        endereco =
            "${dadosCep["logradouro"] ?? ""}, ${dadosCep["bairro"] ?? ""}, "
            "${dadosCep["localidade"] ?? ""} - ${dadosCep["uf"] ?? ""} ";
      }
    } else {
      endereco = 'Erro ao buscar o CEP.';
    }

    setState(() {
      _valorRetorno = endereco;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar CEP"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'CEP'),
              ),
            ),
            Text('$_valorRetorno')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buscarCep,
        child: Icon(Icons.search),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
