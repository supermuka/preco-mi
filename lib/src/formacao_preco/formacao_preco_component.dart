// Copyright (c) 2017, Administrador. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:chartjs/chartjs.dart';

import '../services/firebase_service.dart';

import 'formacao_preco_service.dart';
import '../model/resultado.dart';
import '../model/gasto_fixo.dart';
import '../model/produto.dart';
import '../model/produto_componente.dart';
import '../model/parametro.dart';
import '../model/familia.dart';

@Component(
  selector: 'precomi-formacaopreco',
  styleUrls: const ['formacao_preco_component.css'],
  templateUrl: 'formacao_preco_component.html',
  directives: const [
    CORE_DIRECTIVES,
    DeferredContentDirective,
    materialDirectives,
    materialInputDirectives,
    materialNumberInputDirectives,
    MaterialExpansionPanelSet,
    MaterialExpansionPanel,
    MaterialDropdownSelectComponent,
    MaterialSelectComponent,
    MaterialSelectItemComponent,
    MaterialRadioComponent,
    MaterialRadioGroupComponent,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialCheckboxComponent,
    MaterialAutoSuggestInputComponent,
  ],
  providers: const [FormacaoPrecoService, Resultado],
)

class FormacaoPrecoComponent implements OnInit {

  String tst;

  List<String> changeLog = [];

  List<String> items = [];

  String pesquisaProduto = "";
  Parametro parametro;
  Resultado resultado;
  List<Familia> familias;
  List<GastoFixo> gastosFixos;
  List<ProdutoViewModel> produtos;

  FormacaoPrecoComponent()  {
    familias = new List();
    parametro = new Parametro();
    resultado = new Resultado(null);
    gastosFixos = new List();

//    gastosFixos.add(new GastoFixo());

    produtos = new List();
 //   produtos.add(new ProdutoViewModel());


  }

  num get gastoFixoMensal2 {
    num valorGastosFixos = 0;



    for (GastoFixo gf in gastosFixos) {
      if (gf.valor != null)
        valorGastosFixos = valorGastosFixos + gf.valor;
    }
    return valorGastosFixos;
  }

  double get gastoFixoMensal {
    double valorGastosFixos = 0.0;

    if (gastosFixos != null) {
      for (int i = 0; i < gastosFixos.length; i++) {
        if (gastosFixos[i].valor != null && !gastosFixos[i].deletado)
          valorGastosFixos = valorGastosFixos + gastosFixos[i].valor;
      }
    }
    return valorGastosFixos;
  }


/*
  num gastoFixoMensal2(List<GastoFixoViewModel> listfg) {
    num valorGastosFixos = 0;

    for (GastoFixoViewModel gf in listfg) {
      if (gf.gastoFixo.valor != null)
        valorGastosFixos = valorGastosFixos + gf.gastoFixo.valor;
    }
    return valorGastosFixos;
  }
  */

  @override
  ngOnInit() async  {
    parametro = await FirebaseService.recuperarParametro();

    List f = await FirebaseService.recuperarFamilia();
    if (f != null) {
      f.forEach((i){ familias.add(i); });
    }

    List g = await FirebaseService.recuperarGastoFixo();
    if (g != null) {
      g.forEach((i){ gastosFixos.add(i); });
    }

    resultado = await FirebaseService.recuperarResultado(gastosFixos);

    List p = await FirebaseService.recuperarProduto();
    if (p != null) {
      p.forEach((i){ produtos.add(new ProdutoViewModel(i, this)); });
    }

   grafico();
  }


  String remove(int index) => items.removeAt(index);

  void onReorder(ReorderEvent e) =>
      items.insert(e.destIndex, items.removeAt(e.sourceIndex));

  void salvar() {
    FirebaseService.salvarParametro(parametro);
    FirebaseService.salvarResultado(resultado);

    for(GastoFixo gf in gastosFixos) {
      FirebaseService.salvarGastoFixo(gf);
    }

    for(ProdutoViewModel p in produtos) {
      FirebaseService.salvarProduto(p.produto);
    }
  }

  void adicionarGastoFixo() {
    gastosFixos.insert(0, new GastoFixo());
  }

  List retornarGastosFixos(){
    return gastosFixos.where((i) => !i.deletado).toList();
  }

  List<ProdutoViewModel> retornarProdutos(){
    return produtos.where((i) => (!i.produto.deletado)).toList();
  }

  List<ProdutoViewModel> retornarProdutosFiltro(){
    return produtos.where((i) => (!i.produto.deletado && (pesquisaProduto.trim().length == 0 || i.produto.descricao == null || i.produto.descricao.contains(pesquisaProduto)))).toList();
  }

