import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../api/TokenManager.dart';

class PendingRequestManager {
  final Uuid uuid = Uuid();
  bool isSending = false;

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

  Future<void> sendPendingRequests() async {
    if (isSending) {
      print("⏳ الإرسال جارٍ بالفعل...");
      return; // منع التكرار
    }

    isSending = true; // تعيين الإرسال كقيد التنفيذ
    final box = Hive.box('pendingRequests');

    if (box.isEmpty) {
      print("✅ لا توجد بيانات غير مرسلة.");
      isSending = false;
      return;
    }

    final String? token = await TokenManager.getToken();
    if (token == null) {
      print("⚠️ لم يتم العثور على التوكن، الرجاء تسجيل الدخول مجددًا.");
      isSending = false;
      return;
    }

    print("📡 محاولة إرسال البيانات غير المرسلة (${box.length} طلبات)...");

    while (box.isNotEmpty) {
      try {
        // ✅ تحويل البيانات إلى Map<String, String>
        final Map<String, String> data = Map<String, String>.from(box.getAt(0));
        final String requestId = data['id']!; // استخراج UUID
        data.remove('id'); // إزالة UUID قبل الإرسال

        final url = Uri.parse('https://lomfu.pythonanywhere.com/api/v1/teachers/courses/create/');
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(data),
        );

        if (response.statusCode == 201) {
          print("✅ تم إرسال الطلب بنجاح: $data");
          await box.deleteAt(0); // ✅ حذف العنصر الأول بعد نجاح الإرسال
        } else {
          print("❌ فشل الإرسال: ${response.body}");
          break;
        }
      } catch (e) {
        print("⚠️ خطأ أثناء الإرسال: $e");
        break;
      }

      await Future.delayed(Duration(seconds: 2)); // مهلة قبل إرسال الطلب التالي
    }

    isSending = false; // إتاحة الإرسال بعد الانتهاء
  }

  Future<void> checkAndSendPendingRequests() async {
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        sendPendingRequests();
      }
    });
  }
}
