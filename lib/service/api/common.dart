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

  Future<dynamic> apiGetUserList() async {
    try {
      final response = await DioClient.instance.get("/user/list");
      print(response);
      return response.data;
    } catch (e) {
      print("Error: $e");
    }
  }
}
