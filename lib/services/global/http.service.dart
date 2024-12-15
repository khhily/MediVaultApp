part of 'global_service.dart';

class HttpService extends GetxService {
  HttpService._();

  factory HttpService() => Get.find<HttpService>();

  late final Dio _dio;

  Dio get http => _dio;

  @override
  void onInit() {
    _dio = Dio();
    super.onInit();
  }
}
