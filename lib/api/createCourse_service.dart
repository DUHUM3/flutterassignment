import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'TokenManager.dart';
import 'hive_service.dart';

class RequestManager {
  bool isSending = false; // متغير لمنع التكرار
  final HiveManager hiveManager = HiveManager();

  Future<void> sendPendingRequests() async {
    if (isSending) {
      print("⏳ الإرسال جارٍ بالفعل...");
      return; // منع التكرار
    }

    isSending = true; // تعيين الإرسال كقيد التنفيذ
    final pendingRequests = await hiveManager.getPendingRequests();

    if (pendingRequests.isEmpty) {
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

    print("📡 محاولة إرسال البيانات غير المرسلة...");

    for (int i = 0; i < pendingRequests.length; i++) {
      try {
        final Map<String, String> data = pendingRequests[i];
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
          await hiveManager.deleteFromHive(i); // حذف العنصر بعد نجاح الإرسال
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

  Future<void> checkAndSendOnConnectivityChange() async {
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        sendPendingRequests();
      }
    });
  }
}
