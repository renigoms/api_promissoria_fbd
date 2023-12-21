
import 'package:sistema_promissorias/Modules/Contrato/SQL.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class SQLParcela{
  static const NAMETABLE = "Parcela",
      _STATUS = "status",
      _DATA_PAG="data_pag",
      _VALOR = "valor",
      _IDCONTRATO = "id_contrato",

      CREATE_TABLE = "CREATE TABLE IF NOT EXISTS $NAMETABLE(${SQLGeral.id_query},"
      "$_IDCONTRATO INT REFERENCES ${SQLContrato.NAMETABLE} (${SQLGeral.id}) NOT NULL,"
      "$_VALOR NUMERIC NOT NULL, "
      "$_DATA_PAG DATE NOT NULL, "
      "$_STATUS VARCHAR(100) DEFAULT 'EM ABERTO');";
}
