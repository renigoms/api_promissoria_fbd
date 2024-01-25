import 'package:sistema_promissorias/Utils/SQLGeral.dart';
/// Todos os SQL Querys usados no cliete
abstract class SQLCliente {
  static String NAME_TABLE = "Cliente",
      _NOME_COMPLETO = "nome_completo",
      _CPF = "cpf",
      _EMAIL = "email",
      _TELEFONE = "telefone",
      CREATE_TABLE =
          "CREATE TABLE IF NOT EXISTS $NAME_TABLE (${SQLGeral.ID_QUERY},"
          "$_NOME_COMPLETO VARCHAR(200) NOT NULL,"
          "$_CPF VARCHAR(14) UNIQUE NOT NULL,"
          "$_EMAIL VARCHAR(100) NOT NULL,"
          "$_TELEFONE VARCHAR(100) NOT NULL);",
      SELECT_ALL = SQLGeral.selectAll(NAME_TABLE),
      SELECT_BY_ID = "$SELECT_ALL WHERE ${SQLGeral.ID} = %s;",
      SELECT_BY_CPF = "$SELECT_ALL WHERE $_CPF ILIKE '%s';",
      CREATE = "INSERT INTO $NAME_TABLE ($_NOME_COMPLETO,"
          " $_CPF, $_EMAIL, $_TELEFONE) VALUES ('%s','%s','%s','%s');",
      UPDATE = "UPDATE $NAME_TABLE "
          "SET $_NOME_COMPLETO='%s', $_CPF = '%s',  $_EMAIL = '%s', $_TELEFONE = '%s' "
          "WHERE ${SQLGeral.ID} = %s",
      DELETE = SQLGeral.deleteSQL(NAME_TABLE);
}
