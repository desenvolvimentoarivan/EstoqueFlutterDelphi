import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<List<Categorias>> fetchListCategorias() async {
  SharedPreferences arqIini = await SharedPreferences.getInstance();
  String ip = arqIini.getString('ip');

  final response =
      await http.get('http://' + ip + ':8082/eventos/GetCategoria?');

  if (response.statusCode == 200) {
    List categoria = json.decode(utf8.decode(response.bodyBytes));
    return categoria
        .map((categoria) => Categorias.fromJson(categoria))
        .toList();
  } else
    throw Exception('Erro ao carregar Categorias');
}

class Categorias {
  final codigo, nome;

  Categorias({this.codigo, this.nome});

  factory Categorias.fromJson(Map<String, dynamic> json) {
    return Categorias(codigo: json['CODIGO'], nome: json['NOME']);
  }
}
