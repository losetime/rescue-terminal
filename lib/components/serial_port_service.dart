import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:usb_serial/usb_serial.dart';

final logger = Logger();

class SerialPortService {
  UsbPort? _port;

  /*
  * @author: wwp
  * @createTime: 2024/9/6 10:55
  * @description: 获取可用串口列表
  */
  Future<List<UsbDevice>> getUsbDevicesList() async {
    try {
      List<UsbDevice> devices = await UsbSerial.listDevices();
      Fluttertoast.showToast(
          msg: '获取串口列表-- $devices', toastLength: Toast.LENGTH_LONG);
      return devices;
    } catch (error) {
      Fluttertoast.showToast(msg: '出错-- $error');
      return [];
    }
  }

  /*
  * @author: wwp
  * @createTime: 2024/9/6 10:56
  * @description: 打开串口
  * @param int baudRate：波特率 串口通信的传输速率，通常用每秒传输的比特数（bps）来表示。常见的波特率值包括 9600、19200、38400、115200 等,默认值9600
  * @param int bits：数据位 是每次通信中实际传输的数据位数。常见的值为 7 或 8。通常情况下使用 8
  * @param int stopBits：停止位 用于标识一帧数据的结束，接收端会据此判断数据包的边界。常见的停止位配置为 1 或 2
  * @param SerialPortParity(枚举类型) parity：校验位 校验位用于检测通信中的错误。校验位可以设置为无校验、奇校验、偶校验等。
  *        枚举值如下：
           SerialPortParity.none：无校验
           SerialPortParity.odd：奇校验
           SerialPortParity.even：偶校验
           SerialPortParity.mark：保持校验位为1
           SerialPortParity.space：保持校验位为0
  * @return
  */
  Future<bool> openPort(UsbDevice device,
      {int baudRate = 9600,
      int dataBits = UsbPort.DATABITS_8,
      int stopBits = UsbPort.STOPBITS_1,
      int parity = UsbPort.PARITY_NONE}) async {
    try {
      _port = await device.create() as UsbPort;
      if (_port == null) {
        Fluttertoast.showToast(msg: '创建通信通道失败');
        return false;
      }
      bool openResult = await _port!.open();
      if (openResult) {
        Fluttertoast.showToast(msg: '通信通道已建立');
      } else {
        Fluttertoast.showToast(msg: '通信通道打开失败');
        return false;
      }
      await _port!.setDTR(true);
      await _port!.setRTS(true);

      _port!.setPortParameters(baudRate, dataBits, stopBits, parity);
      return true;
    } catch (error) {
      Fluttertoast.showToast(msg: '通道异常');
      return false;
    }
  }

  /*
  * @author: wwp
  * @createTime: 2024/9/6 11:16
  * @description: 关闭串口
  * @param
  * @return
  */
  void closePort() async {
    try {
      if (_port != null) {
        final isClose = await _port!.close();
        if (isClose) {
          _port = null;
          Fluttertoast.showToast(msg: '通信通道已关闭');
        }
      }
    } catch (error) {
      logger.d(error);
    }
  }

  /*
  * @author: wwp
  * @createTime: 2024/9/6 11:20
  * @description: 写数据到串口
  * @param
  * @return
  */
  Future writeData(String data) async {
    if (_port == null) {
      return;
    }
    final dataTrans = Uint8List.fromList(data.codeUnits);
    await _port!.write(dataTrans);
  }

  /*
  * @author: wwp
  * @createTime: 2024/9/6 11:43
  * @description: 读取串口数据
  * @param
  * @return
  */
  void readData(Function(String data) onDataReceived) {
    if (_port == null) return;
    _port!.inputStream?.listen((Uint8List event) {
      Fluttertoast.showToast(
        msg: '接收到串口数据--- $event',
        toastLength: Toast.LENGTH_LONG,
      );
      try {
        String msg = utf8.decode(event);
        onDataReceived(msg);
      } catch (error) {
        logger.e(error);
      }
    });
  }
}
