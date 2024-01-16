import 'package:postgres/legacy.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sistema_promissorias/Modules/Cliente/DAO.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

import 'model.dart';

class ClienteHandlerController implements ServerUtils {
  Router get router {
    final router = Router();

    router.get(
        '/',
        (Request request) async =>
            ResponseUtils.getResponse(await DAOClientes().getAll()));

    router.get(
        "/<id>",
        (Request request, String id) async =>
            ResponseUtils.getResponse(await DAOClientes().getByID(id)));

    router.get(
        "/cpf/<cpf>",
        (Request request, String cpf) async =>
            ResponseUtils.getResponse(await DAOClientes().getByCPF(cpf)));

    router.post('/', (Request request) async {
      try {
        return await DAOClientes().postCreate(Cliente.byMap(
                ResponseUtils.dadosReqMap(await request.readAsString())))
            ? Response.ok("Cliente cadastrado com sucesso!")
            : Response.internalServerError(
                body: "Erro durante o cadastro detectado!");
      } on PgException {
        return Response.badRequest(
            body: "Opa, Já existe um cliente com o mesmo CPF que o seu!");
      } on NullException {
        return Response.badRequest(
            body: "Alguns atributos não foram preenchidos!");
      } catch (e) {
        return Response.badRequest(
            body: "Erro durante o cadastro do cliente: $e");
      }
    });

    router.put("/<id>", (Request request, String id) async {
      try {
        return await DAOClientes().putUpdate(
                Cliente.byMap(
                    ResponseUtils.dadosReqMap(await request.readAsString())),
                id)
            ? Response.ok("Updates realizados com sucesso!")
            : Response.internalServerError(body: "Falha no update!");
      } on IDException {
        return Response.badRequest(
            body:
                "O id deve ser passado junto com os dados que serão alterados");
      } on NoAlterException {
        return Response.badRequest(
            body: "O id do cliente não pode ser alterado!");
      } catch (e) {
        return Response.badRequest(body: "Falha no update: $e");
      }
    });

    router.delete("/<id>", (Request request, String id) async {
      try {
        return await DAOClientes().delete(id)
            ? Response.ok("Cliente deletado com sucesso!")
            : Response.internalServerError(body: "Tentativa de delete falhou!");
      } on IDException {
        return Response.badRequest(
            body: "Você precisa fornecer o ID do cliente que quer deletar");
      } on PgException {
        return Response.badRequest(
            body:
                "Não foi possível excluir o cliente, pois ele possui um ou mais contratos ativos");
      } catch (e) {
        return Response.badRequest(body: "Tentativa de delete Falhou: $e");
      }
    });
    return router;
  }
}
