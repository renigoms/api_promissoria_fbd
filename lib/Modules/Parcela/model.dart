import 'package:intl/intl.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class Parcela {
  int? _id, _id_contrato;
  double? _valor;
  String? _data_pag, _status;
  bool? _ativo;

  Parcela(
      {int? id,
      required int? id_contrato,
      required double? valor,
      required String? data_pag,
      required String? status,
      bool? ativo}) {
    _id = id;
    _id_contrato = id_contrato;
    _valor = valor;
    _data_pag = data_pag;
    _status = status;
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
            status: map['status'],
            ativo: map['ativo'])
        : Parcela(
            id_contrato: map['id_contrato'],
            valor: map['valor'],
            data_pag: map['data_pag'] != null
                ? DateFormat("dd-MM-yyyy").format(map['data_pag'])
                : map['data_pag'],
            status: map['status']);
  }

  /// Extrai a parcela em forma de map
  Map<String, dynamic> toMap() => {
        "id": _id,
        "id_contrato": _id_contrato,
        "valor": _valor,
        "data_pag": _data_pag,
        "status": _status,
        "ativo" : _ativo
      };

  get status => _status;

  get data_pag => _data_pag;

  get valor => _valor;

  get id_contrato  => _id_contrato;

  get id => _id;

  get ativo => _ativo;
}
