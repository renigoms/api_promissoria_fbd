import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class Produto {
  int?id;
  String nome, uni_med;
  double valor_unit, porc_lucro;

  Produto({
    this.id,
    required this.nome,
    required this.uni_med,
    required this.valor_unit,
    required this.porc_lucro
  });

  factory Produto.bymap(Map map){
    return UtilsGeral.isKeysExists(SQLGeral.id, map) ?
    Produto(
        id: map['id'],
        nome: map['nome'],
        uni_med: map['uni_med'],
        valor_unit: map['valor_unit'],
        porc_lucro: map['porc_lucro']
    ) :
    Produto(
        nome: map['nome'],
        uni_med: map['uni_med'],
        valor_unit: map['valor_unit'],
        porc_lucro: map['perc_lucro']
    );
  }

  Map<String, dynamic> toMap ()=> {
    "nome":nome,
    "uni_med":uni_med,
    "valor_unit":valor_unit,
    "porc_lucro":porc_lucro
  };
}