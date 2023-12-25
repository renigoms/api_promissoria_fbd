import 'package:sistema_promissorias/Modules/Cliente/SQL.dart';
import 'package:sistema_promissorias/Modules/Produto/SQL.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class SQLContrato {
  static const NAME_TABLE = "Contrato",
      _PRODUTO_TABLE = "Produto",
      _ID_CLIENTE = "id_cliente",
      _ID_PRODUTO = "id_produto",
      _VALOR_UNIT_BY_PRODUTO = "produto.valor_unit",
      _PORC_LUCRO_BY_PRODUTO = "produto.porc_lucro",
      _NUM_PARCLS = "num_parcelas",
      _VALOR = "valor",
      _QNT_PRODUTO = "qnt_produto",
      _DESCRICAO = "descricao",
      _DATA_PAG_INICIAL = "data_pag_inicial",
      CREATE_TABLE =
          "CREATE TABLE IF NOT EXISTS $NAME_TABLE(${SQLGeral.id_query},"
          "$_ID_CLIENTE INT REFERENCES ${SQLCliente.NAME_TABLE} (${SQLGeral.id}) NOT NULL,"
          "$_ID_PRODUTO INT REFERENCES ${SQLProduto.NAME_TABLE} (${SQLGeral.id}) NOT NULL,"
          "$_NUM_PARCLS INT NOT NULL, "
          "$_DATA_PAG_INICIAL DATE NOT NULL, "
          "$_QNT_PRODUTO INT NOT NULL, "
          "$_VALOR NUMERIC NOT NULL,"
          "$_DESCRICAO VARCHAR(200) NOT NULL);",

      SELECT_ALL = "SELECT * FROM $NAME_TABLE",

      SELECT_BY_ID = "$SELECT_ALL WHERE ${SQLGeral.id} = %s;",

      SELECT_BY_ID_CLIENTE = "$SELECT_ALL WHERE $_ID_CLIENTE = %s;",

      SELECT_VAL_PORC_LUCRO_PRODUTO = "SELECT $_VALOR_UNIT_BY_PRODUTO,"
          "$_PORC_LUCRO_BY_PRODUTO FROM $_PRODUTO_TABLE "
          "WHERE ${SQLGeral.id} = %s;",
          
      CREATE = "INSERT INTO $NAME_TABLE ($_ID_CLIENTE, $_ID_PRODUTO, $_NUM_PARCLS, "
      "$_QNT_PRODUTO, $_VALOR, $_DESCRICAO) VALUES (%s,%s,%s,%s,%s,'%s')";
}
