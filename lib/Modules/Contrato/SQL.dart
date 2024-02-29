// ignore_for_file: prefer_final_fields, non_constant_identifier_names

import 'package:sistema_promissorias/Modules/Cliente/SQL.dart';
import 'package:sistema_promissorias/Modules/Parcela/SQL.dart';
import 'package:sistema_promissorias/Modules/Produto/SQL.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

/// Todos os SQL Querys usados no contrato
abstract class SQLContrato {
  static final String NAME_TABLE = "Contrato",
      _ID_CLIENTE = "id_cliente",
      _VALOR_UNIT_BY_PRODUTO = "produto.valor_unit",
      _PORC_LUCRO_BY_PRODUTO = "produto.porc_lucro",
      _STATUS_BY_PACELA = "parcela.paga",
      _ID_CONTRATO_BY_PARCELA = "parcela.id_contrato",
      _NUM_PARCLS = "num_parcelas",
      _VALOR = "valor",
      _DESCRICAO = "descricao",
      _DATA_CRIACAO = "data_criacao",
      _PARCELAS_DEFINIDAS = "parcelas_definidas",
      _CLIENTE_CPF = "cpf",
      _ITENS_PRODUTO = "itens_produto",
      CREATE_TABLE =
          """CREATE TABLE IF NOT EXISTS $NAME_TABLE(${SQLGeral.ID_QUERY},
          $_ID_CLIENTE INT REFERENCES ${SQLCliente.NAME_TABLE} (${SQLGeral.ID}) NOT NULL,
          $_NUM_PARCLS INT NOT NULL, 
          $_DATA_CRIACAO DATE DEFAULT CURRENT_DATE, 
          $_VALOR NUMERIC NOT NULL,
          $_DESCRICAO VARCHAR(200) NOT NULL,
          $_PARCELAS_DEFINIDAS BOOL DEFAULT FALSE,
          ${SQLGeral.ATIVO_QUERY});""",
      SELECT_ALL = SQLGeral.selectAll(NAME_TABLE),
      _SELECT_ID_CLIENTE_BY_CPF = """SELECT ${SQLGeral.ID} 
      FROM ${SQLCliente.NAME_TABLE} WHERE $_CLIENTE_CPF ILIKE '%s'""",
      SELECT_BY_SEARCH = """$SELECT_ALL WHERE (${SQLGeral.ID} = %s) 
                            OR ($_ID_CLIENTE IN ($_SELECT_ID_CLIENTE_BY_CPF));""",
      SELECT_VAL_PORC_LUCRO_PRODUTO = """SELECT $_VALOR_UNIT_BY_PRODUTO,
          $_PORC_LUCRO_BY_PRODUTO FROM ${SQLProduto.NAME_TABLE} 
          WHERE ${SQLGeral.ID} = %s;""",
      SELECT_STATUS_PACELAS = """SELECT $_STATUS_BY_PACELA FROM $NAME_TABLE 
          INNER JOIN ${SQLParcela.NAME_TABLE} 
          ON $_ID_CONTRATO_BY_PARCELA = %s;""",
      CREATE = """INSERT INTO $NAME_TABLE ($_ID_CLIENTE, $_NUM_PARCLS, 
          $_VALOR, $_DESCRICAO) VALUES (%s ,%s,%s,'%s')""",

      DEFINIR_PARCELAS = """UPDATE ${SQLContrato.NAME_TABLE} SET $_PARCELAS_DEFINIDAS = TRUE WHERE ${SQLGeral.ID}=%s;""",

      DELETE = SQLGeral.deleteSQL(NAME_TABLE, SQLGeral.ID);

  static final List<String> requeredItens = [
        _ID_CLIENTE,
        _NUM_PARCLS,
        _DESCRICAO,
        _ITENS_PRODUTO
      ],
      autoItens = [
        SQLGeral.ID,
        _DATA_CRIACAO,
        _VALOR,
        SQLGeral.ATIVO,
        _PARCELAS_DEFINIDAS
      ];
}
