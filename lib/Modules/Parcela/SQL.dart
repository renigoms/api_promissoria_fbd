
import 'package:sistema_promissorias/Modules/Contrato/SQL.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class SQLParcela{
  static String NAME_TABLE = "Parcela",
      _STATUS = "status",
      _DATA_PAG="data_pag",
      _VALOR = "valor",
      _ID_CONTRATO = "id_contrato",

      CREATE_TABLE = "CREATE TABLE IF NOT EXISTS $NAME_TABLE(${SQLGeral.id_query},"
      "$_ID_CONTRATO INT REFERENCES ${SQLContrato.NAME_TABLE} (${SQLGeral.id}) "
          "ON DELETE CASCADE NOT NULL,"
      "$_VALOR NUMERIC NOT NULL, "
      "$_DATA_PAG DATE NOT NULL, "
      "$_STATUS VARCHAR(100) DEFAULT 'EM ABERTO');";
}
