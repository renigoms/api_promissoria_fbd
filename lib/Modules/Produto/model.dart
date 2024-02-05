// ignore_for_file: non_constant_identifier_names

import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class Produto {
  int? _id;
  String? _nome, _unid_medida;
  double? _valor_unit, _porc_lucro;

  Produto(
      {int? id,
      required String? nome,
      required String? unid_medida,
      required double? valor_unit,
      required double? porc_lucro}) {
    _id = id;
    _nome = nome;
    _unid_medida = unid_medida;
    _valor_unit = valor_unit;
    _porc_lucro = porc_lucro;
  }
  /// construtor que recebe um map
  factory Produto.byMap(Map map) {
    double? valor_unit, porc_lucro;
    if (map['valor_unit'] is String) {
      valor_unit = map['valor_unit'] != null
          ? double.parse(map['valor_unit'])
          : map['valor_unit'];
    } else {
      valor_unit = map['valor_unit'];
    }
    if (map['porc_lucro'] is String) {
      porc_lucro = map['porc_lucro'] != null
          ? double.parse(map['porc_lucro'])
          : map['porc_lucro'];
    } else {
      porc_lucro = map['porc_lucro'];
    }

    return UtilsGeral.isKeysExists(SQLGeral.ID, map)
        ? Produto(
            id: map['id'],
            nome: map['nome'],
            unid_medida: map['unid_medida'],
            valor_unit: valor_unit,
            porc_lucro: porc_lucro)
        : Produto(
            nome: map['nome'],
            unid_medida: map['unid_medida'],
            valor_unit: valor_unit,
            porc_lucro: porc_lucro);
  }

  /// Extrai o objeto em um map
  Map<String, dynamic> toMap() => {
        "id": _id,
        "nome": _nome,
        "unid_medida": _unid_medida,
        "valor_unit": _valor_unit,
        "porc_lucro": _porc_lucro
      };

  get porc_lucro => _porc_lucro;

  get valor_unit => _valor_unit;

  get unid_medida => _unid_medida;

  get nome => _nome;

  get id => _id;
}
