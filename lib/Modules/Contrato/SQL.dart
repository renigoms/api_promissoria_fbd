import 'package:sistema_promissorias/Modules/Cliente/SQL.dart';
import 'package:sistema_promissorias/Modules/Parcela/SQL.dart';
import 'package:sistema_promissorias/Modules/Produto/SQL.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class SQLContrato {
  static String NAME_TABLE = "Contrato",
      _ID_CLIENTE = "id_cliente",
      _ID_PRODUTO = "id_produto",
      _VALOR_UNIT_BY_PRODUTO = "produto.valor_unit",
      _PORC_LUCRO_BY_PRODUTO = "produto.porc_lucro",
      _STATUS_BY_PACELA = "parcela.status",
      _ID_CONTRATO_BY_PARCELA = "parcela.id_contrato",
      _NUM_PARCLS = "num_parcelas",
      _VALOR = "valor",
      _QNT_PRODUTO = "qnt_produto",
      _DESCRICAO = "descricao",
      _DATA_CRIACAO = "data_criacao",
      _PARCELAS_DEFINIDAS = "parcelas_definidas",
      CREATE_TABLE =
          "CREATE TABLE IF NOT EXISTS $NAME_TABLE(${SQLGeral.id_query},"
          "$_ID_CLIENTE INT REFERENCES ${SQLCliente.NAME_TABLE} (${SQLGeral.id}) NOT NULL,"
          "$_ID_PRODUTO INT REFERENCES ${SQLProduto.NAME_TABLE} (${SQLGeral.id}) NOT NULL,"
          "$_NUM_PARCLS INT NOT NULL, "
          "$_DATA_CRIACAO DATE NOT NULL, "
          "$_QNT_PRODUTO INT NOT NULL, "
          "$_VALOR NUMERIC NOT NULL,"
          "$_DESCRICAO VARCHAR(200) NOT NULL,"
          "$_PARCELAS_DEFINIDAS BOOL DEFAULT FALSE);",

      SELECT_ALL = SQLGeral.selectAll(NAME_TABLE),

      SELECT_BY_ID = "$SELECT_ALL WHERE ${SQLGeral.id} = %s;",

      SELECT_BY_ID_CLIENTE = "$SELECT_ALL WHERE $_ID_CLIENTE = %s;",

      SELECT_VAL_PORC_LUCRO_PRODUTO = "SELECT $_VALOR_UNIT_BY_PRODUTO,"
          "$_PORC_LUCRO_BY_PRODUTO FROM ${SQLProduto.NAME_TABLE} "
          "WHERE ${SQLGeral.id} = %s;",

      SELECT_STATUS_PACELAS = "SELECT $_STATUS_BY_PACELA FROM $NAME_TABLE "
          "INNER JOIN ${SQLParcela.NAME_TABLE} "
          "ON $_ID_CONTRATO_BY_PARCELA = %s;",
          
      CREATE = "INSERT INTO $NAME_TABLE ($_ID_CLIENTE, $_ID_PRODUTO, $_NUM_PARCLS, "
      "$_QNT_PRODUTO, $_VALOR, $_DESCRICAO) VALUES (%s,%s,%s,%s,%s,'%s')",

      DELETE = SQLGeral.deleteSQL(NAME_TABLE);
}
