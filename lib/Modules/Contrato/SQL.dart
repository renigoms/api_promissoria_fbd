
import 'package:sistema_promissorias/Modules/Cliente/SQL.dart';

import 'package:sistema_promissorias/Modules/Produto/SQL.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class SQLContrato{
  static const NAMETABLE = "Contrato",
  _IDCLIENTE = "id_cliete", _IDPRODUCT = "id_product",
  _NUMPARCELS = "num_parcelas",
      _VALORCONTRATO = "valor", _QNTPRODUTO = "qnt_produto",
      _DESCRICAO = "descricao", _DATA_PAG_INICIAL = "data_pag_inicial",

  CREATE_TABLE = "CREATE TABLE IF NOT EXISTS $NAMETABLE(${SQLGeral.id_query},"
  "$_IDCLIENTE INT REFERENCES ${SQLCliente.NOMETABELA} (${SQLGeral.id}) NOT NULL,"
      "$_IDPRODUCT INT REFERENCES ${SQLProduto.NAMETABLE} (${SQLGeral.id}) NOT NULL,"
      "$_NUMPARCELS INT NOT NULL, "
      "$_DATA_PAG_INICIAL DATE NOT NULL, "
      "$_VALORCONTRATO NUMERIC NOT NULL,"
      "$_QNTPRODUTO INT NOT NULL, $_DESCRICAO VARCHAR(200) NOT NULL);";


}