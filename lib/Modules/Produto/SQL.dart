import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class SQLProduto {
  static const NAMETABLE = "Produto",
      _NAMEPRODUCT = "nome",
      _UNIDMEDIDA = "unid_medida",
      _VALORUNIT = "valor_unit",
      _PORCENTLUCRO = "porc_lucro",
      CREATE_TABLE = "CREATE TABLE IF NOT EXISTS $NAMETABLE("
          "${SQLGeral.id_query}, $_NAMEPRODUCT VARCHAR(200) UNIQUE NOT NULL,"
          "$_UNIDMEDIDA VARCHAR(100) NOT NULL,"
          "$_VALORUNIT NUMERIC NOT NULL, $_PORCENTLUCRO NUMERIC DEFAULT 0.30);",
      SELECTALL = "SELECT * FROM $NAMETABLE",
      SELECTBYID = "$SELECTALL WHERE ${SQLGeral.id} = %s",
      SELECTBYNAME = "$SELECTALL WHERE $_NAMEPRODUCT ILIKE '%s';";
}
