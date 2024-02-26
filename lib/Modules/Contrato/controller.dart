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

    route.get("/", (Request request) async {
      String? search = request.url.queryParameters['search'];

      return search == null
          ? ResponseUtils.getResponse(await DAOContrato().getAll())
          : ResponseUtils.getResponse(
              await DAOContrato().getBySearch(search));
    });

    /// rota post
    route.post("/", (Request request) async {
      final map = ResponseUtils.dadosReqMap(await request.readAsString());
      try {
        if (UtilsGeral.isAutoItensNotNull(map, DAOContrato().autoItens())) {
          throw AutoValueException();
        }

        if (UtilsGeral.isRequeredItensNull(
            map, DAOContrato().requeredItens())) {
          throw NullException();
        }

        return await DAOContrato().postCreate(Contrato.byMap(map))
            ? Response.ok("Contrato gerado com sucesso!")
            : Response.internalServerError(body: "Erro ao gerar contrato!");
      } on NullException {
        return ResponseUtils.getBadResponse(ResponseUtils.requeredItensMessage(
            DAOContrato().requeredItens(), map));
      } on AutoValueException {
        return ResponseUtils.getBadResponse(ResponseUtils.autoItensMessage(DAOContrato().autoItens(), map));
      } on ProductException {
        return ResponseUtils.getBadResponse("O produto selecionado não existe na base!");
      } on ClientException {
        return ResponseUtils.getBadResponse("O cliente selecionado não existe na base!");
      } catch (e) {
        return ResponseUtils.getBadResponse("Erro ao gerar contrato: $e");
      }
    });

    /// rota delete
    route.delete("/<id>", (Request request, String id) async {
      try {
        return await DAOContrato().delete(id)
            ? Response.ok("Contrato e parcelas deletadas")
            : Response.internalServerError(
                body: "Erro durante a tentativa de delete");
      } on ForeingKeyException {
        return ResponseUtils.getBadResponse("Algumas parcelas ainda estão ativas nesse contrato!");
      } on IDException {
        return ResponseUtils.getBadResponse("Você precisa fornecer o ID do produto que quer deletar!");
      } on OpenInstallmentsException {
        return ResponseUtils.getBadResponse("Ainda existem parcelas em aberto nesse contrato!");
      } on ContractException {
        return ResponseUtils.getBadResponse("O contrato selecionado não existe na base!");
      } catch (e) {
        return ResponseUtils.getBadResponse("Erro ao deletar: $e");
      }
    });

    return route;
  }
}
