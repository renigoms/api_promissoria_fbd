// ignore_for_file: non_constant_identifier_names, prefer_final_fields

import 'package:sistema_promissorias/Utils/SQLGeral.dart';

import '../Contrato/SQL.dart';

/// Todas as Querys usadas em produto
abstract class SQLProduto {
  static String NAME_TABLE = "Produto",
      _NAME = "nome",
      _UNID_MEDIDA = "unid_medida",
      _VALOR_UNIT = "valor_unit",
      _PORCENT_LUCRO = "porc_lucro",
      _CONTRATO_ID_PRODUTO = "id_produto",

      CREATE_TABLE = """CREATE TABLE IF NOT EXISTS $NAME_TABLE(
          ${SQLGeral.ID_QUERY}, $_NAME VARCHAR(200) UNIQUE NOT NULL,
          $_UNID_MEDIDA VARCHAR(100) NOT NULL, 
          $_VALOR_UNIT NUMERIC NOT NULL, $_PORCENT_LUCRO NUMERIC DEFAULT 0.30, 
          ${SQLGeral.ATIVO_QUERY});""",

      SELECT_ALL = SQLGeral.selectAll(NAME_TABLE),

      SELECT_BY_ID = "$SELECT_ALL WHERE ${SQLGeral.ID} = %s",

      // Essa notação %-%s-% server para retorno contendo tal elemento

      SELECT_BY_NAME = "$SELECT_ALL WHERE $_NAME ILIKE '%s';",

      SELECT_ID_PRODUTO_IN_CONTRATO = """SELECT $_CONTRATO_ID_PRODUTO FROM  
          ${SQLContrato.NAME_TABLE};""",

      SELECT_COL_ATIVO_PRODUTO = """SELECT ${SQLGeral.ATIVO}, ${SQLGeral.ID} 
                                    FROM $NAME_TABLE WHERE $_NAME ILIKE '%s';""",

      SELECT_ATIVO_CONTRATO_BY_ID_PRODUTO = """SELECT ${SQLGeral.ATIVO} 
          FROM ${SQLContrato.NAME_TABLE} WHERE $_CONTRATO_ID_PRODUTO = %s;""",

      CREATE_WITH_PORC_LUCRO = """INSERT INTO $NAME_TABLE 
          ($_NAME, $_UNID_MEDIDA, $_VALOR_UNIT, $_PORCENT_LUCRO)
          VALUES ('%s', '%s', %s, %s);""",

      CREATE_WITH_PORC_LUCRO_DEFAULT = """INSERT INTO $NAME_TABLE 
          ($_NAME, $_UNID_MEDIDA, $_VALOR_UNIT) VALUES ('%s', '%s', %s);""",

      UPDATE = """UPDATE $NAME_TABLE SET $_NAME = '%s', $_UNID_MEDIDA = '%s', 
          $_VALOR_UNIT = %s, $_PORCENT_LUCRO = %s WHERE ${SQLGeral.ID} = %s;""",

      DELETE = SQLGeral.deleteSQL(NAME_TABLE),

      ACTIVE_PRODUTO = SQLGeral.ativar(NAME_TABLE, _NAME);

  static List<String> requeredItens = [_NAME, _UNID_MEDIDA, _VALOR_UNIT];
}
