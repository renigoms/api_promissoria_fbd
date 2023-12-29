import 'package:intl/intl.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class Parcela{
  int?id, id_contrato;
  double ? valor;
  String ? data_pag, status;

  Parcela({
    this.id,
    required this.id_contrato,
    required this.valor,
    required this.data_pag,
    required this.status
  });

  factory Parcela.byMap(Map map){
    return UtilsGeral.isKeysExists(SQLGeral.id, map)?
    Parcela(
      id: map['id'],
      id_contrato: map['id_contrato'],
      valor: map['valor'] != null ? double.parse(map['valor']):map['valor'],
      data_pag: map['data_pag'] != null ? DateFormat("dd-MM-yyyy").format(map['data_pag']):map['data_pag'],
      status: map['status']
    ):
    Parcela(
        id_contrato: map['id_contrato'],
        valor: map['valor'],
        data_pag: map['data_pag'] != null ? DateFormat("dd-MM-yyyy").format(map['data_pag']):map['data_pag'],
        status: map['status']
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "id_contrato":id_contrato,
    "valor": valor,
    "data_pag":data_pag,
    "status": status
  };
}