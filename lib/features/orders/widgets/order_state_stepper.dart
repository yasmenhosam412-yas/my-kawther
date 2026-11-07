import 'package:flutter/material.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';

class OrderStateStepper extends StatelessWidget {
  const OrderStateStepper({
    super.key,
    required this.isShipped,
    required this.orderDate,
    required this.shippingDate,
    required this.status,
  });

  final bool isShipped;
  final String orderDate;
  final String? shippingDate;
  final String status;

  int _getCurrentStepIndex(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 0;
      case 'picking':
        return 1;
      case 'packed':
        return 2;
      case 'confirmed':
        return 3;
      case 'on_delivery':
        return 4;
      case 'compiled':
        return 5;
      case 'canceled':
        return 6; 
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _getCurrentStepIndex(status);

    final steps = [
      {'title': S.of(context).order_status_pending, 'date': orderDate},
      {'title': S.of(context).order_status_picking, 'date': orderDate},
      {'title': S.of(context).order_status_packed, 'date': orderDate},
      {'title': S.of(context).order_status_confirmed, 'date': orderDate},
      {'title': S.of(context).order_status_on_delivery, 'date': orderDate},
      {
        'title': S.of(context).order_status_compiled,
        'date': shippingDate ?? S.of(context).delivered,
      },
      {
        'title': S.of(context).order_status_canceled,
        'date': orderDate,
      },
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isCompleted = index <= currentStep;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isCompleted
                            ? AppColors.primaryColor
                            : Colors.grey.shade300,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 14,
                    color: isCompleted ? Colors.white : Colors.transparent,
                  ),
                ),
                if (!isLast)
                  SizedBox(
                    width: 2,
                    height: 40,
                    child: CustomPaint(painter: DottedLinePainter()),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'] as String,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step['date'] as String,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashHeight = 4;
    const double dashSpace = 4;
    double startY = 0;

    final paint =
        Paint()
          ..color = Colors.grey.shade400
          ..strokeWidth = 1;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
