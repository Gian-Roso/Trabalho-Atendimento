// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:baquadrix/core/database/app_db.dart' as _i151;
import 'package:baquadrix/modules/home/controller/cadastro_controller.dart'
    as _i402;
import 'package:baquadrix/modules/home/controller/home_controller.dart'
    as _i137;
import 'package:baquadrix/modules/home/controller/lista_controller.dart'
    as _i638;
import 'package:baquadrix/modules/home/core/domain/contract/repository/atendimento_repository.dart'
    as _i532;
import 'package:baquadrix/modules/home/core/domain/contract/usecase/atendimento_usecase.dart'
    as _i650;
import 'package:baquadrix/modules/home/core/domain/usecase/atendimento_usecase_impl.dart'
    as _i359;
import 'package:baquadrix/modules/home/data/repository/atendimento_repository_impl.dart'
    as _i653;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i151.AppDB>(() => _i151.AppDB());
    gh.lazySingleton<_i532.AtendimentoRepository>(
      () => _i653.AtendimentoRepositoryImpl(dbProvider: gh<_i151.AppDB>()),
    );
    gh.lazySingleton<_i650.AtendimentoUsecase>(
      () => _i359.AtendimentoUsecaseImpl(
        repository: gh<_i532.AtendimentoRepository>(),
      ),
    );
    gh.factory<_i402.CadastroController>(
      () => _i402.CadastroController(gh<_i650.AtendimentoUsecase>()),
    );
    gh.factory<_i137.HomeController>(
      () => _i137.HomeController(gh<_i650.AtendimentoUsecase>()),
    );
    gh.factory<_i638.ListaController>(
      () => _i638.ListaController(gh<_i650.AtendimentoUsecase>()),
    );
    return this;
  }
}
