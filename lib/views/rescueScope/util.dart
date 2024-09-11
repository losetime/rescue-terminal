import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:usb_serial/usb_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';

class User {
  final String id;
  final String name;
  final String avatar;
  final Offset position;
  final bool isNew;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.position,
    this.isNew = true,
  });
}

Future<String> serialPortService() async {
  try{
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      return '';
    }
    UsbPort port = await devices[0].create() as UsbPort;
    bool openResult = await port.open();
    if (!openResult) {
      Fluttertoast.showToast(msg: '串口打开失败', toastLength: Toast.LENGTH_LONG);
    }
    await port.setDTR(true);
    await port.setRTS(true);

    port.setPortParameters(115200, UsbPort.DATABITS_8,UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    port.inputStream?.listen((Uint8List event) {
      String msg = utf8.decode(event);
      Fluttertoast.showToast(msg: '接收到原始数据--- $event', toastLength: Toast.LENGTH_LONG);
      Future.delayed(const Duration(seconds: 5), (){
        Fluttertoast.showToast(msg: '接收到串口数据--- $msg', toastLength: Toast.LENGTH_LONG);
      });
    });
    return '';
  }catch(error){
    Fluttertoast.showToast(msg: '串口服务异常：$error');
    return '';
  }
}