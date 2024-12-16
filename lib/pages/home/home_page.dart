import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_vault/widgets/stock_item/stock_item.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import 'home_page.controller.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            controller.refresh();
          },
          icon: const Icon(Icons.sync),
        ),
        title: const Text('药品库存'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/history');
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: Obx(
        () => SmartRefresher(
          physics: const BouncingScrollPhysics(),
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: () async {
            await controller.refresh();
          },
          onLoading: () async {
            await controller.loadMore();
          },
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus? mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                return const Text('上拉加载更多');
              } else if (mode == LoadStatus.loading) {
                body = const CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = const Text("加载失败！单击重试！");
              } else if (mode == LoadStatus.canLoading) {
                body = const Text("释放以加载更多");
              } else {
                body = const Text("没有更多数据了");
              }
              return Center(child: body);
            },
          ),
          controller: controller.refreshController,
          child: ListView.separated(
            separatorBuilder: (ctx, index) {
              return Container(
                height: 1,
                width: Get.width,
                decoration: const BoxDecoration(
                  color: Colors.black12,
                ),
              );
            },
            itemBuilder: (ctx, index) {
              final item = controller.listService.items[index];
              return MedicationStockListItem(
                item: item,
                index: index,
                onTap: () {
                  controller.showContextMenu(item, ctx);
                },
              );

              // return MedicationStockList(
              //   onTap: (item) {
              //     controller.showContextMenu(item, context);
              //   },
              //   items: controller.listService.items,
              //   itemsLength: controller.listService.items.length,
              // );
            },
            itemCount: controller.listService.items.length,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addStock();
        },
        tooltip: '操作',
        child: const Icon(Icons.add),
      ),
    );
  }
}
