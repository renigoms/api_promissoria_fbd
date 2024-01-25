abstract class SQLGeral {
  /// Classe abstrata com algumas costantes e metodos 
  /// comuns no programa

  static const ID = 'id'; 

  static const ID_QUERY = "$ID SERIAL PRIMARY KEY";

  static String deleteSQL(String NAME_TABLE) =>
      "DELETE FROM $NAME_TABLE WHERE $ID = %s;";

  static String selectAll(String NAME_TABLE) => "SELECT * FROM $NAME_TABLE";
}
