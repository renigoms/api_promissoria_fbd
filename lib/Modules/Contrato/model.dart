// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class Contrato {
  int? _id, _id_cliente, _id_produto, _num_parcelas;

  double? _valor;

  String? _descricao, _data_criacao;

  bool? _parcelas_definidas, _ativo;

  Contrato(
      {int? id,
      required int? id_cliente,
      required int? id_produto,
      required int? num_parcelas,
      required double? valor,
      required String? descricao,
      String? data_criacao,
      bool? parcelas_definidas,
      bool? ativo}) {
    _id = id;
    _id_cliente = id_cliente;
    _id_produto = id_produto;
    _num_parcelas = num_parcelas;
    _valor = valor;
    _descricao = descricao;
    _data_criacao = data_criacao;
    _parcelas_definidas = parcelas_definidas;
    _ativo = ativo;
  }

  /// Construtor que recebe Map
  factory Contrato.byMap(Map map) {
    // verifica se essas chaves existem no map
    if (UtilsGeral.isKeysExists(SQLGeral.ID, map) ||
        UtilsGeral.isKeysExists('data_criacao', map)) {
      return Contrato(
          id: map['id'],
          id_cliente: map['id_cliente'],
          id_produto: map['id_produto'],
          num_parcelas: map['num_parcelas'],
          valor:
              map['valor'] != null ? double.parse(map['valor']) : map['valor'],
          descricao: map['descricao'],
          data_criacao: map['data_criacao'] != null
              ? DateFormat("dd-MM-yyyy").format(
                  map['data_criacao'].runtimeType == String
                      ? DateTime.parse(map['data_criacao'])
                      : map['data_criacao'])
              : map['data_criacao'],
          parcelas_definidas: map['parcelas_definidas'],
          ativo: map['ativo']);
    }

    return Contrato(
        id_cliente: map['id_cliente'],
        id_produto: map['id_produto'],
        num_parcelas: map['num_parcelas'],
        valor: map['valor'] != null ? double.parse(map['valor']) : map['valor'],
        descricao: map['descricao']);
  }

  /// Extração de objeto contrato em formato Map
  Map<String, dynamic> toMap() => {
        "id": _id,
        "id_cliente": _id_cliente,
        "id_produto": _id_produto,
        "num_parcelas": _num_parcelas,
        "valor": _valor,
        "descricao": _descricao,
        "data_criacao": _data_criacao,
        "parcelas_definidas": _parcelas_definidas,
        "ativo": _ativo
      };

  bool ? get parcelas_definidas => _parcelas_definidas;

  String ? get data_criacao => _data_criacao;

  String ? get descricao => _descricao;

  double ? get valor => _valor;

  int ? get num_parcelas => _num_parcelas;

  int ? get id_produto => _id_produto;

  int ? get id_cliente => _id_cliente;

  int ? get id => _id;

  bool ? get ativo => _ativo;
}
