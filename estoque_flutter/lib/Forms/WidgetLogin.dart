import 'package:estoque_flutter/Forms/WidgetMenu.dart';
import 'package:estoque_flutter/componentes.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WidgetLogin extends StatefulWidget {
  @override
  _WidgetLoginState createState() => _WidgetLoginState();
}

class _WidgetLoginState extends State<WidgetLogin> {
  TextEditingController _usuario = TextEditingController();
  TextEditingController _senha = TextEditingController();
  TextEditingController _ipServer = TextEditingController();

  bool _lembrar;
  void _lembrarChanged(bool value) => setState(() => _lembrar = value ?? false);

  SharedPreferences arqIni;

  _gravaArqIni() async {
    arqIni = await SharedPreferences.getInstance();
    setState(() {
      if (_lembrar == true && _usuario.text.isNotEmpty) {
        arqIni.setString('usuario', _usuario.text);
        arqIni.setString('senha', _senha.text);
      } else {
        arqIni.setString('usuario', '');
        arqIni.setString('senha', '');
      }
    });

    arqIni.setString('ip', _ipServer.text);
  }

  _lerArqIni() async {
    arqIni = await SharedPreferences.getInstance();
    setState(() {
      _ipServer.text = arqIni.getString('ip');

      if (arqIni.getString('usuario') != '') {
        _usuario.text = arqIni.getString('usuario') ?? '';
        _senha.text = arqIni.getString('senha') ?? '';
        _lembrar = true;
      } else {
        _lembrar = false;
        _usuario.text = '';
        _senha.text = '';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _lerArqIni();
  }

  void login() async {
    if (_ipServer.text.isNotEmpty &&
        _usuario.text.isNotEmpty &&
        _senha.text.isNotEmpty) {
      var url = 'http://' +
          _ipServer.text +
          ':8082/eventos/Login?pUsuario=' +
          _usuario.text +
          '&pSenha=' +
          _senha.text;

      http.Response resposta;

      //print(url);
      try {
        resposta = await http.get(url);
        if (resposta.statusCode == 200) {
          if (resposta.body != 'erro') {
            _gravaArqIni();
            //print('login ok');
            /* FlushbarHelper.createSuccess(
              message: 'Seja bem-vindo ao sistema',
              title: 'Bem Vindo ' + resposta.body,
              duration: Duration(seconds: 2),
            )..show(context);*/

            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => WidgetMenu()));
          } else {
            //print('login errado');
            FlushbarHelper.createError(
              message: 'Usuário ou Senha inválidos',
              title: 'Erro',
              duration: Duration(seconds: 3),
            )..show(context);
          }
        }
      } catch (error) {
        print('erro ao conectar ao servidor ' + error.toString());
      }
    } else {
      FlushbarHelper.createInformation(
        message: 'Preencha todos os campos',
        title: 'Ops',
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        //mini: true,
        child: Icon(
          Icons.settings,
          size: 35,
        ),

        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Column(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Colors.blue[900],
                        size: 64,
                      ),
                      Text('Configurações'),
                    ],
                  ),
                  content: Tedit(
                    label: 'IP do servidor',
                    teclado: TextInputType.number,
                    controle: _ipServer,
                  ),
                );
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 5,
              height: 50,
            ),
            Text(
              'Empresa Teste',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(
                Icons.copyright,
                size: 25,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              width: double.infinity,
              color: Colors.transparent,
              child: Image.asset(
                'img/logo.png',
                height: 120,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Tedit(
              label: 'Usuário',
              controle: _usuario,
            ),
            SizedBox(
              height: 25,
            ),
            Tedit(
              controle: _senha,
              label: 'Senha',
              senha: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Checkbox(
                  onChanged: _lembrarChanged,
                  value: _lembrar ?? false,
                ),
                Text(
                  'Lembrar Usuário ',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 80, maxWidth: 200),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                splashColor: Colors.blueGrey,
                color: Colors.blue,
                onPressed: () {
                  //_gravaArqIni();
                  login();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 50,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
