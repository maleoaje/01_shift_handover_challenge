import 'package:get_it/get_it.dart';
import 'package:shift_handover_challenge/features/shift_handover/data/datasources/shift_handover_service.dart';
import 'package:shift_handover_challenge/features/shift_handover/domain/repositories/shift_handover_repository.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register services
  getIt.registerLazySingleton<ShiftHandoverService>(
      () => ShiftHandoverService());

  // Register repositories
  getIt.registerLazySingleton<ShiftHandoverRepository>(
      () => ShiftHandoverRepositoryImpl(getIt<ShiftHandoverService>()));
}
