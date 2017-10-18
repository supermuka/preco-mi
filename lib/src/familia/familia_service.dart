import 'dart:async';

import 'package:firebase/firebase.dart' as fb;
import '../../src/entidade/entidade_service.dart';
import '../model/familia.dart';

class FamiliaService {

  static Future<List<Familia>> recuperarFamilias() async {
    String path = '${EntidadeService.entidadeCodigo}/familia';
    List<Familia> domain;

    await fb.database().ref(path).once("value").then((e) {
      fb.DataSnapshot datasnapshot = e.snapshot;


      //  (domain as List).clear();
      if (datasnapshot.exists()) {
        domain = new List();
        datasnapshot.forEach((e) {
          domain.add(new Familia()
            ..chave = e.key
            ..descricao = e.val()["descricao"]);
        });
      }

    });
    return domain;
  }

  static void salvarFamilia(Familia domain)  {

    fb.DatabaseReference dr =    fb.database().ref('${EntidadeService.entidadeCodigo}/familia');

    if ((domain.deletado) && (domain.chave != null) && (domain.chave.trim().length > 0)) {
      dr.child('${domain.chave}').remove();
    } else {
      if (domain.chave == null || domain.chave.trim().length == 0) {
        domain.chave =  dr.push().key;
      }

       dr.child('${domain.chave}/descricao').set(domain.descricao);

    }
  }

}

