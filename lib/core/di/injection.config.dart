// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:trabfinal/core/database/app_db.dart' as _i246;
import 'package:trabfinal/modules/home/controller/cadastro_controller.dart'
    as _i130;
import 'package:trabfinal/modules/home/controller/home_controller.dart'
    as _i149;
import 'package:trabfinal/modules/home/core/domain/contract/repository/atendimento_repository.dart'
    as _i1013;
import 'package:trabfinal/modules/home/core/domain/contract/usecase/atendimento_usecase.dart'
    as _i892;
import 'package:trabfinal/modules/home/core/domain/usecase/atendimento_usecase_impl.dart'
    as _i517;
import 'package:trabfinal/modules/home/data/repository/atendimento_repository_impl.dart'
    as _i478;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i246.AppDB>(() => _i246.AppDB());
    gh.lazySingleton<_i1013.AtendimentoRepository>(
      () => _i478.AtendimentoRepositoryImpl(dbProvider: gh<_i246.AppDB>()),
    );
    gh.lazySingleton<_i892.AtendimentoUsecase>(
      () => _i517.AtendimentoUsecaseImpl(
        repository: gh<_i1013.AtendimentoRepository>(),
      ),
    );
    gh.factory<_i130.CadastroController>(
      () => _i130.CadastroController(gh<_i892.AtendimentoUsecase>()),
    );
    gh.factory<_i149.HomeController>(
      () => _i149.HomeController(gh<_i892.AtendimentoUsecase>()),
    );
    return this;
  }
}
