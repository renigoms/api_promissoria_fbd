// ignore_for_file: non_constant_identifier_names, prefer_final_fields

import 'package:sistema_promissorias/Modules/Contrato/SQL.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

/// Todas as Querys usadas em Parcela
abstract class SQLParcela {
  static final String NAME_TABLE = "Parcela",

      _STATUS = "status",

      _DATA_PAG = "data_pag",

      _VALOR = "valor",

      _ID_CONTRATO = "id_contrato",

      _VALOR_CONTRATO = 'valor',

      _DATA_CRIACAO_CONTRATO = 'data_criacao',

      _QNT_PARCELAS_CONTRATO = 'num_parcelas',

      _PARCELAS_DEFINIDAS = "parcelas_definidas",

      CREATE_TABLE =
          """CREATE TABLE IF NOT EXISTS $NAME_TABLE(${SQLGeral.ID_QUERY},
          $_ID_CONTRATO INT REFERENCES ${SQLContrato.NAME_TABLE} (${SQLGeral.ID}) 
          ON DELETE CASCADE NOT NULL,
          $_VALOR NUMERIC NOT NULL, 
          $_DATA_PAG DATE NOT NULL, 
          $_STATUS VARCHAR(100) DEFAULT 'EM ABERTO',
          ${SQLGeral.ATIVO_QUERY});""",

      SELECT_BY_ID_CONTRATO =
          "SELECT * FROM $NAME_TABLE WHERE $_ID_CONTRATO = %s",

      SELECT_CONTRATO = """SELECT $_QNT_PARCELAS_CONTRATO, 
          $_DATA_CRIACAO_CONTRATO, $_VALOR_CONTRATO,
          $_PARCELAS_DEFINIDAS FROM ${SQLContrato.NAME_TABLE} 
          WHERE ${SQLGeral.ID} = %s;""",

      SELECT_BYCONTRATO_AND__DATA_PAG = """${SQLGeral.selectAll(NAME_TABLE)} 
      WHERE $_ID_CONTRATO = %s AND $_DATA_PAG = '%s';""",

      CREATE = "INSERT INTO $NAME_TABLE ($_ID_CONTRATO, $_VALOR, $_DATA_PAG)"
          "VALUES (%s,%s,'%s')",

      UPDATE = """UPDATE $NAME_TABLE SET $_STATUS = '%s' 
      WHERE $_ID_CONTRATO = %s AND $_DATA_PAG = '%s';""",

      DESATIVAR_PARCELAS = SQLGeral.deleteSQL(NAME_TABLE, _ID_CONTRATO);

  static List<String> autoItens = [SQLGeral.ID, _ID_CONTRATO, _VALOR, _DATA_PAG, SQLGeral.ATIVO];
}
