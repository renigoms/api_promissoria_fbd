
import 'package:sistema_promissorias/Modules/Contrato/SQL.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class SQLParcela{
  static String NAME_TABLE = "Parcela",
      _STATUS = "status",
      _DATA_PAG="data_pag",
      _VALOR = "valor",
      _ID_CONTRATO = "id_contrato",
      _VALOR_CONTRATO = 'valor',
      _DATA_PAG_INICIAL_CONTRATO = 'data_pag_inicial',
      _QNT_PARCELAS_CONTRATO   = 'num_parcelas',

      CREATE_TABLE = "CREATE TABLE IF NOT EXISTS $NAME_TABLE(${SQLGeral.id_query},"
      "$_ID_CONTRATO INT REFERENCES ${SQLContrato.NAME_TABLE} (${SQLGeral.id}) "
          "ON DELETE CASCADE NOT NULL,"
      "$_VALOR NUMERIC NOT NULL, "
      "$_DATA_PAG DATE NOT NULL, "
      "$_STATUS VARCHAR(100) DEFAULT 'EM ABERTO');",

      SELECT_BY_ID_CONTRATO = "SELECT * FROM $NAME_TABLE WHERE $_ID_CONTRATO = %s",
      
      SELECT_CONTRATO = "SELECT $_QNT_PARCELAS_CONTRATO, "
          "$_DATA_PAG_INICIAL_CONTRATO, $_VALOR_CONTRATO FROM ${SQLContrato.NAME_TABLE} "
          "WHERE ${SQLGeral.id} = %s;",

      CREATE = "INSERT INTO $NAME_TABLE ($_ID_CONTRATO, $_VALOR, $_DATA_PAG)"
          "VALUES (%s,%s,'%s')";
}
