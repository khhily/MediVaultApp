import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_vault/pages/history/history_page.controller.dart';
import 'package:medi_vault/utils/date_helper.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HistoryPage extends GetView<HistoryPageController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('操作记录'),
        centerTitle: true,
      ),
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          physics: const BouncingScrollPhysics(),
          enablePullUp: true,
          enablePullDown: true,
          onRefresh: () async {
            await controller.refresh();
          },
          onLoading: () async {
            await controller.loadMore();
          },
          child: ListView.builder(
            itemBuilder: (ctx, index) {
              final item = controller.listService.items[index];
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.medicationName,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.totalPrice == null
                            ? ''
                            : '总价: ￥${item.totalPrice}'),
                        Text(DateHelper.format(item.entryDate)),
                      ],
                    ),
                  ],
                ),
              );
            },
            itemCount: controller.listService.items.length,
          ),
        ),
      ),
    );
  }
}
