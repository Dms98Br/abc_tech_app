import 'package:abc_tech_app/model/assist.dart';
import 'package:abc_tech_app/model/order.dart';
import 'package:abc_tech_app/model/order_location.dart';
import 'package:abc_tech_app/service/geolocator_service.dart';
import 'package:abc_tech_app/service/order_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:developer';

enum OrderState { creating, started, finished }

class OrderController extends GetxController {
  final GeolocationServiceInterface _geolocationService;
  final OrderServiceInterface _orderService;
  final formKey = GlobalKey<FormState>();
  final operatorIdController = TextEditingController();
  final selectedAssists = <Assist>[].obs;
  late Order _order;
  final screenState = OrderState.creating.obs;
  OrderController(this._geolocationService, this._orderService);
  @override
  void onInt() {
    super.onInit();
    _geolocationService.start();
  }

  getLocation() {
    _geolocationService
        .getPosition()
        .then((value) => log(value.toJson().toString()));
  }

  editAssist() {
    Get.toNamed('/services', arguments: selectedAssists);
  }

  finishStartOrder() {
    print(screenState.value);
    switch (screenState.value) {
      case OrderState.creating:
        _geolocationService.getPosition().then((value) {
          var start = OrderLocation(
              latitude: value.latitude,
              longitude: value.longitude,
              date: DateTime.now());
          List<int> assist =
              selectedAssists.map((element) => element.id).toList();
          _order = Order(
              operatorId: int.parse(operatorIdController.text),
              services: assist);
          _order.start = start;
          screenState.value = OrderState.started;
        });

        break;
      case OrderState.started:
        //TODO: Fazer tratativa
        _geolocationService.getPosition().then((value) {
          var end = OrderLocation(
              latitude: value.latitude,
              longitude: value.longitude,
              date: DateTime.now());
          _order.end = end;
          screenState.value = OrderState.finished;
          _createOrder();
        });
        break;
      case OrderState.finished:
        //TODO: Fazer tratativa
        screenState.value = OrderState.creating;
        break;
      default:
    }
  }

  void _createOrder() {
    _orderService.createOrder(_order).then((value) {
      print(value);
      if (value) {
        Get.snackbar('Sucesso', 'Ordem aberto com sucesso!',
            backgroundColor: Colors.green);
      } else {
        Get.snackbar('Erro', 'Problema ao criar ordem!',
            backgroundColor: Colors.red);
      }
    }).onError((error, stackTrace) {
      print(error);
      Get.snackbar(
          'Erro', 'Problema ao criar ordem! Entre em contato com suporte!',
          backgroundColor: Colors.red);
    });
  }
}
