import 'dart:convert';

import 'package:postgres/legacy.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sistema_promissorias/Modules/Cliente/DAO.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

import 'model.dart';

class ClienteHandlerController implements ServerUtils {
  Map<String,dynamic> _dadosReqMap(String strReq) => jsonDecode(strReq);
  Router get router {
    final router = Router();

    router.get('/', (Request request) async {
      try {
        final listMap = await DAOClientes().getAll();
        return Response.ok(jsonEncode(listMap));
      } catch (e) {
        return Response.forbidden("Erro, ${e.toString()}");
      }
    });

    router.get("/<id>", (Request request, String id) async {
      try {
        return Response.ok(jsonEncode(await DAOClientes().getByID(id)));
      } catch (e) {
        return Response.internalServerError(
            body: "Erro ao buscar por id, ${e.toString()}");
      }
    });

    router.get("/cpf/<cpf>",
        (Request request, String cpf) async {
      try {
        return Response.ok(
            jsonEncode(await DAOClientes().getByName(cpf)));
      } catch (e) {
        return Response.internalServerError(
            body: "Erro ao buscar por nome, ${e.toString()}");
      }
    });

    router.post('/', (Request request) async {

      try{
        return await DAOClientes().
        postCreateCliente(
            Cliente.byMap(
                _dadosReqMap(
                    await request.readAsString()
                )
            )
        ) ? Response.ok("Cliente cadastrado com sucesso!")
            : Response.internalServerError(
            body: "Erro durante o cadastro detectado!");
      }on PostgreSQLException{
        return Response.badRequest(
          body: "Opa, Já existe um cliente com o mesmo CPF que o seu!"
        );
      }
    });

    router.put("/", (Request request) async {
      try{
        return await DAOClientes().updateCliente(
            Cliente.byMap(
                _dadosReqMap(
                    await request.readAsString()
                )
            )
        )?
        Response.ok("Updates realizados com sucesso!"):
        Response.internalServerError(body: "Falha no update!");
      }on IDException{
        return Response.badRequest(
          body: "O id deve ser passado junto com os dados que serão alterados"
        );
      }
    });

    router.delete("/<id>", (Request request, String id) async {
      try{
        return await DAOClientes().deleteCliente(id) ?
        Response.ok("Cliente deletado com sucesso!"):
            Response.internalServerError(body: "Tentativa de delete falhou!");
      }on IDException{
        return Response.badRequest(
            body: "Você precisa fornecer o ID do cliente que quer deletar");
      }
    });
    return router;
  }
}
