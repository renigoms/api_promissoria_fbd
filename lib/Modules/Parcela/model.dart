class Parcela{
  int?id;
  double valor;
  DateTime data_pag;
  String status;

  Parcela({
    this.id,
    required this.valor,
    required this.data_pag,
    required this.status
  });

  factory Parcela.byMap(Map map){
    return Parcela(valor: map['valor'],
        data_pag: map['data_pag'],
        status: map['status']);
  }
}