  List<ProdutoComponente> retornarProdutosCompostos(int i) {
    return produtos[i].produto.produtosComponente.where((ii) => !ii.deletado).toList();
  }


/*
  void calcularAquisicaoValorTotal(int i, int ii) {
    ProdutoViewModel produtoVM = retornarProdutos()[i];
    List<ProdutoComponente> produtosComponentes = retornarProdutosCompostos(i);
    ProdutoComponente pc = produtosComponentes[ii];

    pc.aquisicaoValorTotal = (pc.produto.aquisicaoValorFrete + pc.produto.aquisicaoValorSeguro + pc.produto.aquisicaoValorCusto) * pc.quantidade;

    num aquisicaoTotal = 0;
    for(int i = 0;i<produtosComponentes.length;i++) {
      aquisicaoTotal = aquisicaoTotal + produtosComponentes[i].aquisicaoValorTotal;
    }

    produtoVM.produto.aquisicaoValorCusto = aquisicaoTotal;
  }
  */

  void excluirGastoFixo(int i) {
    //gastosFixos.removeAt(i);
    retornarGastosFixos()[i].deletado = true;
   // calcularGastoFixo();
  }

  void adicionarProduto() {
  //  produtos.add(new ProdutoViewModel(new Produto(), this));

    produtos.insert(0, new ProdutoViewModel(new Produto(), this));
  }

  void adicionarProdutoComponente(int i) {
    if (produtos != null && produtos[i] != null && produtos[i].produto != null && produtos[i].produto.produtosComponente != null && produtos[i].produtoComponenteSelectModel != null && produtos[i].produtoComponenteSelectModel.selectedValues != null && produtos[i].produtoComponenteSelectModel.selectedValues.length > 0)
    produtos[i].produto.produtosComponente.add(new ProdutoComponente(produtos[i].produtoComponenteSelectModel.selectedValues.first.produto));

  }

  desabilitarAdicionarProdutoComponente(int i) {
    if (produtos != null && produtos[i] != null && produtos[i].produto != null && produtos[i].produto.produtosComponente != null && produtos[i].produtoComponenteSelectModel != null && produtos[i].produtoComponenteSelectModel.selectedValues != null && produtos[i].produtoComponenteSelectModel.selectedValues.length > 0 && produtos[i].produto != produtos[i].produtoComponenteSelectModel.selectedValues.first.produto ) {
      bool b = false;
      produtos[i].produto.produtosComponente.forEach((f) {
        if (f.produto == produtos[i].produtoComponenteSelectModel.selectedValues.first.produto) {
          b = true;
        }
      });

      return b;
    } else {
      return true;
    }
  }

  void excluirProduto(int i) {
    retornarProdutos()[i].produto.deletado = true;
    //produtos.removeAt(i);
  }

  void excluirProdutoComponente(int i, int ii) {

    retornarProdutosCompostos(i)[ii].deletado = true;
    //produtos.removeAt(i);
  }

/*
  calcularGastoFixo() async {
    num valorGastosFixos = 0;

    for (GastoFixoViewModel gf in gastosFixos) {
      if (gf.valor != null)
         valorGastosFixos = valorGastosFixos + gf.valor;
    }
    resultado.gastoFixoMensal = valorGastosFixos;
  }
  */

  void calcularPrecoSugerido(int i) {
    produtos[i].produto.ofertaValorPrecoSugerido = ((produtos[i].produto.aquisicaoValorCusto *
        (1 - (produtos[i].produto.aquisicaoPercIcms / 100 + produtos[i].produto.aquisicaoPercIpi / 100)) +
        produtos[i].produto.aquisicaoValorSeguro + produtos[i].produto.aquisicaoValorFrete) /
        (1 - (produtos[i].produto.ofertaPercIcms / 100 + produtos[i].produto.ofertaPercIpi / 100 +
            produtos[i].produto.ofertaPercIss / 100 +
            produtos[i].produto.ofertaPercSimples / 100 + produtos[i].produto.ofertaPercMargemContribuicao / 100 + produtos[i].produto.ofertaPercComissao / 100)));
    copiarPrecoSugerido(i);
  }
/*
  void calcularFaturamentoMensalEstimado() {
    num faturamentoMensalEstimadoCalculado = 0;
    num valorMargemContribuicaoTotal = 0;
    for (int i = 0; i < produtos.length; i++) {
      if ((produtos[i].produto.ofertaVolumeEstimado != null) && (produtos[i].produto.ofertaValorPreco != null)) {
        faturamentoMensalEstimadoCalculado =
            faturamentoMensalEstimadoCalculado + produtos[i].produto.ofertaVolumeEstimado * produtos[i].produto.ofertaValorPreco;
      }
      if ((produtos[i].produto.ofertaVolumeEstimado != null) && (produtos[i].produto.ofertaValorPreco != null) && (produtos[i].produto.ofertaPercMargemContribuicao != null)) {
        valorMargemContribuicaoTotal = valorMargemContribuicaoTotal + produtos[i].produto.ofertaVolumeEstimado * produtos[i].produto.ofertaValorPreco / 100 * produtos[i].produto.ofertaPercMargemContribuicao;
      }
    }
    resultado.faturamentoMensalEstimado = faturamentoMensalEstimadoCalculado;
    resultado.valorMargemContribuicaoTotal = valorMargemContribuicaoTotal;

  }
  */


