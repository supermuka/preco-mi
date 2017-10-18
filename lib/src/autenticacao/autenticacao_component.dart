import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'autenticacao_service.dart';

@Component(
  selector: 'precomi-autenticacao',
  styleUrls: const ['autenticacao_component.css'],
  templateUrl: 'autenticacao_component.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
    MaterialInputComponent,
  ],
  providers: const [materialProviders, AutenticacaoService],
)

class AutenticacaoComponent implements OnInit {

  String eMail = "samuel.schwebel@gmail.com";
  String senha = "123456";
  String erro;

  @override
  ngOnInit() {
    // AutenticacaoService.inicializarFireBase();

  }

  entrarAutenticacao(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {

        AutenticacaoService.autenticarComEmail(email, password);

        erro = AutenticacaoService.erro;

    } else {
      erro = "Por favor preencha corretamente o email e senha.";
    }
  }
}