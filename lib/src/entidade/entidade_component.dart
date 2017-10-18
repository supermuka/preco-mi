// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import '../../src/autenticacao/autenticacao_service.dart';
import 'package:firebase/firebase.dart' as fb;

import 'entidade_service.dart';

@Component(
    selector: 'precomi-entidade',
    providers: const <dynamic>[materialProviders, AutenticacaoService],
    directives: const [
      CORE_DIRECTIVES,
      DeferredContentDirective,
      MaterialDropdownSelectComponent,
      MaterialSelectDropdownItemComponent,
      MaterialSelectComponent,
    ],
    templateUrl: 'entidade_component.html',
    styleUrls: const [
      'entidade_component.css'
    ])

class EntidadeComponent implements OnInit {

  //static List entidades =  [ new Entidade(1, 'Levius'), new Entidade(2, 'Apis')];
  List entidades = new List();
  SelectionOptions entidadeOptions;
  SelectionModel entidadeSingleSelectModel;

  String teste;


  @override
  ngOnInit() async {
    //entidades =  [ new Entidade(1, 'Levius.'), new Entidade(2, 'Apis'.)];

     await fb.database().ref('entidade').once("value").then((e)
     {
        fb.DataSnapshot datasnapshot = e.snapshot;
           datasnapshot.forEach((e) {
             entidades.add(new Entidade(e.val()["codigo"], e.val()["nome"]));
      });

//    await fb.database()
//        .ref('entidade')
 //       .onValue
 //       .listen((e) {
//      fb.DataSnapshot datasnapshot = e.snapshot;

  //    datasnapshot.forEach((e) {
  //      entidades.add(new Entidade(e.val()["codigo"], e.val()["nome"]));
  //    });


      entidadeOptions = new SelectionOptions.fromList(entidades);
      entidadeSingleSelectModel = new SelectionModel.withList(selectedValues: [entidades[0]]);
      EntidadeService.entidadeCodigo = entidadeSingleSelectModel.selectedValues.first.codigo;

    });
  }

  @override
  OnDestroy() {


  }

  //static const List entidades = const [ const Entidade(1, 'Levius'), const Entidade(2, 'Apis')];

// Single Selection Model.
  // SelectionModel singleSelectModel = new SelectionModel.withList(selectedValues: [entidades[1]]);

  //final SelectionOptions entidadeOptions = new SelectionOptions.fromList(entidades);


  //ItemRenderer get itemRenderer => singleSelectModel.selectedValues.first['nome'];
  //ItemRenderer get itemRenderer => (HasUIDisplayName item) => item.uiDisplayName;

  ItemRenderer get itemRenderer => (HasUIDisplayName item) => item.uiDisplayName;

  //ItemRenderer get itemRenderer => (Map item) => item["nome"];

// Label for the button for single selection.
  String get singleSelectEntidadeLabel {
    if ((entidadeSingleSelectModel != null) &&
        (entidadeSingleSelectModel.selectedValues != null) &&
        (entidadeSingleSelectModel.selectedValues.length > 0)) {
      EntidadeService.entidadeCodigo =
          entidadeSingleSelectModel.selectedValues.first.codigo;
      return entidadeSingleSelectModel.selectedValues.first.nome;
    } else {
      EntidadeService.entidadeCodigo = null;
      return 'Selecione Entidade';
    }
  }

}

class Entidade implements HasUIDisplayName {
  final int codigo;
  final String nome;

  const Entidade(this.codigo, this.nome);

  @override
  String get uiDisplayName => nome;

  @override
  String toString() => uiDisplayName;
}