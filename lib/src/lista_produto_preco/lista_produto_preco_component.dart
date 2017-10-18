// Copyright (c) 2017, Administrador. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'lista_produto_preco_service.dart';
import '../model/produto.dart';
import '../services/firebase_service.dart';


@Component(
  selector: 'precomi-lista_produto_preco',
  styleUrls: const ['lista_produto_preco_component.css'],
  templateUrl: 'lista_produto_preco_component.html',
  directives: const [
    CORE_DIRECTIVES,
    DeferredContentDirective,
    materialDirectives,
    MaterialExpansionPanel,
    MaterialInputComponent,
  ],
  providers: const [ListaProdutoPrecoService],
  pipes: const [COMMON_PIPES],
)

class ListaProdutoPrecoComponent implements OnInit {

  List<Produto> produtos;
  String pesquisaProduto = '';
  String ordem;



  @override
  ngOnInit() async  {

    produtos = await FirebaseService.recuperarProduto();

  }

  List<Produto> retornarProdutosFiltroOrdem() {
    if (produtos != null) {
      List<Produto> produtosFiltradosOrdenados =  produtos.where((i) => (!i.deletado && (pesquisaProduto.trim().length == 0 || i.descricao == null || i.descricao.contains(pesquisaProduto)))).toList();
      if (ordem == 'descricao')
         produtosFiltradosOrdenados.sort((a, b) => b.descricao != null ? a?.descricao?.compareTo(b.descricao) : null);
      else if (ordem == 'codigo')
        produtosFiltradosOrdenados.sort((a, b) => b.codigo != null ? a?.codigo?.compareTo(b?.codigo) : null);
      else if (ordem == 'preco')
        produtosFiltradosOrdenados.sort((a, b) => b.ofertaValorPreco != null ? a?.ofertaValorPreco?.compareTo(b?.ofertaValorPreco) : null);

      return produtosFiltradosOrdenados;
      return produtos.where((i) => (!i.deletado && (pesquisaProduto.trim().length == 0 || i.descricao == null || i.descricao.contains(pesquisaProduto)))).toList();
    }

  }


}
