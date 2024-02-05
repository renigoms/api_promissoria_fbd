import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';
import 'package:sistema_promissorias/Modules/Contrato/model.dart';
import 'package:sistema_promissorias/Modules/Parcela/DAO.dart';
import 'package:sistema_promissorias/Modules/Parcela/model.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

class ParcelaHandlerController implements ServerUtils {
  @override
  // TODO: implement router
  Router get router {
    final route = Router();

    /// rota get pelo id do contrato
    route.get(
        "/<id_contrato>",
        (Request request, String idContrato) async =>
            ResponseUtils.getResponse(
                await DAOParcela().getByIdContrato(idContrato)));

    /// rota get pelo id do contrato e a data de quitação
    route.get(
        "/<id_contrato>/<data_pag>",
        (Request request, String idContrato, String dataPag) async =>
            ResponseUtils.getResponse(
                await DAOParcela().getByDataPag(idContrato, dataPag)));
    /// rota post
    route.post("/", (Request request) async {
      try {
        return await DAOParcela().postCreate(Contrato.byMap(
                ResponseUtils.dadosReqMap(await request.readAsString())))
            ? Response.ok("Parcelas criadas com sucesso!")
            : Response.internalServerError(
                body: "Erro durante a criação das parcelas detectado!");
      } on IDException {
        return Response.badRequest(
            body: "Você deve passar, e apenas, o id do contrato!");
      } on ParcelasDefinidasException {
        return Response.badRequest(
            body: "As parcelas desse contrato já foram definidas!");
      }on ContractException{
        return Response.badRequest(
          body: "O contrato selecionado não existe na base!"
        );
      } catch (e) {
        return Response.badRequest(body: "Erro ao gerar as parcelas: $e");
      }
    });

    /// update pelo id do contrato e a data de pagamento
    route.put('/<id_contrato>/<data_pag>',
        (Request request, String idContrato, String dataPag) async {
      try {
        return await DAOParcela().putUpdate(
                Parcela.byMap(
                    ResponseUtils.dadosReqMap(await request.readAsString())),
                idContrato,
                dataPag)
            ? Response.ok("Updates realizados com sucesso!")
            : Response.internalServerError(body: "Falha no update!");
      } on NoAlterException {
        return Response.badRequest(
            body: "Você deve alterar o status e somente o status");
      } on IDException {
        return Response.badRequest(
            body: "Você deve passar o id do contrato "
                "e a data da parcela que deseja alterar");
      }on ContractException{
        return Response.badRequest(
            body: "O contrato selecionado não existe na base!"
        );
      }on InstallmentDateException{
        return Response.badRequest(
          body: "Nesse contrato, não existe uma parcela com essa data especificada!"
        );
      } catch (e) {
        return Response.internalServerError(
            body: "Erro ao tentar realizar as alterações solicitadas!");
      }
    });

    return route;
  }
}
