
abstract class SQLGeral {
  static const id = 'id';

  static const id_query = "$id SERIAL PRIMARY KEY";

  static String deleteSQL(String NAME_TABLE) =>
      "DELETE FROM $NAME_TABLE WHERE $id = %s;";

  static String selectAll(String NAME_TABLE) =>
      "SELECT * FROM $NAME_TABLE";
}