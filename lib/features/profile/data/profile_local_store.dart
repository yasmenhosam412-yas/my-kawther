import 'package:elkawther/features/profile/models/points_response.dart';

class ProfileLocalStore {
  ProfileLocalStore._();
  static final ProfileLocalStore instance = ProfileLocalStore._();

  String name = 'كوثر أحمد';
  String email = 'kawther@alkawthar.store';
  String phone = '01012345678';

  final int validTotal = 1250;
  final int redeemedTotal = 180;
  final int expiredTotal = 90;

  final List<OrderPoints> validPoints = [
    OrderPoints(
      orderName: '#KW-1042',
      pointsEarned: 80,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      expiresAt: DateTime.now().add(const Duration(days: 26)),
    ),
    OrderPoints(
      orderName: '#KW-1031',
      pointsEarned: 50,
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
      expiresAt: DateTime.now().add(const Duration(days: 18)),
    ),
    OrderPoints(
      orderName: '#KW-1018',
      pointsEarned: 40,
      createdAt: DateTime.now().subtract(const Duration(days: 21)),
      expiresAt: DateTime.now().add(const Duration(days: 9)),
    ),
  ];

  final List<OrderPoints> redeemedPoints = [
    OrderPoints(
      orderName: '#KW-0988',
      pointsEarned: 120,
      createdAt: DateTime.now().subtract(const Duration(days: 40)),
      redeemedAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    OrderPoints(
      orderName: '#KW-0960',
      pointsEarned: 60,
      createdAt: DateTime.now().subtract(const Duration(days: 55)),
      redeemedAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  final List<OrderPoints> expiredPoints = [
    OrderPoints(
      orderName: '#KW-0901',
      pointsEarned: 90,
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      expiredAt: DateTime.now().subtract(const Duration(days: 14)),
    ),
  ];

  String terms(bool isAr) => isAr
      ? 'باستخدام تطبيق الكوثر فإنك توافق على شروط الاستخدام الخاصة بالصيدلية، بما في ذلك صحة البيانات المدخلة، وعدم إساءة استخدام الخدمات الصحية، والالتزام بتعليمات الدواء والاستشارة.'
      : 'By using the Elkawther app you agree to the pharmacy terms of use, including accurate personal data, responsible use of health tools, and following medication guidance.';

  String privacy(bool isAr) => isAr
      ? 'نحترم خصوصيتك. تُستخدم بيانات الحساب لإدارة الطلبات والنقاط والاستشارات داخل التطبيق فقط، ولا يتم مشاركتها مع أطراف خارجية لأغراض تسويقية دون موافقتك.'
      : 'We respect your privacy. Account data is used only to manage orders, points, and in-app consults, and is not shared with third parties for marketing without your consent.';
}
