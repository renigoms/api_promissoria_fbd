import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';
import 'package:sistema_promissorias/Modules/Parcela/DAO.dart';
import 'package:sistema_promissorias/Modules/Parcela/model.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

class ParcelaHandlerController implements ServerUtils {
  @override
  // TODO: implement router
  Router get router {
    final route = Router();

    route.get("/", (Request request) async {
      String? idContrato = request.url.queryParameters['id_contrato'],
          dataPag = request.url.queryParameters['data_pag'];

      if (idContrato != null && dataPag == null) {
        return ResponseUtils.getResponse(
            await DAOParcela().getByIdContrato(idContrato));
      }

      if (idContrato != null && dataPag != null) {
        return ResponseUtils.getResponse(
            await DAOParcela().getByDataPag(idContrato, dataPag));
      }

      return ResponseUtils.getResponse([]);
    });

    /// update pelo id do contrato e a data de pagamento
    route.put('/', (Request request) async {
      try {
        String ? idContrato = request.url.queryParameters['id_contrato'],
        
        dataPag = request.url.queryParameters['data_pag'];

        return await DAOParcela().putUpdate(
                Parcela.byMap(
                    ResponseUtils.dadosReqMap(await request.readAsString())),
                idContrato!,
                dataPag!)
            ? Response.ok("Updates realizados com sucesso!")
            : Response.internalServerError(body: "Falha no update!");
      } on NoAlterException {
        return Response.badRequest(
            body: "Você deve alterar o status e somente o status");
      } on IDException {
        return Response.badRequest(
            body: "Você deve passar o id do contrato "
                "e a data da parcela que deseja alterar");
      } on ContractException {
        return Response.badRequest(
            body: "O contrato selecionado não existe na base!");
      } on ParcelaException {
        return Response.badRequest(
            body:
                "Nesse contrato, não existe uma parcela com essa data especificada!");
      } catch (e) {
        return Response.internalServerError(
            body: "Erro ao tentar realizar as alterações solicitadas!");
      }
    });

    return route;
  }
}
