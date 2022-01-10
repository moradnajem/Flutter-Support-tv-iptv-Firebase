import 'package:get_it/get_it.dart';
import 'package:tv/core/viewmodels/CameraStreamsViewModel.dart';
import 'package:tv/manger/M.S.dart';


GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton<FireStoreApiService>(
          () => FireStoreApiService('camerastreams'));
  locator.registerLazySingleton<CameraStreamsViewModel>(
          () => CameraStreamsViewModel());
}
