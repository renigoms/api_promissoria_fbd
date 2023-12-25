import 'package:intl/intl.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class Contrato {
  int ? id, id_cliente, id_produto, num_parcelas;

  double ? valor;

  int qnt_produto;

  String ? descricao, data_pag_inicial;

  Contrato({
    this.id,
    required this.id_cliente,
    required this.id_produto,
    required this.num_parcelas,
    required this.qnt_produto,
    required this.valor,
    required this.descricao,
    this.data_pag_inicial
  });

  factory Contrato.byMap(Map map){

    final qnt_produto = map['qnt_produto'] ?? 1;

    if (UtilsGeral.isKeysExists(SQLGeral.id, map) ||
        UtilsGeral.isKeysExists('data_pag_inicial', map)) {
      return Contrato(
          id: map['id'],
          id_cliente: map['id_cliente'],
          id_produto: map['id_produto'],
          num_parcelas: map['num_parcelas'],
          qnt_produto: qnt_produto,
          valor:  map['valor'] != null ?double.parse(map['valor']):map['valor'],
          descricao: map['descricao'],
          data_pag_inicial: DateFormat("dd-MM-yyyy").format(map['data_pag_inicial'])
      );
    }

    return Contrato(
        id_cliente: map['id_cliente'],
        id_produto: map['id_produto'],
        num_parcelas: map['num_parcelas'],
        qnt_produto: qnt_produto,
        valor: map['valor'] != null ? double.parse(map['valor']):map['valor'],
        descricao: map['descricao']
    );
  }

  Map<String, dynamic> toMap() => {
    "id":id,
    "id_cliente":id_cliente,
    "id_produto":id_produto,
    "num_parcelas":num_parcelas,
    "qnt_produto":qnt_produto,
    "valor":valor,
    "descricao":descricao,
    "data_pag_inicial":data_pag_inicial
  };
}
