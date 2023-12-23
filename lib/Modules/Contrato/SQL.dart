
import 'package:sistema_promissorias/Modules/Cliente/SQL.dart';
import 'package:sistema_promissorias/Modules/Produto/SQL.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class SQLContrato{
  static const NAME_TABLE = "Contrato",
  _ID_CLIENTE = "id_cliete", _ID_PRODUCT = "id_product",
  _NUM_PARCLS = "num_parcelas",
      _VALOR = "valor", _QNT_PRODUTO = "qnt_produto",
      _DESCRICAO = "descricao", _DATA_PAG_INICIAL = "data_pag_inicial",

  CREATE_TABLE = "CREATE TABLE IF NOT EXISTS $NAME_TABLE(${SQLGeral.id_query},"
  "$_ID_CLIENTE INT REFERENCES ${SQLCliente.NAME_TABLE} (${SQLGeral.id}) NOT NULL,"
      "$_ID_PRODUCT INT REFERENCES ${SQLProduto.NAME_TABLE} (${SQLGeral.id}) NOT NULL,"
      "$_NUM_PARCLS INT NOT NULL, "
      "$_DATA_PAG_INICIAL DATE NOT NULL, "
      "$_VALOR NUMERIC NOT NULL,"
      "$_QNT_PRODUTO INT NOT NULL, $_DESCRICAO VARCHAR(200) NOT NULL);";
}