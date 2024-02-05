// ignore_for_file: implementation_imports

import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';
import 'package:sistema_promissorias/Modules/Contrato/DAO.dart';
import 'package:sistema_promissorias/Modules/Contrato/model.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

class ContratoHandlerController implements ServerUtils {
  @override
  Router get router {
    final route = Router();

    /// rota get sem parâmetro
    route.get(
        "/",
        (Request request) async =>
            ResponseUtils.getResponse(await DAOContrato().getAll()));

    /// rota get por id
    route.get(
        "/<id>",
        (Request request, String id) async =>
            ResponseUtils.getResponse(await DAOContrato().getByID(id)));

    /// rota get por cpf
    route.get(
        "/cpf_cliente/<cpf>",
        (Request request, String cpfCliente) async =>
            ResponseUtils.getResponse(
                await DAOContrato().getByClienteCPF(cpfCliente)));

    /// rota post
    route.post("/", (Request request) async {
      final map = ResponseUtils.dadosReqMap(await request.readAsString());
      try {
        if (UtilsGeral.isKeysExists("parcela_definida", map)) {
          throw ParcelaDefinidaException();
        }
        return await DAOContrato()
                .postCreate(Contrato.byMap(map))
            ? Response.ok("Contrato gerado com sucesso!")
            : Response.internalServerError(body: "Erro ao gerar contrato!");
      } on NullException {
        return Response.badRequest(
            body: ResponseUtils.requeredItensMessage(DAOContrato().requeredItens(), map));
      } on AutoValueException {
        return Response.badRequest(
            body: ResponseUtils.autoItensMessage(DAOContrato().autoItens(), map));
      } on ProductException {
        return Response.badRequest(
            body: "O produto selecionado não existe na base!");
      } on ClientException {
        return Response.badRequest(
            body: "O cliente selecionado não existe na base!");
      }on ParcelaDefinidaException{
        return Response.badRequest(
          body: "O campo da parcela_definida é estabelecido automaticamente. Portando,"
              "não é permitido adiciona-lo de forma manual!"
        );
      } catch (e) {
        return Response.badRequest(body: "Erro ao gerar contrato: $e");
      }
    });

    /// rota delete
    route.delete("/<id>", (Request request, String id) async {
      try {
        return await DAOContrato().delete(id)
            ? Response.ok("Contrato e parcelas deletadas")
            : Response.internalServerError(
                body: "Erro durante a tentativa de delete");
      } on IDException {
        return Response.badRequest(
            body: "Você precisa fornecer o ID do produto que quer deletar!");
      } on OpenInstallmentsException {
        return Response.badRequest(
            body: "Ainda existem parcelas em aberto nesse contrato!");
      } on ContractException {
        return Response.badRequest(
            body: "O contrato selecionado não existe na base!");
      } catch (e) {
        return Response.badRequest(body: "Erro ao deletar: $e");
      }
    });

    return route;
  }
}
