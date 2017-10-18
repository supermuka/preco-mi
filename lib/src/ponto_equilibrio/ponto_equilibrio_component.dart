// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math' as math;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:chartjs/chartjs.dart';

import '../services/firebase_service.dart';
import '../model/produto.dart';
import '../model/gasto_fixo.dart';

@Component(
    selector: 'precomi-ponto-equilibrio',
    providers: const <dynamic>[materialProviders],
    directives: const [
      CORE_DIRECTIVES,
      DeferredContentDirective,
      ScoreboardComponent,
      ScorecardComponent,
      MaterialRadioGroupComponent,
      MaterialRadioComponent,

    ],
    templateUrl: 'ponto_equilibrio_component.html',
    styleUrls: const [
      'ponto_equilibrio_component.css'
    ])

class PontoEquilibrioComponent implements OnInit {

  String analise;

  @override
  ngOnInit() async {
    grafico();
  }

  grafico() async {

    List receita = new List();
    List gastoVariavel = new List();
    List gastoFixo = new List();
    List gastoTotal = new List();
    List quantidade = new List();

    List<GastoFixo> gastosFixos = await FirebaseService.recuperarGastoFixo();

    double gastoFixoTotal = 0.0;
    if (gastosFixos?.length > 0) {
      for (int i=0;i<gastosFixos.length;i++) {
        gastoFixoTotal = gastoFixoTotal + gastosFixos[i].valor;
      }
    }

    List<Produto> produtos = await FirebaseService.recuperarProduto();

    if (produtos?.length > 0) {

      double ofertaValorPrecoTotal = 0.0, aquisicaoValorTotal = 0.0;
      for (int i = 0;i<produtos.length;i++) {
        if (produtos[i].ofertaValorPreco != null) {
          ofertaValorPrecoTotal = ofertaValorPrecoTotal + produtos[i].ofertaValorPreco;
        }

        if (produtos[i].ehComposto) {
          aquisicaoValorTotal = aquisicaoValorTotal + produtos[i].aquisicaoComponentesValorTotal;
        } else {
          if (produtos[i].aquisicaoValorCusto != null) {
            aquisicaoValorTotal = aquisicaoValorTotal + produtos[i].aquisicaoValorCusto;
          }
          if (produtos[i].aquisicaoValorSeguro != null) {
            aquisicaoValorTotal = aquisicaoValorTotal + produtos[i].aquisicaoValorSeguro;
          }
          if (produtos[i].aquisicaoValorFrete != null) {
            aquisicaoValorTotal = aquisicaoValorTotal + produtos[i].aquisicaoValorFrete;
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