// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:intl/intl.dart';
import 'src/autenticacao/autenticacao_component.dart';
import 'src/autenticacao/autenticacao_service.dart';
import 'src/entidade/entidade_component.dart';
import 'src/formacao_preco/formacao_preco_component.dart';
import 'src/familia/familia_component.dart';
import 'src/painel/painel_component.dart';
import 'src/lista_produto_preco/lista_produto_preco_component.dart';
import 'src/ponto_equilibrio/ponto_equilibrio_component.dart';

@Component(
    selector: 'precomi-app-component',
    providers: const <dynamic>[materialProviders, AutenticacaoService],
    directives: const [
      CORE_DIRECTIVES,
      DeferredContentDirective,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialTemporaryDrawerComponent,
      MaterialToggleComponent,
      MaterialDropdownSelectComponent,
      MaterialListComponent,
      MaterialListItemComponent,
      EntidadeComponent,
      AutenticacaoComponent,
      FormacaoPrecoComponent,
      FamiliaComponent,
      PainelComponent,
      ListaProdutoPrecoComponent,
      PontoEquilibrioComponent,
    ],
    templateUrl: 'app_component.html',
    styleUrls: const [
      'app_component.css',
      'package:angular_components/app_layout/layout.scss.css',
    ])

class AppComponent implements OnInit {

  String opcaoMenuAtual;

  bool detalhe = false;
  bool copiaPrecoSugerido = true;

  AppComponent() {
    Intl.defaultLocale = 'pt_BR';
  }

  void definirOpcaoMenu(String om) {
    opcaoMenuAtual = om;
  }

  get opcaoMenuAtualDescricao {
    String omad;
    if (opcaoMenuAtual == 'FORMACAO_PRECO_VENDA')
      omad = 'Formação de Preço de Venda';
    else if (opcaoMenuAtual == 'FAMILIA')
      omad = 'Família';
    else if (opcaoMenuAtual == 'LISTA_PRODUTO_PRECO')
      omad = 'Lista de Produto e Preço';
    else if (opcaoMenuAtual == 'PONTO_EQUILIBRIO')
      omad = 'Análise de Ponto de Equilíbrio';
    else if (opcaoMenuAtual == 'EMPRESA')
      omad = 'Empresa';
    else if (opcaoMenuAtual == 'USUARIO')
      omad = 'Usuário';
    return omad;

  }

  bool estahAutenticado() {

    if (!AutenticacaoService.autenticado) {
      opcaoMenuAtual = null;

    }
    return AutenticacaoService.autenticado;
  }

  void sairAutenticado() {
    return AutenticacaoService.sairAutenticacao();
  }

  @override
  ngOnInit() {

    AutenticacaoService.inicializarFireBase();

  }
}