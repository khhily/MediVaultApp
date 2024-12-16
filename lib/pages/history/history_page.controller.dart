import 'package:get/get.dart';
import 'package:medi_vault/models/entity/medication_stock_record.dart';
import 'package:medi_vault/services/data_cache.service.dart';
import 'package:medi_vault/services/global/global_service.dart';
import 'package:medi_vault/services/list.service.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HistoryPageController extends GetxController {
  final dataAccess = DataCacheService();
  late final ListService<MedicationStockRecord> listService;
  late final RefreshController refreshController;

  final msrAccess = Get.find<MedicationStockRecordAccess>();

  @override
  void onInit() {
    super.onInit();
    listService = ListService<MedicationStockRecord>(getList: _getList);
    refreshController = RefreshController(initialRefresh: true);
  }

  Future<List<MedicationStockRecord>> _getList(int page, int pageSize) async {
    return msrAccess.getList(page: page, pageSize: pageSize);
  }

  // 从 Hive 加载数据
  Future refresh() async {
    try {
      if (listService.refreshing.value) return;
      await listService.refresh();

      refreshController.refreshCompleted(
          resetFooterState: listService.hasMore.value);
    } catch (e) {
      refreshController.refreshFailed();
      rethrow;
    }
  }

  Future loadMore() async {
    if (listService.loading.value) return;
    try {
      await listService.loadMore();

      if (listService.hasMore.value) {
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    } catch (e) {
      refreshController.loadFailed();
      rethrow;
    }
  }
}
