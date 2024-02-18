// ignore_for_file: non_constant_identifier_names

import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class Produto {
  int? _id;
  String? _nome, _unid_medida;
  double? _valor_unit, _porc_lucro;
  bool ? _ativo;

  Produto(
      {int? id,
      required String? nome,
      required String? unid_medida,
      required double? valor_unit,
      required double? porc_lucro,
      bool ? ativo}) {
    _id = id;
    _nome = nome;
    _unid_medida = unid_medida;
    _valor_unit = valor_unit;
    _porc_lucro = porc_lucro;
    _ativo = ativo;
  }
  /// construtor que recebe um map
  factory Produto.byMap(Map map) {
    double? valor_unit, porc_lucro;

    valor_unit = map['valor_unit'] is String ?
    double.parse(map['valor_unit']) : valor_unit = map['valor_unit'];

    porc_lucro = map['porc_lucro'] is String ? double.parse(map['porc_lucro']):
    porc_lucro = map['porc_lucro'];

    return UtilsGeral.isKeysExists(SQLGeral.ID, map)
        ? Produto(
            id: map['id'],
            nome: map['nome'],
            unid_medida: map['unid_medida'],
            valor_unit: valor_unit,
            porc_lucro: porc_lucro,
            ativo: map['ativo'])
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
        "porc_lucro": _porc_lucro,
        "ativo": _ativo
      };



  double ? get porc_lucro => _porc_lucro;

  double ? get valor_unit => _valor_unit;

  String ? get unid_medida => _unid_medida;

  String ? get nome => _nome;

  int ? get id => _id;

  bool ? get ativo => _ativo;
}
