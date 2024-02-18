
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_router/src/router.dart';
import 'package:sistema_promissorias/Modules/Item_Produto/DAO.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

class ItemProdutoController implements ServerUtils{
  @override
  // TODO: implement router
  Router get router{

    final router = Router();

    router.get('/<id_contrato>', (Request request, String idContrato) async=>
         ResponseUtils.getResponse(await DAOItemProduto().getById(idContrato)));

    return router;
  }

}