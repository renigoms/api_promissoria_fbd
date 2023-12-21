
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';
import 'package:sistema_promissorias/Modules/Produto/DAO.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

class ProdutoControllerHandler implements ServerUtils{
  @override
  // TODO: implement router
  Router get router {
    final route = Router();

    route.get("/", (Request request) async{
      try{
        final map = await DAOProduto().getAll();
        return Response.ok(jsonEncode(map));
      }catch(e){
        return Response.forbidden("Erro, ${e.toString()}");
      }
    });

    route.get("/<id>", (Request request, String id) async{
      try{
        return Response.ok(jsonEncode(await DAOProduto().getByID(id)));
      }catch(e){
        return Response.internalServerError(
            body: "Erro ao buscar por id, ${e.toString()}");
      }
    });

    route.get("/nome/<nome>", (Request request, String nome) {
      try{
        return Response.ok(jsonEncode(DAOProduto().getByName(nome)));
      }catch(e){
        return Response.internalServerError(
            body: "Erro ao buscar por nome, $e");
      }
    });



    return route;

  }
}