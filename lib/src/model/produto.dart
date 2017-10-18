import 'produto_componente.dart';
import 'familia.dart';

class Produto {
  String chave;
  bool deletado = false;

  String codigo;
  String descricao;
  String unidade;
  String tipo;
  double aquisicaoValorCusto = 0.0;
  double aquisicaoPercIcms = 0.0;
  double aquisicaoPercIpi = 0.0;
  double aquisicaoValorFrete = 0.0;
  double aquisicaoValorSeguro = 0.0;
  double ofertaPercIcms = 0.0;
  double ofertaPercIpi = 0.0;
  double ofertaPercIss = 0.0;
  double ofertaPercSimples = 0.0;
  double ofertaPercComissao = 0.0;
  double ofertaPercMargemContribuicao = 0.0;
  double ofertaPercMargemContribuicaoReal = 0.0;
  double ofertaValorPrecoSugerido = 0.0;
  double ofertaValorPreco = 0.0;
  double ofertaVolumeEstimado = 0.0;

  List<ProdutoComponente> produtosComponente;
  bool ehComposto = false;
  Familia familia;

  Produto() {
    produtosComponente = new List();
  }

  double get aquisicaoComponentesValorTotal {

    double aquisicaoTotal = 0.0;
    for(int i = 0;i<produtosComponente.length;i++) {
      aquisicaoTotal = aquisicaoTotal + produtosComponente[i].aquisicaoValorTotal;
    }

    return aquisicaoTotal;

  }

  String get tipoDescricao {
    return tipo == 'B' ? 'Bem' : tipo == 'S' ? 'Serviço' : tipo == 'M' ? 'Mesclado' : '';
  }

}