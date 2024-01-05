import 'package:postgres/legacy.dart';
import 'package:postgres/postgres.dart';
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
      } on PgException {
        return Response.badRequest(
            body: "Opa, Já existe um produto com o mesmo nome!");
      }on NullException{
        return Response.badRequest(
            body: "Alguns atributos necessários não foram preenchidos!"
        );
      }
    });

    route.put("/<id>", (Request request, String id) async {
      try {
        return await DAOProduto().putUpdate(Produto.byMap(
                ResponseUtils.dadosReqMap(await request.readAsString())),id)
            ? Response.ok("Updates realizados com sucesso!")
            : Response.internalServerError(body: "Falha no update!");
      } on IDException {
        return Response.badRequest(
            body:
                "O id deve ser passado junto com os dados que serão alterados");
      }on NoAlterException{
        return Response.badRequest(body: "O id não pode ser alterado!");
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
      }on PgException{
        return Response.badRequest(
          body: "Não foi possível excluir o seguinte produto, pois ele faz "
              "parte de um ou mais contratos ativos!"
        );
      }
    });

    return route;
  }
}
