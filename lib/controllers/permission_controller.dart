import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionController extends GetxController {
  Future<void> checkAndRequestPermissions() async {
    var status = await Permission.phone.status;
    if (status.isDenied) {
      await Permission.phone.request();
    }
  }
}
