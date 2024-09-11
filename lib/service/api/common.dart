import 'package:rescue_terminal/service/http/index.dart';

class CommonAPI {
  Future<dynamic> apiGetAppPackageInfo() async {
    try {
      final response = await DioClient.instance.get("/api/version");
      print(response);
      return response.data;
    } catch (e) {
      print("Error: $e");
    }
  }
}
