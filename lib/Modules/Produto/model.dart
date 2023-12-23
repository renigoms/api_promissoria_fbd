import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class Produto {
  int?id;
  String ? nome, unid_medida;
  double ? valor_unit, porc_lucro;

  Produto({
    this.id,
    required this.nome,
    required this.unid_medida,
    required this.valor_unit,
    required this.porc_lucro
  });

  factory Produto.byMap(Map map){

    double ? valor_unit, porc_lucro;
    if (map['valor_unit'] is String) {
      valor_unit = map['valor_unit']!=null?
                        double.parse(map['valor_unit']):map['valor_unit'];
    } else {
      valor_unit = map['valor_unit'];
    }
    if (map['porc_lucro'] is String) {
      porc_lucro = map['porc_lucro']!=null?
                  double.parse(map['porc_lucro']):map['porc_lucro'];
    } else {
      porc_lucro = map['porc_lucro'];
    }


    return UtilsGeral.isKeysExists(SQLGeral.id, map) ?
    Produto(
        id: map['id'],
        nome: map['nome'],
        unid_medida: map['unid_medida'],
        valor_unit: valor_unit,
        porc_lucro: porc_lucro
    ) :
    Produto(
        nome: map['nome'],
        unid_medida: map['unid_medida'],
        valor_unit: valor_unit,
        porc_lucro: porc_lucro
    );
  }

  Map<String, dynamic> toMap ()=> {
    "id":id,
    "nome":nome,
    "unid_medida":unid_medida,
    "valor_unit":valor_unit,
    "porc_lucro":porc_lucro
  };
}