import 'dart:async';

import 'package:angular/core.dart';
import 'package:firebase/firebase.dart' as fb;

import '../entidade/entidade_service.dart';
import '../model/resultado.dart';
import '../model/gasto_fixo.dart';
import '../model/produto.dart';
import '../model/produto_componente.dart';
import '../model/parametro.dart';
import '../model/familia.dart';

@Injectable()
class FirebaseService {

  FirebaseService() {
    fb.initializeApp(
        apiKey: "",
        authDomain: "",
        databaseURL: "",
        storageBucket: ""
    );
  }

  entrarAutenticacao(email, password) {
    fb.auth().signInWithEmailAndPassword(email, password);
  }

  sairAutenticacao() {
    fb.auth().signOut();
  }

  static void salvarParametro(Parametro domain) {
    fb.DatabaseReference dr = fb.database().ref(
        '${EntidadeService.entidadeCodigo}/parametro');
    dr.child('atividadePrincipal').set(domain.atividadePrincipal);
    dr.child('formaTributacao').set(domain.formaTributacao);
  }

  static void salvarResultado(Resultado domain) {
    fb.DatabaseReference dr = fb.database().ref(
        '${EntidadeService.entidadeCodigo}/resultado');
    dr.child('faturamentoAnual').set(domain.faturamentoAnual);
    dr.child('faturamentoMensalEstimado').set(  domain.faturamentoMensalEstimado);
    //   dr.child('gastoFixoMensal').set(domain.gastoFixoMensal);
    dr.child('gastoVariavelMensalEstimado').set(domain.gastoVariavelMensalEstimado);
    dr.child('valorMargemContribuicaoTotal').set(domain.valorMargemContribuicaoTotal);
  }

  static void salvarGastoFixo(GastoFixo domain) {
    String path = '${EntidadeService.entidadeCodigo}/gasto';

    fb.DatabaseReference dr = fb.database().ref(path);

    if ((domain.deletado) && (domain.chave != null)) {
      dr.child('${domain.chave}').remove();
    } else {
      if (domain.chave == null) {
        domain.chave = dr
            .push()
            .key;
      }
      dr.child('${domain.chave}/descricao').set(domain.descricao);
      dr.child('${domain.chave}/valor').set(domain.valor);
    }
  }

  static void salvarProduto(Produto domain) {

    String path = '${EntidadeService.entidadeCodigo}/produto/';

    fb.DatabaseReference dr = fb.database().ref(path);

    if ((domain.deletado) && (domain.chave != null)) {
      dr.child('${domain.chave}').remove();
    } else {
      if (domain.chave == null) {
        domain.chave = dr
            .push()
            .key;
      }
      dr.child('${domain.chave}/codigo').set(domain.codigo);
      dr.child('${domain.chave}/descricao').set(domain.descricao);

      dr.child('${domain.chave}/unidade').set(domain.unidade);
      dr.child('${domain.chave}/ofertaValorPrecoSugerido').set(domain.ofertaValorPrecoSugerido);
      dr.child('${domain.chave}/ofertaValorPreco').set(domain.ofertaValorPreco);
      dr.child('${domain.chave}/ofertaPercSimples').set(domain.ofertaPercSimples);
      dr.child('${domain.chave}/ofertaPercIss').set(domain.ofertaPercIss);
      dr.child('${domain.chave}/ofertaPercIpi').set(domain.ofertaPercIpi);
      dr.child('${domain.chave}/ofertaPercIcms').set(domain.ofertaPercIcms);
      dr.child('${domain.chave}/ofertaPercMargemContribuicao').set(domain.ofertaPercMargemContribuicao);
      dr.child('${domain.chave}/ofertaPercComissao').set(domain.ofertaPercComissao);
      dr.child('${domain.chave}/ofertaPercMargemContribuicaoReal').set(domain.ofertaPercMargemContribuicaoReal);
      dr.child('${domain.chave}/ofertaVolumeEstimado').set(domain.ofertaVolumeEstimado);
      dr.child('${domain.chave}/tipo').set(domain.tipo);
      dr.child('${domain.chave}/aquisicaoValorFrete').set(domain.aquisicaoValorFrete);
      dr.child('${domain.chave}/aquisicaoValorSeguro').set(domain.aquisicaoValorSeguro);
      dr.child('${domain.chave}/aquisicaoPercIpi').set(domain.aquisicaoPercIpi);
      dr.child('${domain.chave}/aquisicaoPercIcms').set(domain.aquisicaoPercIcms);
      dr.child('${domain.chave}/aquisicaoValorCusto').set(domain.aquisicaoValorCusto);
      dr.child('${domain.chave}/ehComposto').set(domain.ehComposto);
      dr.child('${domain.chave}/familia').set(domain?.familia?.chave);

      if ((domain.ehComposto) && (domain.produtosComponente.length > 0)) {

        for (int i_pc = 0;i_pc <domain.produtosComponente.length;i_pc++)

          if ((domain.produtosComponente[i_pc].deletado) && (domain.produtosComponente[i_pc].chave != null)) {
            dr.child('${domain.chave}/componente/${domain.produtosComponente[i_pc].chave}').remove();
          } else {
            if (domain.produtosComponente[i_pc].chave == null) {
              domain.produtosComponente[i_pc].chave = dr.child('${domain.chave}/componente')
                  .push()
                  .key;
            }

            dr.child('${domain.chave}/componente/${domain.produtosComponente[i_pc].chave}/quantidade').set(domain.produtosComponente[i_pc].quantidade);
            // dr.child('${domain.chave}/componente/${domain.produtosComponente[i_pc].chave}/aquisicaoValorTotal').set(domain.produtosComponente[i_pc].aquisicaoValorTotal);
            dr.child('${domain.chave}/componente/${domain.produtosComponente[i_pc].chave}/produto_chave').set(domain.produtosComponente[i_pc].produto.chave);

          }

      } else {

        dr.child('${domain.chave}/componentes').remove();

      }
    }
  }

