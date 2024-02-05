// ignore_for_file: file_names, constant_identifier_names

abstract class SQLGeral {
  /// Classe abstrata com algumas costantes e metodos 
  /// comuns no programa

  static const ID = 'id'; 

  static const ID_QUERY = "$ID SERIAL PRIMARY KEY";

  static String deleteSQL(String nameTable) =>
      "DELETE FROM $nameTable WHERE $ID = %s;";

  static String selectAll(String nameTable) => "SELECT * FROM $nameTable";
}
