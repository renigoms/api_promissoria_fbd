import 'package:postgres/postgres.dart';
import 'package:sistema_promissorias/Modules/Cliente/DAO.dart';
import 'package:sistema_promissorias/Modules/Cliente/SQL.dart';
import 'package:sistema_promissorias/Modules/Cliente/model.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sprintf/sprintf.dart';

void main() async {
  Result? dados = await Cursor.query(sprintf(SQLCliente.SELECTBYID, [1]));
  final lista = dados!.map((element) => element.toColumnMap()).toList();

  Cliente cliente = Cliente.byMap({
    "id":1,
    "nome_completo":"renata"
  });

  await DAOClientes().updateCliente(cliente);
}
