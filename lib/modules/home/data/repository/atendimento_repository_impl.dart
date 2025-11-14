import 'package:injectable/injectable.dart';
import 'package:trabfinal/core/database/app_db.dart';
import 'package:trabfinal/modules/home/core/domain/contract/repository/atendimento_repository.dart';
import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';

@LazySingleton(as: AtendimentoRepository)
class AtendimentoRepositoryImpl implements AtendimentoRepository{
  final AppDB dbProvider;

  AtendimentoRepositoryImpl (
    {
      required this.dbProvider
    }
  );
  
  @override
  Future<List<AtendimentoModel>> getAtendimentos() async {
   final db = await dbProvider.database;
   final result = await db.query('atendimento');
   return result.map((e) => AtendimentoModel.fromMap(e)).toList();
  }

  @override
  Future<AtendimentoModel> getAtendimento(int id) async {
   final db = await dbProvider.database;
   final response = await db.query(
    'atendimento',
    where: 'id = ?',
    whereArgs: [id],
   );
   return AtendimentoModel.fromMap(response.first);
  }


  @override
  Future<void> postAtendimento(AtendimentoModel atendimentoModel) async {
   final db = await dbProvider.database;
   await db.insert('atendimento', atendimentoModel.toMap());
   return;
  }

  @override
  Future<void> putAtendimento(AtendimentoModel atendimentoModel, int id) async {
    final db = await dbProvider.database;
    await db.update('atendimento', atendimentoModel.toMap(),
    where: 'id = ?',whereArgs: [id]);
   return;
  }
    @override
  Future<void> deleteAtendimento(int id) async {
   final db = await dbProvider.database;
   await db.delete('atendimento', where: 'id = ?', whereArgs: [id]);
   return;
  }
  @override
Future<void> deleteVarios(List<int> ids) async {
  final db = await dbProvider.database;

  for (final id in ids) {
    await db.delete(
      'atendimento',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
}