import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class HiveManager {
  final Uuid uuid = Uuid(); // كائن UUID

  Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox('pendingRequests');
  }

  Future<void> saveToHive(Map<String, String> data) async {
    final box = Hive.box('pendingRequests');
    data['id'] = uuid.v4(); // إضافة UUID كمعرف فريد
    await box.add(data);
    print("📌 تم حفظ البيانات محليًا في Hive: $data");
  }

  Future<List<Map<String, String>>> getPendingRequests() async {
    final box = Hive.box('pendingRequests');
    List<Map<String, String>> requests = [];
    for (int i = 0; i < box.length; i++) {
      requests.add(Map<String, String>.from(box.getAt(i)));
    }
    return requests;
  }

  Future<void> deleteFromHive(int index) async {
    final box = Hive.box('pendingRequests');
    await box.deleteAt(index);
  }
}
