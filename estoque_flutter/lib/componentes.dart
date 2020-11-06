import 'package:flutter/material.dart';

import 'DataModule.dart';

class Tedit extends StatelessWidget {
  final String label;
  final TextEditingController controle;
  final TextInputType teclado;
  final bool senha;

  const Tedit(
      {Key key, this.label, this.controle, this.teclado, this.senha = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controle,
      keyboardType: teclado,
      obscureText: senha,
      style: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
      decoration: InputDecoration(
        suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              controle.clear();
            }),
        labelText: label,
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

void alterarEstoque(BuildContext context) async {
  TextEditingController controle = TextEditingController();
  controle.text = qtdEstoque;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Icon(
                Icons.search,
                color: Colors.blue[900],
                size: 64,
              ),
              Text(nmeEstoque),
            ],
          ),
          content: Tedit(
            label: 'Estoque Atual',
            teclado: TextInputType.number,
            controle: controle,
          ),
          actions: [
            FlatButton(
              onPressed: () {
                qtdEstoque = controle.text;
                gravarEstoque();
                Navigator.of(context).pop();
              },
              child: Text('Alterar'),
            ),
          ],
        );
      });
}
