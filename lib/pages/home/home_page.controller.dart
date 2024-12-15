import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_vault/models/entity/medication_stock.dart';
import 'package:medi_vault/models/enum/medication_stock_operation.dart';
import 'package:medi_vault/pages/home/stock_bottom_sheet.dart';
import 'package:medi_vault/services/global/global_service.dart';
import 'package:medi_vault/services/sync/data_sync.service.dart';
import 'package:medi_vault/services/list.service.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HomePageController extends GetxController {
  late final ListService<MedicationStock> listService;

  late final RefreshController refreshController;

  final dataSync = DataSyncService();

  final msAccess = Get.find<MedicationStockAccess>();

  final isDebug = kDebugMode;

  final keyword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    listService = ListService<MedicationStock>(getList: _getList);
    refreshController = RefreshController(initialRefresh: true);
    dataSync.syncData();
  }

  Future<List<MedicationStock>> _getList(int page, int pageSize) async {
    return await msAccess.getPage(
      page: page,
      pageSize: pageSize,
      keyword: keyword.value,
    );
  }

  // 从 sqlite 加载数据
  Future refresh() async {
    print('调用refresh');
    try {
      if (listService.refreshing.value) return;
      print('开始刷新数据');
      await listService.refresh();

      final resetFooterState = listService.hasMore.value;

      refreshController.refreshCompleted(resetFooterState: resetFooterState);
    } catch (e) {
      refreshController.refreshFailed();
    }

    print('调用refresh完成');
  }

  Future loadMore() async {
    print('调用loadMore');
    try {
      await listService.loadMore();

      if (!listService.hasMore.value) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
      print('调用loadMore完成');
    } catch (e) {
      refreshController.loadFailed();
      rethrow;
    }
  }

  Future showContextMenu(MedicationStock item, BuildContext context) async {
    final result = await Get.bottomSheet<MedicationStockOperation>(
        const MedicationStockBottomSheetMenus());
    if (result != null) {
      dynamic arg = {'operationType': result, 'item': item, 'exist': true};
      await Get.toNamed('/add-medication-stock', arguments: arg);
      await refreshController.requestRefresh();
    }
  }

  void addStock() async {
    await Get.toNamed('/add-medication-stock');
    await refreshController.requestRefresh();
  }
}
