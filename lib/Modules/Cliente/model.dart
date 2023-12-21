
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class Cliente{
  int?id;

  String ? nome_completo, cpf, email, telefone;

  Cliente({
    this.id,
    required this.nome_completo,
    required this.cpf,
    required this.email,
    required this.telefone
  });

  factory Cliente.byMap(Map map){
    return UtilsGeral.isKeysExists(SQLGeral.id, map) ?
    Cliente(
        id: map['id'],
        nome_completo: map['nome_completo'],
        cpf:  map['cpf'], email: map['email'],
        telefone: map['telefone']
    ):
    Cliente(
        nome_completo: map['nome_completo'],
        cpf:  map['cpf'], email: map['email'],
        telefone: map['telefone']
    );
  }

  Map<String, dynamic> toMap() => {
    "id":id,
    "nome_completo":nome_completo,
    "cpf":cpf,
    "email":email,
    "telefone":telefone
  };
}


