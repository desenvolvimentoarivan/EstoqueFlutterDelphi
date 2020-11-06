import 'package:estoque_flutter/DataModule.dart';
import 'package:estoque_flutter/componentes.dart';
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
                  future: fetchListProdutos(),
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
                                    Card(
                                      elevation: 3,
                                      child: InkWell(
                                        splashColor: Colors.blue,
                                        onTap: () {
                                          qtdEstoque = '${produto.estoque}';
                                          nmeEstoque = '${produto.nome}';
                                          idProduto = '${produto.codigo}';
                                          alterarEstoque(context);
                                          setState(() {});
                                          //fetchListProdutos();
                                        },
                                        child: Container(
                                          height: 85,
                                          padding: EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                '${produto.nome}',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('Código:${produto.codigo} ' +
                                                  'R\$ Venda: ${produto.preco}' +
                                                  ' Estoque: ${produto.estoque}' +
                                                  '${produto.unidade}'),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('EAN: ${produto.codbarra}'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      );
                    } else if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return Center(child: Text('Categoria sem produtos'));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
