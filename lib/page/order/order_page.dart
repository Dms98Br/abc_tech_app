import 'package:abc_tech_app/controller/order_controller.dart';
import 'package:abc_tech_app/model/assist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/utils.dart';

class OrderPage extends GetView<OrderController> {
  const OrderPage({super.key});

  Widget renderAssists(List<Assist> assistList) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: assistList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(assistList[index].title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.getLocation();
    return Scaffold(
      appBar: AppBar(title: const Text("ABC Tech App")),
      body: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          key: controller.formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Preencha o formulário de ordem de serviço',
                      style: context.theme.textTheme.headlineLarge,
                    ),
                  )
                ],
              ),
              TextFormField(
                controller: controller.operatorIdController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Código do prestador'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 10),
                      child: Text(
                        'Selecione os serviços prestados.',
                        style: context.theme.textTheme.headlineMedium,
                      ),
                    ),
                  ),
                  Ink(
                    decoration: ShapeDecoration(
                      shape: const CircleBorder(),
                      color: context.theme.primaryColor,
                    ),
                    child: IconButton(
                      onPressed: () => controller.editAssist(),
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              Obx(
                () => renderAssists(controller.selectedAssists),
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: controller.finishStartOrder,
                    child: Obx(() {
                      if (controller.screenState.value == OrderState.creating) {
                        return const Text('Iniciar');
                      } else {
                        return const Text('Finalizar');
                      }
                    }),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
