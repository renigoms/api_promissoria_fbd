// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class Parcela {
  int? _id, _id_contrato;
  double? _valor;
  String? _data_pag;
  bool? _ativo, _paga;

  Parcela(
      {int? id,
      required int? id_contrato,
      required double? valor,
      required String? data_pag,
      bool? paga,
      bool? ativo}) {
    _id = id;
    _id_contrato = id_contrato;
    _valor = valor;
    _data_pag = data_pag;
    _paga = paga;
    _ativo = ativo;
  }
  /// Construtor que recebe um Map
  factory Parcela.byMap(Map map) {
    return UtilsGeral.isKeysExists(SQLGeral.ID, map)
        ? Parcela(
            id: map['id'],
            id_contrato: map['id_contrato'],
            valor: map['valor'] != null
                ? double.parse(map['valor'])
                : map['valor'],
            data_pag: map['data_pag'] != null
                ? DateFormat("dd-MM-yyyy").format(map['data_pag'])
                : map['data_pag'],
            paga: map['paga'],
            ativo: map['ativo'])
        : Parcela(
            id_contrato: map['id_contrato'],
            valor: map['valor'],
            data_pag: map['data_pag'] != null
                ? DateFormat("dd-MM-yyyy").format(map['data_pag'])
                : map['data_pag'],
            paga: map['paga']);
  }

  /// Extrai a parcela em forma de map
  Map<String, dynamic> toMap() => {
        "id": _id,
        "id_contrato": _id_contrato,
        "valor": _valor,
        "data_pag": _data_pag,
        "paga": _paga,
        "ativo" : _ativo
      };

  bool ? get paga => _paga;

  String ? get data_pag => _data_pag;

  double ? get valor => _valor;

  int ? get id_contrato  => _id_contrato;

  int ? get id => _id;

  bool ? get ativo => _ativo;
}
