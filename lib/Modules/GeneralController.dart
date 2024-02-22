// ignore_for_file: file_names

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sistema_promissorias/Modules/Cliente/controller.dart';
import 'package:sistema_promissorias/Modules/Contrato/controller.dart';
import 'package:sistema_promissorias/Modules/Parcela/controller.dart';
import 'package:sistema_promissorias/Modules/Produto/controller.dart';

import 'Item_Produto/controller.dart';
/// Gerenciamento geral de rotas
class GeneralController {
    Handler get handler{
      final route = Router();

      // todas as rotas de cliente
      route.mount('/cliente', ClienteHandlerController().router);

      // todas as rotas de produto
      route.mount('/produto', ProdutoControllerHandler().router);

      // todas as rotas de contrato
      route.mount('/contrato', ContratoHandlerController().router);

      // todas as rotas de parcelas
      route.mount('/parcela', ParcelaHandlerController().router);

      // todas as rotas de item_produto
      route.mount('/item_produto', ItemProdutoController().router);

      return route;


    }


}