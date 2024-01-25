import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';
import 'package:sistema_promissorias/Modules/Contrato/DAO.dart';
import 'package:sistema_promissorias/Modules/Contrato/model.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

class ContratoHandlerController implements ServerUtils {
  @override
  // TODO: implement router
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
        (Request request, String cpf_cliente) async =>
            ResponseUtils.getResponse(
                await DAOContrato().getByClienteCPF(cpf_cliente)));
    /// rota post
    route.post("/", (Request request) async {
      try {
        return await DAOContrato().postCreate(Contrato.byMap(
                ResponseUtils.dadosReqMap(await request.readAsString())))
            ? Response.ok("Contrato gerado com sucesso!")
            : Response.internalServerError(
                body: "Erro ao gerar contrato!");
      } on NullException {
        return Response.badRequest(
            body: "Alguns atributos necessários "
                "não foram preenchidos!");
      }catch (e) {
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
      } on ParcelasEmAbertoExcerption {
        return Response.badRequest(
            body: "Ainda existem parcelas em aberto nesse contrato!");
      } catch (e) {
        return Response.badRequest(body: "Erro ao deletar: $e");
      }
    });

    return route;
  }
}
