import 'package:get/get.dart';

class ListService<T> {
  int _page = 1;
  final int pageSize;
  Future<List<T>> Function(int, int) getList;

  final items = <T>[].obs;

  final refreshing = false.obs;
  final loading = false.obs;
  final hasMore = true.obs;

  ListService({
    this.pageSize = 20,
    required this.getList,
  });

  refresh() async {
    if (this.refreshing.value) return;

    this.refreshing.value = true;
    this.hasMore.value = true;

    try {
      this._page = 1;
      this.items.value = await getList(this._page, pageSize);
      this.hasMore.value = this.items.length >= pageSize;
    } finally {
      this.refreshing.value = false;
    }
  }

  loadMore() async {
    if (!hasMore.value) return;
    if (this.refreshing.value) return;

    if (this.loading.value) return;
    this.loading.value = true;

    try {
      final list = await getList(_page + 1, pageSize);

      hasMore.value = list.length >= pageSize;

      _page++;
      this.items.addAll(list);
    } finally {
      this.loading.value = false;
    }
  }
}
