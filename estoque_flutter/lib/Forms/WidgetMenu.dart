import 'package:estoque_flutter/componentes.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
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
                        onPressed: () {},
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Tela Categorias"),
          ],
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
                        onPressed: () {},
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
                        onPressed: () {},
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
                        onPressed: () {},
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
