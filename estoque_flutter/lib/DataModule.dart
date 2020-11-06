import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

String idCategoria = '';
String nomeCategoria = '';
String acao = '';
String qtdEstoque = '0';
String idProduto = '0';
String nmeEstoque = '0';

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

/*Future<List<Produtos>> fetchListProdutoCat() async {
  SharedPreferences arqIini = await SharedPreferences.getInstance();
  String ip = arqIini.getString('ip');

  final response = await http.get(
      'http://' + ip + ':8082/eventos/getProdutoCat?pCategoria=$idCategoria');

  /*print('fetchListProdutoCat: ' +
      'http://' +
      ip +
      ':8082/eventos/getProdutoCat?pCategoria=$idCategoria');*/

  if (response.statusCode == 200) {
    // String source = Utf8Decoder().convert(response.bodyBytes);
    // List produto = json.decode(source);
    //print(produto);
    //print(produto.map((produto) => produto.fromJson(produto)).toList());
    //List produto = json.decode(utf8.decode(response.bodyBytes));
    //return produto.map((produto) => Produtos.fromJson(produto)).toList();

    //return produto.map((produto) => produto.fromJson(produto)).toList();
    String source = Utf8Decoder().convert(response.bodyBytes);
    List produto = json.decode(source);
    //print(produto);
    return produto.map((produto) => Produtos.fromJson(produto)).toList();
  } else
    throw Exception('Erro ao carregar Categorias');
}*/

Future<List<Produtos>> fetchListProdutos() async {
  SharedPreferences arqIni = await SharedPreferences.getInstance();
  String ip = arqIni.getString('ip');

  /* print('fetchListProdutos: ' +
      'http://$ip:8082/eventos/getProdutos?pSelect=$acao');*/

  final response =
      await http.get('http://$ip:8082/eventos/getProdutos?pSelect=$acao');

  if (response.statusCode == 200) {
    if (response.body != 'vazio') {
      String source = Utf8Decoder().convert(response.bodyBytes);
      List produto = json.decode(source);

      return produto.map((produto) => Produtos.fromJson(produto)).toList();
    } else
      return null;
  } else
    throw Exception('Erro ao carregar produto');
}

void gravarEstoque() async {
  SharedPreferences arqIni = await SharedPreferences.getInstance();
  String ip = arqIni.getString('ip');

  String vlrEstoque = qtdEstoque.replaceAll(',', '.');
  String url = 'http://' +
      ip +
      ':8082/eventos/Gravar?pSelect=' +
      'update produto set estoque = ' +
      vlrEstoque +
      ' where codigo =' +
      "'" +
      idProduto +
      "'";

  await http.post(url);
}

class Produtos {
  final String codigo, nome, codbarra, unidade, preco, estoque;

  Produtos(
      {this.codigo,
      this.nome,
      this.codbarra,
      this.unidade,
      this.preco,
      this.estoque});

  factory Produtos.fromJson(Map<String, dynamic> json) {
    return Produtos(
        codigo: json['CODIGO'].toString(),
        nome: json['NOME'],
        codbarra: json['CODBARRA'],
        unidade: json['UNIDADE'],
        preco: json['PRECO'].toString(),
        estoque: json['ESTOQUE'].toString());
  }
}
