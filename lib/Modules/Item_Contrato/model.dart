import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';

class ItemProduto{

  int ? _id, _idContrato, _idProduto;

  double ? _valorVenda;

  bool ? _ativo;

  ItemProduto ({
    int ? id,
    required int ? idContrato,
    required int ? idProduto,
    required double ? valorVenda,
    bool ? ativo
  }){
    _id = id;
    _idContrato = idContrato;
    _idProduto = idProduto;
    _valorVenda = valorVenda;
    _ativo = ativo;
  }

  factory ItemProduto.byMap(Map map){

    double ? valorVenda = map['valor_venda'] is String ?
    double.parse(map['valor_venda']):map['valor_venda'];

    return UtilsGeral.isKeysExists(SQLGeral.ID, map) ?
        ItemProduto(
            id: map['id'],
            idContrato: map['id_contrato'],
            idProduto: map['id_produto'],
            valorVenda: valorVenda,
            ativo: map['ativo']
        ):
        ItemProduto(
            idContrato: map['id_contrato'],
            idProduto: map['id_produto'],
            valorVenda: valorVenda
        );
  }

  Map<String, dynamic> toMap() => {
    "id": _id,
    "id_contrato": _idContrato,
    "id_produto" : _idProduto,
    "valor_venda" : _valorVenda,
    "ativo": _ativo
  };

  bool ? get ativo => _ativo;

  int ? get id => _id;

  int ? get idContrato => _idContrato;

  int ? get idProduto => _idProduto;

  double ? get valorVenda => _valorVenda;
}