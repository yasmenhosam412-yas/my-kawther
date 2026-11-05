import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:elkawther/generated/l10n.dart';

class AddressWidget extends StatelessWidget {
  final String addressName;
  final String addressDetails;
  final String location;
  final bool isPharm;
  final String apartment;
  final String type;
  final TextEditingController phoneController;

  const AddressWidget({
    super.key,
    required this.addressName,
    required this.addressDetails,
    required this.location,
    required this.isPharm,
    required this.apartment,
    required this.type,
    required this.phoneController,
  });

  Future<void> _launchMap(String uri) async {
    final parsed = Uri.tryParse(uri);
    if (parsed == null ||
        (parsed.scheme != 'http' && parsed.scheme != 'https') ||
        parsed.host.isEmpty) {
      return;
    }
    await launchUrl(parsed, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final kind = type.toLowerCase();
    final isHome = kind == 'home';
    final isWork = kind == 'work';
    final label =
        isPharm
            ? S.of(context).takeFromPharamcy
            : isHome
            ? S.of(context).home_address
            : isWork
            ? S.of(context).work
            : type;
    final color =
        isPharm
            ? AppColors.teal
            : isWork
            ? const Color(0xFF7C3AED)
            : AppColors.primaryColor;
    final icon =
        isPharm
            ? Icons.local_pharmacy_rounded
            : isWork
            ? Icons.work_outline_rounded
            : Icons.home_rounded;
    final line = [addressName, if (apartment.isNotEmpty) apartment].join(' - ');

    final mapUri = Uri.tryParse(location);
    final canOpenMap =
        isPharm &&
        mapUri != null &&
        (mapUri.scheme == 'http' || mapUri.scheme == 'https') &&
        mapUri.host.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.noto14w400.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
                      ),
                    ),
                    if (addressDetails.isNotEmpty)
                      Text(
                        addressDetails,
                        style: AppTextStyles.noto14w400.copyWith(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Material(
            color: color.withOpacity(0.045),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: canOpenMap ? () => _launchMap(location) : null,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 11,
                ),
                child: Row(
                  children: [
                    Icon(
                      canOpenMap
                          ? Icons.location_on_rounded
                          : Icons.place_outlined,
                      size: 19,
                      color: color,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        line,
                        style: AppTextStyles.noto14w400.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkColor,
                        ),
                      ),
                    ),
                    if (canOpenMap)
                      Icon(Icons.open_in_new_rounded, size: 17, color: color),
                  ],
                ),
              ),
            ),
          ),
          if (location.isNotEmpty && !canOpenMap) ...[
            const SizedBox(height: 4),
            Text(
              location,
              style: AppTextStyles.noto14w400.copyWith(
                fontSize: 12,
                color: AppColors.grey,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.phone_rounded, size: 17, color: AppColors.grey),
              const SizedBox(width: 7),
              Text(
                S.of(context).contantInfo,
                style: AppTextStyles.noto14w400.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            hintText: S.of(context).contantInfo,
            controller: phoneController,
            maxLines: 1,
            keyboardType: TextInputType.phone,
            suffixIcon: const Icon(
              Icons.phone_android_rounded,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
