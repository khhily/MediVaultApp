import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_vault/pages/setting/setting_page.controller.dart';

class SettingPage extends GetView<SettingPageController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('修改配置'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              controller.save();
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
            children: [
              TextFormField(
                controller: controller.urlController,
                decoration: const InputDecoration(labelText: '同步Api'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
