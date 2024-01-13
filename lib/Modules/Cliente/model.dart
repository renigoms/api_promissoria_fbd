import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class Cliente {
  int? _id;

  String? _nome_completo, _cpf, _email, _telefone;

  Cliente({int? id,
      required String? nome_completo,
      required String? cpf,
      required String? email,
      required String? telefone
      }) {_id = id;
      _nome_completo = nome_completo; _cpf = cpf;
      _email = email;_telefone = telefone;}

  factory Cliente.byMap(Map map) {
    return UtilsGeral.isKeysExists(SQLGeral.id, map)
        ? Cliente(
            id: map['id'],
            nome_completo: map['nome_completo'],
            cpf: map['cpf'],
            email: map['email'],
            telefone: map['telefone'])
        : Cliente(
            nome_completo: map['nome_completo'],
            cpf: map['cpf'],
            email: map['email'],
            telefone: map['telefone']);
  }

  Map<String, dynamic> toMap() => {
        "id": _id,
        "nome_completo": _nome_completo,
        "cpf": _cpf,
        "email": _email,
        "telefone": _telefone
      };

  int? get id => _id;
  String? get nome_completo => _nome_completo;
  String? get cpf => _cpf;
  String? get email => _email;
  String? get telefone => _telefone;
}
