
// ignore_for_file: non_constant_identifier_names

import 'package:sistema_promissorias/Modules/Contrato/SQL.dart';
import 'package:sistema_promissorias/Modules/Produto/SQL.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

abstract class SQLItemProduto {

  static final String NAME_TABLE = "item_produto",

  _ID_CONTRATO = "id_contrato",

  _ID_PRODUTO = "id_produto",

  _VALOR_VENDA = "valor_venda",

  CREATE_TABLE = """CREATE TABLE IF NOT EXISTS $NAME_TABLE(
                         ${SQLGeral.ID_QUERY},
                         $_ID_CONTRATO INT REFERENCES ${SQLContrato.NAME_TABLE}
                         (${SQLGeral.ID}) NOT NULL,
                         $_ID_PRODUTO INT REFERENCES ${SQLProduto.NAME_TABLE}
                         (${SQLGeral.ID}) NOT NULL,
                         $_VALOR_VENDA NUMERIC NOT NULL,
                         ${SQLGeral.ATIVO_QUERY}
                   );""",

  CREATE = """INSERT INTO $NAME_TABLE ($_ID_CONTRATO, $_ID_PRODUTO, $_VALOR_VENDA) 
              VALUES (%s,%s,%s);""",

  SELECT_BY_ID_CONTRATO = "${SQLGeral.selectAll(NAME_TABLE)} WHERE $_ID_CONTRATO = %s;",

  DESTATIVA_ITEM_PRODUTO = SQLGeral.deleteSQL(NAME_TABLE, _ID_CONTRATO);

}