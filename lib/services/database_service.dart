import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/page/bookmark_page/bookmark_modal.dart';

abstract class ServiceManager<T> {
  final String key;
  Box<T>? _box;

  ServiceManager(this.key);

  Future<void> init() async {
    registerAdapters();
    if (!(_box?.isOpen ?? false)) {
      _box = await Hive.openBox(key);
    }
  }

  void registerAdapters();

  Future<void> addItem(T item);
  Future<void> putItem(T item);
  bool isExist(String id);
  Future<void> removeItem(String id);
  Future<void> clear() async {
    await _box?.clear();
  }

  T? getItem(String id);
  List<T>? getAllItems();
}

class DatabaseManager extends ServiceManager<BookMarkedMovie> {
  DatabaseManager(String key) : super(key);

  @override
  Future<void> addItem(item) async {
    await _box?.add(item);
  }

  @override
  Future<void> removeItem(id) async {
    await _box?.delete(id);
  }

  @override
  BookMarkedMovie? getItem(id) {
    return _box?.get(id);
  }

  @override
  List<BookMarkedMovie>? getAllItems() {
    return _box?.values.toList();
  }

  @override
  void registerAdapters() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BookMarkedMovieAdapter());
    }
  }

  @override
  Future<void> putItem(item) async {
    await _box?.put(item.id, item);
  }

  @override
  bool isExist(id) {
    return _box?.containsKey(id) ?? false;
  }
}
