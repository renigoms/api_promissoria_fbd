class Contrato {
  int?id;
  int  id_cliente, id_produto, num_parcelas, id_parcela;

  double valor_contrato, qnt_produto;

  String descricao;

  DateTime data_pag_inicial;

  Contrato({
    this.id,
    required this.id_cliente,
    required this.id_produto,
    required this.num_parcelas,
    required this.id_parcela,
    required this.valor_contrato,
    required this.qnt_produto,
    required this.descricao,
    required this.data_pag_inicial
  });

  factory Contrato.byMap(Map map){
    return Contrato(id_cliente: map['id_cliente'],
        id_produto: map['id_produto'],
        num_parcelas: map['num_parcelas'],
        id_parcela: map['id_parcela'],
        valor_contrato: map['valor_contrato'],
        qnt_produto: map['qnt_produto'],
        descricao: map['descricao'],
        data_pag_inicial: map['data_pag_inicial']);
  }
}
