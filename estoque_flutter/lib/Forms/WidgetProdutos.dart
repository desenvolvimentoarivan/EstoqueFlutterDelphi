import 'package:estoque_flutter/DataModule.dart';
import 'package:flutter/material.dart';

class WidgetProdutos extends StatefulWidget {
  @override
  _WidgetProdutosState createState() => _WidgetProdutosState();
}

class _WidgetProdutosState extends State<WidgetProdutos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nomeCategoria),
      ),
      body: Stack(
        children: [
          Container(
            child: Center(
              child: FutureBuilder<List<Produtos>>(
                  future: fetchListProdutoCat(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Produtos> produto = snapshot.data;
                      return ListView(
                        padding: EdgeInsets.all(8),
                        children: produto
                            .map((produto) => Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text('${produto.nome}'),
                                  ],
                                ))
                            .toList(),
                      );
                    } else if (!snapshot.hasData) {
                      return Center(child: Text('Categoria sem produtos'));
                    }
                    return CircularProgressIndicator();
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
