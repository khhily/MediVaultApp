import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_vault/models/enum/medication_stock_operation.dart';
import 'package:medi_vault/utils/form_value_converter.dart';
import 'package:medi_vault/widgets/form_fields/app_text_form_field.dart';

import 'add_medication_stock_page.controller.dart';

class AddMedicationStockPage extends GetView<AddMedicationStockPageController> {
  const AddMedicationStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            controller.operationType.value == MedicationStockOperation.increment
                ? '入库'
                : '出库'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              controller.saveAndClose(context);
            },
            child: const Text('保存'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextFormField<String>(
                label: '药品名称',
                readOnly: controller.nameReadonly.value,
                onChanged: (v) {
                  controller.name.value = v ?? '';
                },
                initialValue: controller.name.value,
                enabled: !controller.nameReadonly.value,
                validator: (v) {
                  if (v == null || v.isEmpty) return '请填写药品名称';
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              AppTextFormField<double>(
                label: '数量',
                onChanged: (v) {
                  controller.count.value = v;
                },
                stringToValue: FormValueConverter.stringToDouble,
                valueToString: FormValueConverter.doubleToString,
                initialValue: controller.count.value,
                validator: (v) {
                  if (v == null || v < 0) return '请填写正确的数量';
                  return null;
                },
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              if (controller.operationType.value ==
                  MedicationStockOperation.increment) ...[
                AppTextFormField<double>(
                  label: '总价',
                  onChanged: (v) {
                    controller.totalPrice.value = v ?? 0;
                  },
                  initialValue: controller.totalPrice.value,
                  validator: (v) {
                    if (v == null || v == 0) return '请填写总价';
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  stringToValue: FormValueConverter.stringToDouble,
                  valueToString: FormValueConverter.doubleToString,
                ),
                AppTextFormField<String>(
                  label: '单位',
                  onChanged: (v) {
                    controller.unit.value = v ?? '';
                  },
                  initialValue: controller.unit.value,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return '请填写单位';
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
