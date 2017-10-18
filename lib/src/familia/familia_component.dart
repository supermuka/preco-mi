// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:firebase/firebase.dart' as fb;

import 'familia_service.dart';
import '../model/familia.dart';

@Component(
    selector: 'precomi-familia',
    providers: const <dynamic>[materialProviders],
    directives: const [
      CORE_DIRECTIVES,
      materialDirectives,
      MaterialInputComponent,
      MaterialFabComponent,
      MaterialButtonComponent,
      MaterialIconComponent,

    ],
    templateUrl: 'familia_component.html',
    styleUrls: const [
      'familia_component.css'
    ])

class FamiliaComponent implements OnInit {

  //static List entidades =  [ new Entidade(1, 'Levius'), new Entidade(2, 'Apis')];

  List<Familia> familias = new List();

  @override
  ngOnInit() async {

    //familias.addAll(await FamiliaService.recuperarFamilias());

    familias = await FamiliaService.recuperarFamilias();

  }

  @override
  OnDestroy() {

  }

  salvarFamilia()  {
    for(Familia fa in familias) {
       FamiliaService.salvarFamilia(fa);
    }
  }

  List<Familia> retornarFamilias(){
    return familias.where((i) => !i.deletado).toList();
   // return familias;
  }

  void excluirFamilia(int i) {
    retornarFamilias()[i].deletado = true;
  }

  void adicionarFamilia() {
    familias.add(new Familia());
  }

}
