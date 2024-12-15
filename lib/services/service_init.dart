import 'global/global_service.dart';

abstract class ServiceInit {
  static init() async {
    await GlobalService().init();
  }
}
