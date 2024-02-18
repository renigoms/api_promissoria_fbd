// ignore_for_file: file_names, constant_identifier_names

abstract class SQLGeral {
  /// Classe abstrata com algumas costantes e metodos 
  /// comuns no programa

  static const

      ID = 'id',

      ID_QUERY = "$ID SERIAL PRIMARY KEY",

      ATIVO = 'ativo',

      ATIVO_QUERY = "$ATIVO BOOL DEFAULT TRUE";

  static String deleteSQL(String nameTable, String columnFilter) =>
      "UPDATE $nameTable SET $ATIVO = FALSE WHERE $columnFilter = %s;";

  static String selectAll(String nameTable) => "SELECT * FROM $nameTable";

  static String selectColAtivo(String table, String buscBy) =>
      "SELECT ${SQLGeral.ATIVO} FROM $table WHERE $buscBy ILIKE '%s';";

  static String ativar(String table, String by) =>
      "UPDATE $table SET $ATIVO = TRUE WHERE $by ILIKE '%s';";

}
