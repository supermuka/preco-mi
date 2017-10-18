import 'produto.dart';

class ProdutoComponente {
  String chave;
  bool deletado = false;

  String produto_chave;
  Produto produto;

  double quantidade = 0.0;

  ProdutoComponente(Produto p) {
    produto = p;
  }

  double get aquisicaoValorTotal {
    return  (produto.aquisicaoValorFrete + produto.aquisicaoValorSeguro + produto.aquisicaoValorCusto) * quantidade;
  }
}
