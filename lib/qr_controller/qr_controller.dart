import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QrController {
  QRViewController? qrViewController;

  static final QrController qrControllerInstance = QrController._internal();
  QrController._internal() {
    print('qr controller initialized');
  }

  factory QrController() {
    return qrControllerInstance;
  }

  QRViewController? getController() => qrViewController;

  setController({required QRViewController controller}) {
    qrViewController = controller;
  }
}
