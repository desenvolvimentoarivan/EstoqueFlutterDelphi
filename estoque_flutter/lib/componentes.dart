import 'package:flutter/material.dart';

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
