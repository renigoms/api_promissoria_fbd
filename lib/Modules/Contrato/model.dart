import 'package:intl/intl.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class Contrato {
  int? _id, _id_cliente, _id_produto, _num_parcelas;

  double? _valor;

  late int _qnt_produto;

  String? _descricao, _data_criacao;

  bool? _parcelas_definidas;

  Contrato(
      {int? id,
      required int? id_cliente,
      required int? id_produto,
      required int? num_parcelas,
      required int qnt_produto,
      required double? valor,
      required String? descricao,
      String? data_criacao,
      bool? parcelas_definidas}) {
    _id = id;
    _id_cliente = id_cliente;
    _id_produto = id_produto;
    _num_parcelas = num_parcelas;
    _valor = valor;
    _qnt_produto = qnt_produto;
    _descricao = descricao;
    _data_criacao = data_criacao;
    _parcelas_definidas = parcelas_definidas;
  }
  /// Construtor que recebe Map
  factory Contrato.byMap(Map map) {
    // se map['qnt_produto'] for nulo recebe 1
    final qnt_produto = map['qnt_produto'] ?? 1;
    // verifica se essas chaves existem no map
    if (UtilsGeral.isKeysExists(SQLGeral.ID, map) ||
        UtilsGeral.isKeysExists('data_criacao', map)) {
      return Contrato(
          id: map['id'],
          id_cliente: map['id_cliente'],
          id_produto: map['id_produto'],
          num_parcelas: map['num_parcelas'],
          qnt_produto: qnt_produto,
          valor:
              map['valor'] != null ? double.parse(map['valor']) : map['valor'],
          descricao: map['descricao'],
          data_criacao: map['data_criacao'] != null
              ? DateFormat("dd-MM-yyyy").format(map['data_criacao'])
              : map['data_criacao'],
          parcelas_definidas: map['parcelas_definidas']);
    }

    return Contrato(
        id_cliente: map['id_cliente'],
        id_produto: map['id_produto'],
        num_parcelas: map['num_parcelas'],
        qnt_produto: qnt_produto,
        valor: map['valor'] != null ? double.parse(map['valor']) : map['valor'],
        descricao: map['descricao']);
  }
  /// Extração de objeto contrato em formato Map
  Map<String, dynamic> toMap() => {
        "id": _id,
        "id_cliente": _id_cliente,
        "id_produto": _id_produto,
        "num_parcelas": _num_parcelas,
        "qnt_produto": _qnt_produto,
        "valor": _valor,
        "descricao": _descricao,
        "data_criacao": _data_criacao,
        "parcelas_definidas": _parcelas_definidas
      };

  get parcelas_definidas => _parcelas_definidas;

  get data_criacao => _data_criacao;

  get descricao => _descricao;

  get qnt_produto => _qnt_produto;

  get valor => _valor;

  get num_parcelas => _num_parcelas;

  get id_produto => _id_produto;

  get id_cliente => _id_cliente;

  get id => _id;
}
