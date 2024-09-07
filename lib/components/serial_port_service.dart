// import 'dart:typed_data';
// import 'package:flutter_libserialport/flutter_libserialport.dart';
// import 'package:logger/logger.dart';
// // import 'package:permission_handler/permission_handler.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// final logger = Logger();
//
// class SerialPortService {
//   SerialPort? _port;
//   SerialPortReader? _reader;
//
//   /*
//   * @author: wwp
//   * @createTime: 2024/9/6 10:55
//   * @description: 获取可用串口列表
//   */
//   List<String> getAvailablePorts() {
//     try{
//       Fluttertoast.showToast(msg: '${SerialPort.availablePorts}');
//       return SerialPort.availablePorts;
//     }catch(error){
//       // print(error);
//       Fluttertoast.showToast(msg: '出错-- $error');
//       return [];
//     }
//   }
//
//   /*
//   * @author: wwp
//   * @createTime: 2024/9/6 10:56
//   * @description: 打开串口
//   * @param int baudRate：波特率 串口通信的传输速率，通常用每秒传输的比特数（bps）来表示。常见的波特率值包括 9600、19200、38400、115200 等,默认值9600
//   * @param int bits：数据位 是每次通信中实际传输的数据位数。常见的值为 7 或 8。通常情况下使用 8
//   * @param int stopBits：停止位 用于标识一帧数据的结束，接收端会据此判断数据包的边界。常见的停止位配置为 1 或 2
//   * @param SerialPortParity(枚举类型) parity：校验位 校验位用于检测通信中的错误。校验位可以设置为无校验、奇校验、偶校验等。
//   *        枚举值如下：
//            SerialPortParity.none：无校验
//            SerialPortParity.odd：奇校验
//            SerialPortParity.even：偶校验
//            SerialPortParity.mark：保持校验位为1
//            SerialPortParity.space：保持校验位为0
//   * @return
//   */
//   bool openPort(String portName, {int baudRate = 9600, int dataBits = 8, int stopBits = 1, int parity = SerialPortParity.none}) {
//     _port = SerialPort(portName);
//     if (_port == null || !_port!.openReadWrite()) {
//       logger.e('Failed to open port: $portName');
//       return false;
//     }
//
//     // 配置串口参数
//     final config = SerialPortConfig()
//       ..baudRate = baudRate
//       ..bits = dataBits
//       ..stopBits = stopBits
//       ..parity = parity;
//
//     _port!.config = config;
//     logger.d('Port $portName opened successfully');
//     return true;
//   }
//
//   /*
//   * @author: wwp
//   * @createTime: 2024/9/6 11:16
//   * @description: 关闭串口
//   * @param
//   * @return
//   */
//   void closePort() {
//     if(_port != null && _port!.isOpen) {
//       _port!.close();
//       _port = null;
//       logger.d('端口已经成功关闭');
//     }
//   }
//
//   /*
//   * @author: wwp
//   * @createTime: 2024/9/6 11:20
//   * @description: 写数据到串口
//   * @param
//   * @return
//   */
//   bool writeData(String data) {
//     if (_port == null || !_port!.isOpen) {
//       logger.d('writeData-- Port is not open');
//       return false;
//     }
//     final dataTrans = Uint8List.fromList(data.codeUnits);
//     final bytesWritten = _port!.write(dataTrans);
//     if (bytesWritten > 0) {
//       logger.d('writeData-- Data written successfully');
//       // 写入成功
//       return true;
//     } else {
//       logger.e('writeData-- Failed to write data');
//       // 写入失败
//       return false;
//     }
//   }
//
//   /*
//   * @author: wwp
//   * @createTime: 2024/9/6 11:43
//   * @description: 读取串口数据
//   * @param
//   * @return
//   */
//   void readData(Function(Uint8List data) onDataReceived) {
//     if (_port == null || !_port!.isOpen) {
//       logger.e('Port is not open');
//       return;
//     }
//     // 监听串口数据
//     _reader = SerialPortReader(_port!);
//     _reader!.stream.listen(onDataReceived);
//   }
//
//   /*
//   * @author: wwp
//   * @createTime: 2024/9/6 11:45
//   * @description: 检查串口是否打开
//   * @param
//   * @return
//   */
//   bool isPortOpen() {
//     return _port != null && _port!.isOpen;
//   }
// }

class SerialPortService {}