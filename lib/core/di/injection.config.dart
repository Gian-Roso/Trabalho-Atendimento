// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:Baquadrix/core/database/app_db.dart' as _i645;
import 'package:Baquadrix/modules/home/controller/cadastro_controller.dart'
    as _i369;
import 'package:Baquadrix/modules/home/controller/home_controller.dart'
    as _i798;
import 'package:Baquadrix/modules/home/controller/lista_controller.dart'
    as _i386;
import 'package:Baquadrix/modules/home/core/domain/contract/repository/atendimento_repository.dart'
    as _i418;
import 'package:Baquadrix/modules/home/core/domain/contract/usecase/atendimento_usecase.dart'
    as _i93;
import 'package:Baquadrix/modules/home/core/domain/usecase/atendimento_usecase_impl.dart'
    as _i965;
import 'package:Baquadrix/modules/home/data/repository/atendimento_repository_impl.dart'
    as _i108;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i645.AppDB>(() => _i645.AppDB());
    gh.lazySingleton<_i418.AtendimentoRepository>(
      () => _i108.AtendimentoRepositoryImpl(dbProvider: gh<_i645.AppDB>()),
    );
    gh.lazySingleton<_i93.AtendimentoUsecase>(
      () => _i965.AtendimentoUsecaseImpl(
        repository: gh<_i418.AtendimentoRepository>(),
      ),
    );
    gh.factory<_i369.CadastroController>(
      () => _i369.CadastroController(gh<_i93.AtendimentoUsecase>()),
    );
    gh.factory<_i798.HomeController>(
      () => _i798.HomeController(gh<_i93.AtendimentoUsecase>()),
    );
    gh.factory<_i386.ListaController>(
      () => _i386.ListaController(gh<_i93.AtendimentoUsecase>()),
    );
    return this;
  }
}
