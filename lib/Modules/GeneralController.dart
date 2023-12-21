
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sistema_promissorias/Modules/Cliente/controller.dart';
import 'package:sistema_promissorias/Modules/Produto/controller.dart';

class GeneralController {
    Handler get handler{
      final route = Router();
      
      route.mount('/cliente', ClienteHandlerController().router);

      route.mount('/produto', ProdutoControllerHandler().router);

      return route;


    }


}