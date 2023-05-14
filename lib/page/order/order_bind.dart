import 'package:abc_tech_app/controller/order_controller.dart';
import 'package:abc_tech_app/provider/order_provider.dart';
import 'package:abc_tech_app/service/geolocator_service.dart';
import 'package:abc_tech_app/service/order_services.dart';
import 'package:get/instance_manager.dart';

class OrderBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() =>
        OrderController(GeolocationService(), OrderService(OrderProvider())));
  }
}
