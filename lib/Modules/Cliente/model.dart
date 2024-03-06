// ignore_for_file: non_constant_identifier_names

import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class Cliente {
  int? _id;

  String? _nome_completo, _cpf, _email, _telefone;

  bool ? _ativo;

  Cliente(
      {int? id,
      required String? nome_completo,
      required String? cpf,
      required String? email,
      required String? telefone,
      bool? ativo}) {
    _id = id;
    _nome_completo = nome_completo;
    _cpf = cpf;
    _email = email;
    _telefone = telefone;
    _ativo = ativo;
  }
  /// Construtor que recebe Map
  factory Cliente.byMap(Map map) {
    return UtilsGeral.isKeysExists(SQLGeral.ID, map)
        ? Cliente(
            id: map['id'],
            nome_completo: map['nome_completo'],
            cpf: map['cpf'],
            email: map['email'],
            telefone: map['telefone'],
            ativo: map['ativo'])
        : Cliente(
            nome_completo: map['nome_completo'],
            cpf: map['cpf'],
            email: map['email'],
            telefone: map['telefone']);
  }

  /// Extração de objeto cliente em formato Map
  Map<String, dynamic> toMap() => {
  "id": _id,
        "nome_completo": _nome_completo,
        "cpf": _cpf,
        "email": _email,
        "telefone": _telefone,
        "ativo": _ativo
      };

  int? get id => _id;
  String? get nome_completo => _nome_completo;
  String? get cpf => _cpf;
  String? get email => _email;
  String? get telefone => _telefone;
  bool ? get ativo => _ativo;

}
