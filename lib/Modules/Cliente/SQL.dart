import 'package:sistema_promissorias/Utils/SQLGeral.dart';

abstract class SQLCliente {
  static const NOMETABELA = "Cliente",
      _NOMECOMPLETO = "nome_completo",
      _CPF = "cpf",
      _EMAIL = "email",
      _TELEFONE = "telefone",
      CREATE_TABLE = "CREATE TABLE IF NOT EXISTS $NOMETABELA (${SQLGeral.id_query},"
          "$_NOMECOMPLETO VARCHAR(200) NOT NULL,"
          "$_CPF VARCHAR(14) UNIQUE NOT NULL,"
          "$_EMAIL VARCHAR(100) NOT NULL,"
          "$_TELEFONE VARCHAR(100) NOT NULL);",
      SELECTALL = "SELECT * FROM $NOMETABELA",
      SELECTBYID = "$SELECTALL WHERE ${SQLGeral.id} = %s;",
      SELECTBYCPF = "$SELECTALL WHERE $_CPF ILIKE %s;",

      CREATE = "INSERT INTO $NOMETABELA ($_NOMECOMPLETO,"
          " $_CPF, $_EMAIL, $_TELEFONE) VALUES ('%s','%s','%s','%s');",

      UPDATE = "UPDATE $NOMETABELA "
          "SET $_NOMECOMPLETO='%s', $_CPF = '%s',  $_EMAIL = '%s', $_TELEFONE = '%s' "
          "WHERE ${SQLGeral.id} = %s",

      DELETE = "DELETE FROM $NOMETABELA WHERE ${SQLGeral.id} = %s;";
}
