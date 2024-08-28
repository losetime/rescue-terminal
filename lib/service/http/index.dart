import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DioClient {
  // 私有构造函数
  DioClient._internal();

  // 创建单例
  static final DioClient _instance = DioClient._internal();

  // 提供工厂构造函数返回单例
  factory DioClient() => _instance;

  late Dio dio;

  // 初始化 Dio 配置
  void init({
    required String baseUrl,
    int connectTimeout = 5000,
    int receiveTimeout = 3000,
    Map<String, String>? defaultHeaders,
  }) {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: connectTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      headers: defaultHeaders ?? {
        'Content-Type': 'application/json',
      },
    ));

    // 如果你需要添加拦截器
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 可以在这里添加统一的 token 或者其他逻辑
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // 处理响应
        // print(response.data['version']);
        if(response.statusCode == 200) {
          return handler.next(response);
        } else {
          Fluttertoast.showToast(
            msg: '请求出错',
          );
        }
      },
      onError: (DioException error, handler) {
        // 处理错误
        return handler.next(error);
      },
    ));
  }

  // 单例中的 Dio 实例
  static Dio get instance => _instance.dio;
}