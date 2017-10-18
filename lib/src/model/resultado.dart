import 'package:angular/core.dart';
import 'gasto_fixo.dart';

@Injectable()
class Resultado {

  List<GastoFixo> gastosFixos;

  double faturamentoAnual = 0.0;
  double faturamentoMensalEstimado = 0.0;
  double valorMargemContribuicaoTotal = 0.0;


  double gastoVariavelMensalEstimado = 0.0;

  Resultado(List<GastoFixo> gastosFixos) {
    this.gastosFixos = gastosFixos;
  }
}