import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';
import 'package:sistema_promissorias/Modules/Contrato/DAO.dart';
import 'package:sistema_promissorias/Modules/Contrato/model.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

class ContratoHandlerController implements ServerUtils {
  @override
  // TODO: implement router
  Router get router {
    final route = Router();

    route.get(
        "/",
        (Request request) async =>
            ResponseUtils.getResponse(await DAOContrato().getAll()));

    route.get(
        "/<id>",
        (Request request, String id) async =>
            ResponseUtils.getResponse(await DAOContrato().getByID(id)));

    route.get(
        "/id_cliente/<id_cliente>",
        (Request request, String id) async =>
            ResponseUtils.getResponse(await DAOContrato().getByIDCliente(id)));

    route.post("/", (Request request) async {
      return await DAOContrato().postCreate(Contrato.byMap(
          ResponseUtils.dadosReqMap(await request.readAsString())))
          ? Response.ok("Contrato cadastrado com sucesso!")
          : Response.internalServerError(
          body: "Erro durante o cadastro detectado!");
    });

    route.delete("/", () {});

    return route;
  }
}
