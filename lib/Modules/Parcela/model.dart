import 'package:intl/intl.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class Parcela{
  int?id;
  double valor;
  String data_pag;
  String status;

  Parcela({
    this.id,
    required this.valor,
    required this.data_pag,
    required this.status
  });

  factory Parcela.byMap(Map map){
    return UtilsGeral.isKeysExists(SQLGeral.id, map)?
    Parcela(
      id: map['id'],
      valor: map['valor'] != null ? double.parse(map['valor']):map['valor'],
      data_pag: DateFormat("dd-MM-yyyy").format(map['data_pag']),
      status: map['status']
    ):
    Parcela(
        valor: map['valor'],
        data_pag: DateFormat("dd-MM-yyyy").format(map['data_pag']),
        status: map['status']
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "valor": valor,
    "data_pag":data_pag,
    "status": status
  };
}