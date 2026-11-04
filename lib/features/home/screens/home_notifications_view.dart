import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class HomeNotificationsView extends StatefulWidget {
  const HomeNotificationsView({super.key});

  @override
  State<HomeNotificationsView> createState() => _HomeNotificationsViewState();
}

class _HomeNotice {
  _HomeNotice({
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final String time;
  bool isRead;
}

class _HomeNotificationsViewState extends State<HomeNotificationsView> {
  late final List<_HomeNotice> _items;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ready) return;
    _ready = true;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    _items = [
      _HomeNotice(
        icon: Icons.local_offer_rounded,
        title: isAr ? 'خصم 30% على الفيتامينات' : '30% off vitamins',
        body:
            isAr
                ? 'العرض ساري حتى نهاية الأسبوع'
                : 'Offer valid until the weekend',
        time: isAr ? 'منذ 12 د' : '12m ago',
      ),
      _HomeNotice(
        icon: Icons.local_shipping_rounded,
        title: isAr ? 'طلبك في الطريق' : 'Your order is on the way',
        body: isAr ? 'سيصل خلال ساعات قليلة' : 'It will arrive in a few hours',
        time: isAr ? 'منذ 1 س' : '1h ago',
      ),
      _HomeNotice(
        icon: Icons.medication_rounded,
        title: isAr ? 'منتجات جديدة وصلت' : 'New products arrived',
        body:
            isAr
                ? 'تصفح أحدث الإضافات في الصيدلية'
                : 'Browse the latest pharmacy arrivals',
        time: isAr ? 'منذ 3 س' : '3h ago',
        isRead: true,
      ),
    ];
  }

  bool _ready = false;

  int get _unread => _items.where((item) => !item.isRead).length;

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const SizedBox.shrink();
    final l10n = S.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final unread = _unread;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 22,
                      color: AppColors.darkColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l10n.notifications,
                      style: AppTextStyles.noto24w500.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ),
                  if (unread > 0)
                    Flexible(
                      child: TextButton(
                        onPressed:
                            () => setState(() {
                              for (final item in _items) {
                                item.isRead = true;
                              }
                            }),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryColor,
                          backgroundColor: AppColors.light,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: const Size(0, 36),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.readAll,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.noto14w400.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                children: [
                  _Summary(count: unread, isAr: isAr),
                  _SectionLabel(title: l10n.today, count: _items.length),
                  const SizedBox(height: 10),
                  ...List.generate(_items.length, (index) {
                    final item = _items[index];
                    return _NoticeCard(
                      item: item,
                      onTap: () => setState(() => item.isRead = true),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.count, required this.isAr});

  final int count;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    final label =
        count == 0
            ? (isAr ? 'كل الإشعارات مقروءة' : 'You are all caught up')
            : (isAr ? '$count غير مقروء' : '$count unread');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor.withOpacity(0.14), AppColors.light],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              count == 0
                  ? Icons.mark_email_read_outlined
                  : Icons.notifications_active_outlined,
              color: AppColors.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.noto14w400.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.noto16w400.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.darkColor,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: const Color(0xFFE6EEF5)),
          ),
          child: Text(
            '$count',
            style: AppTextStyles.noto14w400.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.item, required this.onTap});

  final _HomeNotice item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = item.isRead ? AppColors.grey : AppColors.primaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: item.isRead ? Colors.white : const Color(0xFFF3FAFE),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color:
                    item.isRead
                        ? const Color(0xFFE6EEF5)
                        : AppColors.primaryColor.withOpacity(0.18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: item.isRead ? const Color(0xFFF4F7FA) : Colors.white,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(item.icon, size: 20, color: accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppTextStyles.noto14w400.copyWith(
                          fontWeight:
                              item.isRead ? FontWeight.w500 : FontWeight.w700,
                          color:
                              item.isRead
                                  ? AppColors.grey
                                  : AppColors.darkColor,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.body,
                        style: AppTextStyles.noto14w400.copyWith(
                          fontSize: 12,
                          color: AppColors.grey,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.time,
                        style: AppTextStyles.noto14w400.copyWith(
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!item.isRead) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