  double get faturamentoMensalEstimado {
    num faturamentoMensalEstimadoCalculado = 0;
    num valorMargemContribuicaoTotal = 0;
    for (int i = 0; i < produtos.length; i++) {
      if ((produtos[i].produto.ofertaVolumeEstimado != null) && (produtos[i].produto.ofertaValorPreco != null)) {
        faturamentoMensalEstimadoCalculado =
            faturamentoMensalEstimadoCalculado + produtos[i].produto.ofertaVolumeEstimado * produtos[i].produto.ofertaValorPreco;
      }
      if ((produtos[i].produto.ofertaVolumeEstimado != null) && (produtos[i].produto.ofertaValorPreco != null) && (produtos[i].produto.ofertaPercMargemContribuicao != null)) {
        valorMargemContribuicaoTotal = valorMargemContribuicaoTotal + produtos[i].produto.ofertaVolumeEstimado * produtos[i].produto.ofertaValorPreco / 100 * produtos[i].produto.ofertaPercMargemContribuicao;
      }
    }

    return faturamentoMensalEstimadoCalculado;

    //resultado.faturamentoMensalEstimado = faturamentoMensalEstimadoCalculado;
   // resultado.valorMargemContribuicaoTotal = valorMargemContribuicaoTotal;

  }

  void calcularGastoVariavelMensalEstimado() {
    num gastoVariavelMensalEstimadoCalculado = 0;
    for (int i = 0; i < produtos.length; i++) {
      if ((produtos[i].produto.ofertaVolumeEstimado != null) && (produtos[i].produto.aquisicaoValorCusto != null)) {
        gastoVariavelMensalEstimadoCalculado =
            gastoVariavelMensalEstimadoCalculado + produtos[i].produto.ofertaVolumeEstimado *
                    produtos[i].produto.aquisicaoValorCusto;
      }
    }
    resultado.gastoVariavelMensalEstimado = gastoVariavelMensalEstimadoCalculado;
  }

  void calcularReceitaGastoVarialvelMensalEstimado() {
   // calcularFaturamentoMensalEstimado();
    calcularGastoVariavelMensalEstimado();
  }

  void copiarPrecoSugerido(int i) {
    if (produtos[i].copiaPrecoSugerido) {
      produtos[i].produto.ofertaValorPreco = produtos[i].produto.ofertaValorPrecoSugerido;
    }
  }


