import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sistema_promissorias/Modules/Cliente/DAO.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

import 'model.dart';

class ClienteHandlerController implements ServerUtils {
  @override
  Router get router {
    final router = Router();

    /// rota get sem parâmetro
    router.get('/',
        (Request request) async {
          String ? search = request.url.queryParameters['search'];

          int ? id = search !=null ? int.tryParse(search):null;

          if (search != null && id == null){
            if (search.length>=4 && search.contains(".") || search.contains("-")) {
              return ResponseUtils.getResponse(await DAOCliente().getByCPF(search));
            }
            return ResponseUtils.getResponse(await DAOCliente().getByName(search));
          }
          return search == null ? ResponseUtils.getResponse(await DAOCliente().getAll()):
          ResponseUtils.getResponse(await DAOCliente().getByID(id.toString()));
        });


    /// rota post
    router.post('/', (Request request) async {
      final map = ResponseUtils.dadosReqMap(await request.readAsString());
      try {
        return await DAOCliente().postCreate(Cliente.byMap(map))
            ? Response.ok("Cliente cadastrado com sucesso!")
            : Response.internalServerError(
                body: "Erro durante o cadastro detectado!");
      } on PgException catch (e) {
        if (e.message
          .contains("duplicar valor da chave viola a restrição de unicidade")) {
            return Response.badRequest(
            body: "Opa, Já existe um cliente com o mesmo CPF que o seu!");
        }

        if (e.message
          .contains("valor é muito longo para tipo character varying(14)")) {
            return Response.badRequest(
            body: "Opa, o cpf adicionado é maior que o permitido!");
        }

         return Response.badRequest(
            body: "Erro inesperado na query => $e");
        
      }on reactiveException{
        return Response.ok("Cliente inativo ativado. "
            "Isso ocorreu porque já existia um cliente inativo com esse cpf na base!");
      } on NullException {
        return Response.badRequest(
            body:
                ResponseUtils.requeredItensMessage(DAOCliente().requeredItens(), map));
      } on IDException {
        return Response.badRequest(
            body: "O ID é adicionado automaticamente, por isso "
                "sua adição manual não é permitida!");
      } catch (e) {
        return Response.badRequest(
            body: "Erro durante o cadastro do cliente: $e");
      }
    });

    // rota put por id
    router.put("/<id>", (Request request, String id) async {
      try {
        return await DAOCliente().putUpdate(
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
      } on ClientException {
        return Response.badRequest(
            body: "O cliente selecionado não existe na base!");
      } catch (e) {
        return Response.badRequest(body: "Falha no update: $e");
      }
    });

    /// rota delete por id
    router.delete("/<id>", (Request request, String id) async {
      try {
        return await DAOCliente().delete(id)
            ? Response.ok("Cliente deletado com sucesso!")
            : Response.internalServerError(body: "Tentativa de delete falhou!");
      } on IDException {
        return Response.badRequest(
            body: "Você precisa fornecer o ID do cliente que quer deletar");
      } on ForeingKeyException {
        return Response.badRequest(
            body:
                "Não foi possível excluir o cliente, pois ele possui um ou mais contratos ativos");
      } on ClientException {
        return Response.badRequest(
            body: "O cliente selecionado não existe na base!");
      } catch (e) {
        return Response.badRequest(body: "Tentativa de delete Falhou: $e");
      }
    });
    return router;
  }
}
