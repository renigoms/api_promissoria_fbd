import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class SQLProduto {
  static String NAME_TABLE = "Produto",
      _NAME = "nome",
      _UNID_MEDIDA = "unid_medida",
      _VALOR_UNIT = "valor_unit",
      _PORCENT_LUCRO = "porc_lucro",
      CREATE_TABLE = "CREATE TABLE IF NOT EXISTS $NAME_TABLE("
          "${SQLGeral.id_query}, $_NAME VARCHAR(200) UNIQUE NOT NULL,"
          "$_UNID_MEDIDA VARCHAR(100) NOT NULL,"
          "$_VALOR_UNIT NUMERIC NOT NULL, $_PORCENT_LUCRO NUMERIC DEFAULT 0.30);",
      SELECT_ALL = SQLGeral.selectAll(NAME_TABLE),
      SELECT_BY_ID = "$SELECT_ALL WHERE ${SQLGeral.id} = %s",
      SELECT_BY_NAME = "$SELECT_ALL WHERE $_NAME ILIKE '%s';",

      CREATE_WITH_PORC_LUCRO = "INSERT INTO $NAME_TABLE "
          "($_NAME, $_UNID_MEDIDA, $_VALOR_UNIT, $_PORCENT_LUCRO)"
          "VALUES ('%s', '%s', %s, %s);",

      CREATE_WITH_PORC_LUCRO_DEFAULT = "INSERT INTO $NAME_TABLE "
          "($_NAME, $_UNID_MEDIDA, $_VALOR_UNIT)"
          "VALUES ('%s', '%s', %s);",

      UPDATE = "UPDATE $NAME_TABLE SET $_NAME = '%s', $_UNID_MEDIDA = '%s',"
          "$_VALOR_UNIT = %s, $_PORCENT_LUCRO = %s WHERE ${SQLGeral.id} = %s;",

      DELETE = SQLGeral.deleteSQL(NAME_TABLE);
}
