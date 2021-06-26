import 'package:epub_reader/core/services/local_db_service.dart';
import 'package:epub_reader/core/services/url_launcher_service.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';


final locator = GetIt.instance;

Future setupLocator() async {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => LocalDBService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => UrlLauncherService());

}
