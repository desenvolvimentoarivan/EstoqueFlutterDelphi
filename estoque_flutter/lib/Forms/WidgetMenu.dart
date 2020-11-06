import 'package:estoque_flutter/DataModule.dart';
import 'package:estoque_flutter/Forms/WidgetProdutos.dart';
import 'package:estoque_flutter/componentes.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class WidgetMenu extends StatefulWidget {
  @override
  _WidgetMenuState createState() => _WidgetMenuState();
}

class _WidgetMenuState extends State<WidgetMenu> {
  TextEditingController _scan = TextEditingController();
  TextEditingController _prod = TextEditingController();

  int currentPage = 1;

  GlobalKey bottomNavigationKey = GlobalKey();

  scan() async {
    _scan.clear();

    try {
      String reader = await scanner.scan();

      if (!mounted) {
        return null;
      }

      setState(() {
        _scan.text = reader;
        if (_scan.text.isNotEmpty) {
          nomeCategoria = 'Busca EAN = ' + _scan.text;
          acao = 'codbarra = ' + "'" + _scan.text + "'";

          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => WidgetProdutos()));
        }
      });
    } on PlatformException catch (e) {
      if (e.code == scanner.CameraAccessDenied) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Principal"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(
              iconData: FontAwesome.barcode, title: "Scanner", onclick: () {}),
          TabData(
              iconData: Icons.category, title: "Categorias", onclick: () {}),
          TabData(iconData: FontAwesome.dropbox, title: "Produtos")
        ],
        initialSelection: 1,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesome.qrcode,
                size: 100,
                color: Colors.blue[600],
              ),
              Text(
                "Código de Barras",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Tedit(
                  controle: _scan,
                  label: 'Digite ou Escaneie',
                  teclado: TextInputType.number,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          FontAwesome.search,
                        ),
                        onPressed: () {
                          nomeCategoria = 'Busca EAN = ' + _scan.text;
                          acao = 'codbarra = ' + "'" + _scan.text + "'";

                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => WidgetProdutos()));
                        },
                        iconSize: 40,
                        color: Colors.blue,
                      ),
                      Text('Localizar'),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(FontAwesome.barcode),
                        onPressed: () {
                          scan();
                        },
                        iconSize: 40,
                        color: Colors.blue,
                      ),
                      Text('Scanear'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      case 1:
        return Center(
          child: FutureBuilder<List<Categorias>>(
              future: fetchListCategorias(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Categorias> categoria = snapshot.data;

                  return ListView(
                    padding: EdgeInsets.all(15),
                    children: categoria
                        .map((categoria) => Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  splashColor: Colors.deepPurple,
                                  color: Colors.blue,
                                  onPressed: () {
                                    idCategoria = '${categoria.codigo}';
                                    nomeCategoria = '${categoria.nome}';
                                    acao = 'codcategoria = ${categoria.codigo}';
                                    print(nomeCategoria);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WidgetProdutos()));
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(
                                          '${categoria.nome}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  );
                }
                return CircularProgressIndicator();
              }),
        );
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesome.dropbox,
                size: 100,
                color: Colors.blue[600],
              ),
              Text(
                "Produtos",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Tedit(
                  controle: _prod,
                  label: 'Digite o que pesquisar',
                  //teclado: TextInputType.number,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          FontAwesome.tags,
                        ),
                        onPressed: () {
                          nomeCategoria = _prod.text;
                          acao = 'codigo =' + _prod.text;

                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => WidgetProdutos()));
                        },
                        iconSize: 40,
                        color: Colors.blue,
                      ),
                      Text('Código'),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(FontAwesome.font),
                        onPressed: () {
                          nomeCategoria = _prod.text;
                          acao = 'nome like ' + "'" + _prod.text;
                          print(acao);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => WidgetProdutos()));
                        },
                        iconSize: 40,
                        color: Colors.blue,
                      ),
                      Text('Nome'),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(FontAwesome.barcode),
                        onPressed: () {
                          nomeCategoria = _prod.text;
                          acao =
                              'codbarra like ' + "'" + _prod.text + "%" + "'";

                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => WidgetProdutos()));
                        },
                        iconSize: 40,
                        color: Colors.blue,
                      ),
                      Text('Barras'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
    }
  }
}
