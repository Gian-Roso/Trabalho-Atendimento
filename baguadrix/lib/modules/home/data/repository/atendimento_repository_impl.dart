import 'package:baquadrix/core/database/app_db.dart';
import 'package:baquadrix/modules/home/core/domain/contract/repository/atendimento_repository.dart';
import 'package:baquadrix/modules/home/core/domain/model/atendimento_model.dart';
import 'package:injectable/injectable.dart';

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
  Future<AtendimentoModel> postAtendimento(AtendimentoModel atendimentoModel) async {
    final db = await dbProvider.database;
    
    final map = atendimentoModel.toMap();
    map.remove('id');
    map.remove('criado_em'); 
    
    final id = await db.insert('atendimento', map);
    
    final result = await db.query('atendimento', where: 'id = ?', whereArgs: [id]);
    return AtendimentoModel.fromMap(result.first);
  }

  @override
  Future<AtendimentoModel> putAtendimento(AtendimentoModel atendimentoModel, int id) async {
    final db = await dbProvider.database;
    await db.update('atendimento', atendimentoModel.toMap(),
        where: 'id = ?', whereArgs: [id]);
    return atendimentoModel.copyWith(id: id);
  }
    @override
  Future<void> deleteAtendimento(int id) async {
   final db = await dbProvider.database;
   await db.delete('atendimento', where: 'id = ?', whereArgs: [id]);
   return;
  }
}