  //
  grafico() async {

    List receita = new List();
    List gastoVariavel = new List();
    List gastoFixo = new List();
    List gastoTotal = new List();
    List quantidade = new List();

    double gastoFixoTotal = 0.0;
    List gf = retornarGastosFixos();
    if (gf?.length > 0) {
      for (int i=0;i<gf.length;i++) {
        gastoFixoTotal = gastoFixoTotal + gf[i].valor;
      }
    }

    List p = retornarProdutos();

    if (p != null && p.length > 0) {

      double ofertaValorPrecoTotal = 0.0, aquisicaoValorTotal = 0.0;
      for (int i = 0;i<p.length;i++) {
        if (p[i].produto.ofertaValorPreco != null) {
          ofertaValorPrecoTotal = ofertaValorPrecoTotal + p[i].produto.ofertaValorPreco;
        }

        if (p[i].produto.ehComposto) {
          aquisicaoValorTotal = aquisicaoValorTotal + p[i].produto.aquisicaoComponentesValorTotal;
        } else {
          if (p[i].produto.aquisicaoValorCusto != null) {
            aquisicaoValorTotal = aquisicaoValorTotal + p[i].produto.aquisicaoValorCusto;
          }
          if (p[i].produto.aquisicaoValorSeguro != null) {
            aquisicaoValorTotal = aquisicaoValorTotal + p[i].produto.aquisicaoValorSeguro;
          }
          if (p[i].produto.aquisicaoValorFrete != null) {
            aquisicaoValorTotal = aquisicaoValorTotal + p[i].produto.aquisicaoValorFrete;
          }
        }
      }

      for (int i = 0;i<1000;i+=100) {
        quantidade.add(i);
        receita.add(i * ofertaValorPrecoTotal);
        gastoVariavel.add(i * aquisicaoValorTotal);
        gastoFixo.add(gastoFixoTotal);
        gastoTotal.add(gastoFixoTotal + (i * aquisicaoValorTotal));

      }

    }

    List<String> rotulo = new List();

    quantidade.forEach((f) => rotulo.add(f.toString()));

    var data = new LinearChartData(labels: rotulo , datasets: <ChartDataSets>[
      new ChartDataSets(
          label: "Custo Fixo",
          backgroundColor: "rgba(192,192,192,0.2)",
          data: gastoFixo),
      //data: months.map((_) => rnd.nextInt(100)).toList()),
      new ChartDataSets(
          label: "Custo Variável",
          backgroundColor: "rgba(128,128,128,0.2)",
          //data: months.map((_) => rnd.nextInt(100)).toList())
          data: gastoVariavel),
      new ChartDataSets(
          label: "Custo Total",
          backgroundColor: "rgba(128,0,0,0.2)",
          //data: months.map((_) => rnd.nextInt(100)).toList())
          data: gastoTotal),
      new ChartDataSets(
          label: "Receita",
          backgroundColor: "rgba(0,128,0,0.2)",
          //data: months.map((_) => rnd.nextInt(100)).toList())
          data: receita)
    ]);

    var config = new ChartConfiguration(
        type: 'line',
        data: data,
        options: new ChartOptions(responsive: true));

    new Chart(querySelector('#canvas') as CanvasElement, config);
  }
}

//
class ProdutoViewModel {

  static const List<String> unidadesProduto = const ['Unitário', 'Kg', 'Litro', 'Metro', 'Hora'];

  final SelectionModel<String> unidadesProdutoModel = new SelectionModel<String>.withList(selectedValues: [unidadesProduto[1]]);
  //final SelectionModel<String> unidadesProdutoSelection = new SelectionModel<String>.withList();
  final StringSelectionOptions unidadesProdutoOptions = new StringSelectionOptions<String>(unidadesProduto);

  bool detalhe = false;
  bool copiaPrecoSugerido = true;

  Produto produto;
  static FormacaoPrecoComponent pai;

  SelectionModel familiaSelectModel ;

  ProdutoViewModel(Produto p, FormacaoPrecoComponent componentePai) {
    produto = p;
    familiaSelectModel = new SelectionModel.withList(selectedValues: [produto.familia]);
    pai = componentePai;
  }

  String get selecioneUnidadeLabel {
    if (unidadesProdutoModel.selectedValues.length > 0) {
      produto.unidade = unidadesProdutoModel.selectedValues.first;
      return unidadesProdutoModel.selectedValues.first;
    } else {
      return 'Selecione a Unidade';
    }
  }

  String get unidadeSelecionada =>
      unidadesProdutoModel.selectedValues.isNotEmpty
          ? unidadesProdutoModel.selectedValues.first
          : null;

  String inputText = '';

  bool useLabelRenderer = false;

  SelectionModel produtoComponenteSelectModel = new SelectionModel.withList(selectedValues: [null]);


  SelectionOptions produtoComponenteOptionsf() {
    if ((pai != null) && (pai.produtos != null) && (pai.produtos.length > 0))
      return new SelectionOptions.fromList(pai.produtos.where((e) => !e.produto.deletado).toList());

    else
      return new SelectionOptions(null);
  }
  ItemRenderer get itemRenderer => (ProdutoViewModel item) => item.produto.descricao;

  //SelectionModel familiaSelectModel = new SelectionModel.withList(selectedValues: [null]);

 // SelectionModel get familiaSelectModel {
 //   return new SelectionModel.withList(selectedValues: [produto.familia]);

 // }

  SelectionOptions get familiaOptions {
    if ((pai != null) && (pai.familias != null) && (pai.familias.length > 0))
      return new SelectionOptions.fromList(pai.familias.where((e) => !e.deletado).toList());
    else
      return new SelectionOptions(null);
  }

  ItemRenderer get familiaItemRenderer => (Familia item) => item.descricao;


  String get singleSelectFamiliaLabel {
    if ((familiaSelectModel != null) &&
        (familiaSelectModel.selectedValues != null) &&
        (familiaSelectModel.selectedValues.length > 0)) {
      produto.familia = familiaSelectModel.selectedValues.first;
      return familiaSelectModel.selectedValues.first.descricao;
    } else {
      produto.familia = null;
      return 'Selecione Entidade';
    }
  }


}
