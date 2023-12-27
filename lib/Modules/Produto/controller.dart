import 'package:postgres/legacy.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';
import 'package:sistema_promissorias/Modules/Produto/DAO.dart';
import 'package:sistema_promissorias/Modules/Produto/model.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

import '../../Service/exceptions.dart';

class ProdutoControllerHandler implements ServerUtils {
  @override
  // TODO: implement router
  Router get router {
    final route = Router();

    route.get(
        "/",
        (Request request) async =>
            ResponseUtils.getResponse(await DAOProduto().getAll()));

    route.get(
        "/<id>",
        (Request request, String id) async =>
            ResponseUtils.getResponse(await DAOProduto().getByID(id)));

    route.get(
        "/nome/<nome>",
        (Request request, String nome) async =>
            ResponseUtils.getResponse(await DAOProduto().getByName(nome)));

    route.post("/", (Request request) async {
      try {
        return await DAOProduto().postCreate(Produto.byMap(
                ResponseUtils.dadosReqMap(await request.readAsString())))
            ? Response.ok("Produto cadastrado com sucesso!")
            : Response.internalServerError(
                body: "Erro durante o cadastro detectado!");
      } on PostgreSQLException {
        return Response.badRequest(
            body: "Opa, Já existe um produto com o mesmo nome!");
      }
    });

    route.put("/", (Request request) async {
      try {
        return await DAOProduto().putUpdate(Produto.byMap(
                ResponseUtils.dadosReqMap(await request.readAsString())))
            ? Response.ok("Updates realizados com sucesso!")
            : Response.internalServerError(body: "Falha no update!");
      } on IDException {
        return Response.badRequest(
            body:
                "O id deve ser passado junto com os dados que serão alterados");
      }
    });

    route.delete("/<id>", (Request request, String id) async {
      try {
        return await DAOProduto().deleteProduto(id)
            ? Response.ok("Produto deletado com sucesso!")
            : Response.internalServerError(body: "Tentativa de delete falhou!");
      } on IDException {
        return Response.badRequest(
            body: "Você precisa fornecer o ID do produto que quer deletar!");
      }
    });

    return route;
  }
}