  static Future<Parametro> recuperarParametro() async {

    String path = '${EntidadeService.entidadeCodigo}/parametro';

    Parametro domain = new Parametro();
    await fb.database().ref(path).once("value").then((e) {
      fb.DataSnapshot datasnapshot = e.snapshot;
      if (datasnapshot.exists()) {
        domain.atividadePrincipal = datasnapshot.val()["atividadePrincipal"];
        domain.formaTributacao = datasnapshot.val()["formaTributacao"];
      }
    });
    return domain;
  }

  static Future<Resultado> recuperarResultado(List<GastoFixo> gastosFixos) async {

    String path = '${EntidadeService.entidadeCodigo}/resultado';

    Resultado domain = new Resultado(gastosFixos);
    await fb.database().ref(path).once("value").then((e) {
      fb.DataSnapshot datasnapshot = e.snapshot;
      if (datasnapshot.exists()) {
        domain.valorMargemContribuicaoTotal = datasnapshot.val()["valorMargemContribuicaoTotal"];
        domain.gastoVariavelMensalEstimado = datasnapshot.val()["gastoVariavelMensalEstimado"];
        domain.faturamentoAnual = datasnapshot.val()["faturamentoAnual"];
        domain.faturamentoMensalEstimado = datasnapshot.val()["faturamentoMensalEstimado"];
        //domain.gastoFixoMensal = datasnapshot.val()["gastoFixoMensal"];
      }
    });
    return domain;
  }

  static Future<List<Familia>> recuperarFamilia() async {
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

  static Future<List<GastoFixo>> recuperarGastoFixo() async {
    String path = '${EntidadeService.entidadeCodigo}/gasto';
    List<GastoFixo> domain;
    await fb.database().ref(path).once("value").then((e) {
      fb.DataSnapshot datasnapshot = e.snapshot;


      //  (domain as List).clear();
      if (datasnapshot.exists()) {
        domain = new List();
        datasnapshot.forEach((e) {
          domain.add(new GastoFixo()
            ..chave = e.key
            ..descricao = e.val()["descricao"]
            ..valor = e.val()["valor"]);
        });
      }
    });
    return domain;
  }

  static Future<List<Produto>> recuperarProduto() async {

    List<Familia> familias = await recuperarFamilia();

    String path = '${EntidadeService.entidadeCodigo}/produto';
    List<Produto> domain;
    await fb.database().ref(path).once("value").then((e) {
      fb.DataSnapshot datasnapshot = e.snapshot;



      //  (domain as List).clear();
      if (datasnapshot.exists()) {



        domain = new List();
        datasnapshot.forEach((e) {
          domain.add(new Produto()
            ..chave = e.key
            ..codigo = e?.val()["codigo"]
            ..descricao = e.val()["descricao"]
            ..unidade = e.val()["unidade"]
            ..tipo = e.val()["tipo"]
            ..aquisicaoValorCusto = e.val()["aquisicaoValorCusto"]
            ..aquisicaoPercIcms = e.val()["aquisicaoPercIcms"]
            ..aquisicaoPercIpi = e.val()["aquisicaoPercIpi"]
            ..aquisicaoValorSeguro = e.val()["aquisicaoValorSeguro"]
            ..aquisicaoValorFrete = e.val()["aquisicaoValorFrete"]
            ..ofertaVolumeEstimado = e.val()["ofertaVolumeEstimado"]
            ..ofertaPercMargemContribuicaoReal = e
                .val()["ofertaPercMargemContribuicaoReal"]
            ..ofertaPercMargemContribuicao = e
                .val()["ofertaPercMargemContribuicao"]
            ..ofertaPercComissao = e.val()["ofertaPercComissao"]
            ..ofertaPercIcms = e.val()["ofertaPercIcms"]
            ..ofertaPercIpi = e.val()["ofertaPercIpi"]
            ..ofertaPercSimples = e.val()["ofertaPercSimples"]
            ..ofertaValorPreco = e.val()["ofertaValorPreco"]
            ..ofertaValorPrecoSugerido = e.val()["ofertaValorPrecoSugerido"]
            ..ehComposto = e.val()["ehComposto"]
            ..familia = familias != null && familias.length > 0 && e?.val()["familia_chave"] != null ? familias.singleWhere((s) => s?.chave ==  e.val()["familia_chave"]) : null);

          Map componente = e.val()["componente"];

          if (componente != null) {
            componente.forEach((ee, vv) {

              domain.last.produtosComponente.add(new ProdutoComponente(null)
                ..chave = ee
                ..produto_chave = vv["produto_chave"]
                ..quantidade = vv["quantidade"]);
              //..aquisicaoValorTotal = vv["aquisicaoValorTotal"]);

            });
          }

        });

        if (domain != null) {
          domain.forEach((p) {

            p.produtosComponente.forEach((pc) {
              pc.produto = domain.singleWhere((t) => (t.chave == pc.produto_chave));
            });
          });
        }

      }
    });

    return domain;
  }


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