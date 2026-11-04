import 'package:flutter/material.dart';

class HomeDemoProduct {
  const HomeDemoProduct({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.subtitleAr,
    required this.subtitleEn,
    required this.price,
    required this.imageUrl,
    this.categoryId = 0,
    this.subcategoryId,
    this.originalPrice,
    this.discountLabel,
    this.rating = 0,
    this.reviews = 0,
    this.productSizeId,
  });

  final int id;
  final int categoryId;
  final int? subcategoryId;
  final String nameAr;
  final String nameEn;
  final String subtitleAr;
  final String subtitleEn;
  final double price;
  final String imageUrl;
  final double? originalPrice;
  final String? discountLabel;
  final double rating;
  final int reviews;
  final int? productSizeId;

  bool get hasDiscount => originalPrice != null || discountLabel != null;

  String name(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' ? nameAr : nameEn;

  String subtitle(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar'
          ? subtitleAr
          : subtitleEn;
}

class HomeDemoChip {
  const HomeDemoChip({
    required this.nameAr,
    required this.nameEn,
    required this.imageUrl,
    this.id,
  });

  final int? id;
  final String nameAr;
  final String nameEn;
  final String imageUrl;

  String name(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' ? nameAr : nameEn;
}

class HomeDemoBrand {
  const HomeDemoBrand({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.categoryAr,
    required this.categoryEn,
    required this.logoUrl,
    required this.color,
    required this.productIds,
  });

  final int id;
  final String nameAr;
  final String nameEn;
  final String categoryAr;
  final String categoryEn;
  final String logoUrl;
  final Color color;
  final List<int> productIds;

  String name(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' ? nameAr : nameEn;

  String category(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar'
          ? categoryAr
          : categoryEn;

  String get initial => nameEn.isNotEmpty ? nameEn[0].toUpperCase() : '?';
}

class HomeDemoProblem {
  const HomeDemoProblem({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.subtitleAr,
    required this.subtitleEn,
    required this.icon,
    required this.color,
    required this.productIds,
    this.imageUrl = '',
  });

  final int id;
  final String nameAr;
  final String nameEn;
  final String subtitleAr;
  final String subtitleEn;
  final IconData icon;
  final Color color;
  final List<int> productIds;
  final String imageUrl;

  String name(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' ? nameAr : nameEn;

  String subtitle(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar'
          ? subtitleAr
          : subtitleEn;
}

class HomeDemoSubcategory {
  const HomeDemoSubcategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.imageUrl,
  });

  final int id;
  final String nameAr;
  final String nameEn;
  final String imageUrl;

  String name(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' ? nameAr : nameEn;
}

class HomeDemoCategory {
  const HomeDemoCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.imageUrl,
    this.subcategories = const [],
  });

  final int id;
  final String nameAr;
  final String nameEn;
  final String imageUrl;
  final List<HomeDemoSubcategory> subcategories;

  String name(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' ? nameAr : nameEn;
}

class HomeDemoBanner {
  const HomeDemoBanner({
    required this.titleAr,
    required this.titleEn,
    required this.imageUrl,
  });

  final String titleAr;
  final String titleEn;
  final String imageUrl;

  String title(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' ? titleAr : titleEn;
}

class HomeDemoReview {
  const HomeDemoReview({
    required this.nameAr,
    required this.nameEn,
    required this.commentAr,
    required this.commentEn,
    required this.rating,
    required this.date,
  });

  final String nameAr;
  final String nameEn;
  final String commentAr;
  final String commentEn;
  final int rating;
  final String date;

  String name(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' ? nameAr : nameEn;

  String comment(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar'
          ? commentAr
          : commentEn;
}

class HomeDemoData {
  const HomeDemoData._();

  static const banners = [
    HomeDemoBanner(
      titleAr: 'عناية متخصصة من ACM',
      titleEn: 'Targeted skincare from ACM',
      imageUrl: _Images.depiwhite,
    ),
    HomeDemoBanner(
      titleAr: 'دعم المفاصل مع Acti-Colla',
      titleEn: 'Joint support with Acti-Colla',
      imageUrl: _Images.actiCollaAdvance,
    ),
    HomeDemoBanner(
      titleAr: 'منتجات Alejon للعائلة',
      titleEn: 'Alejon care for the family',
      imageUrl: _Images.careLotion,
    ),
  ];

  static const catalogCategories = [
    HomeDemoCategory(
      id: 1,
      nameAr: 'أدوية',
      nameEn: 'Medicines',
      imageUrl: _Images.diclac,
      subcategories: [
        HomeDemoSubcategory(
          id: 101,
          nameAr: 'أقراص',
          nameEn: 'Tablets',
          imageUrl: _Images.fatroxim,
        ),
        HomeDemoSubcategory(
          id: 102,
          nameAr: 'أكياس',
          nameEn: 'Sachets',
          imageUrl: _Images.fawarFruit,
        ),
      ],
    ),
    HomeDemoCategory(
      id: 2,
      nameAr: 'مكملات غذائية',
      nameEn: 'Supplements',
      imageUrl: _Images.actinPlus,
      subcategories: [
        HomeDemoSubcategory(
          id: 201,
          nameAr: 'المفاصل',
          nameEn: 'Joint support',
          imageUrl: _Images.actiCollaAdvance,
        ),
        HomeDemoSubcategory(
          id: 202,
          nameAr: 'الكولاجين',
          nameEn: 'Collagen',
          imageUrl: _Images.collagenC,
        ),
      ],
    ),
    HomeDemoCategory(
      id: 3,
      nameAr: 'العناية بالبشرة',
      nameEn: 'Skincare',
      imageUrl: _Images.cicastim,
      subcategories: [
        HomeDemoSubcategory(
          id: 301,
          nameAr: 'كريمات',
          nameEn: 'Creams',
          imageUrl: _Images.depiwhite,
        ),
        HomeDemoSubcategory(
          id: 302,
          nameAr: 'العناية بالعين',
          nameEn: 'Eye care',
          imageUrl: _Images.depiwhiteEye,
        ),
      ],
    ),
    HomeDemoCategory(
      id: 4,
      nameAr: 'العناية بالشعر',
      nameEn: 'Hair care',
      imageUrl: _Images.alejonHairLoss,
      subcategories: [
        HomeDemoSubcategory(
          id: 401,
          nameAr: 'علاجات الشعر',
          nameEn: 'Hair treatments',
          imageUrl: _Images.alejonHairLoss,
        ),
        HomeDemoSubcategory(
          id: 402,
          nameAr: 'زيوت الشعر',
          nameEn: 'Hair oils',
          imageUrl: _Images.honeyHairOil,
        ),
      ],
    ),
    HomeDemoCategory(
      id: 5,
      nameAr: 'الأطفال',
      nameEn: 'Baby care',
      imageUrl: _Images.careLotion,
      subcategories: [
        HomeDemoSubcategory(
          id: 501,
          nameAr: 'العناية بالبشرة',
          nameEn: 'Baby skincare',
          imageUrl: _Images.careLotion,
        ),
        HomeDemoSubcategory(
          id: 502,
          nameAr: 'الاستحمام',
          nameEn: 'Bath & shampoo',
          imageUrl: _Images.babyBath,
        ),
      ],
    ),
    HomeDemoCategory(
      id: 6,
      nameAr: 'العناية الشخصية',
      nameEn: 'Personal care',
      imageUrl: _Images.essenceMascara,
      subcategories: [
        HomeDemoSubcategory(
          id: 601,
          nameAr: 'مكياج',
          nameEn: 'Makeup',
          imageUrl: _Images.essenceMascara,
        ),
        HomeDemoSubcategory(
          id: 602,
          nameAr: 'الاستحمام',
          nameEn: 'Shower',
          imageUrl: _Images.adidasShower,
        ),
      ],
    ),
  ];

  static List<HomeDemoChip> get categories =>
      catalogCategories
          .map(
            (category) => HomeDemoChip(
              id: category.id,
              nameAr: category.nameAr,
              nameEn: category.nameEn,
              imageUrl: category.imageUrl,
            ),
          )
          .toList();

  static const catalogBrands = [
    HomeDemoBrand(
      id: 1,
      nameAr: 'إيه سي إم',
      nameEn: 'ACM',
      categoryAr: 'العناية بالبشرة',
      categoryEn: 'Skincare',
      logoUrl: _Images.cicastim,
      color: Color(0xFF0B76B9),
      productIds: [1, 2, 3],
    ),
    HomeDemoBrand(
      id: 2,
      nameAr: 'أكتي كولا',
      nameEn: 'Acti-Colla',
      categoryAr: 'مكملات غذائية',
      categoryEn: 'Supplements',
      logoUrl: _Images.actiCollaAdvance,
      color: Color(0xFF06A786),
      productIds: [4, 5],
    ),
    HomeDemoBrand(
      id: 3,
      nameAr: 'جيكلا',
      nameEn: 'Gikla',
      categoryAr: 'مكملات غذائية',
      categoryEn: 'Supplements',
      logoUrl: _Images.actinPlus,
      color: Color(0xFF0B76B9),
      productIds: [6],
    ),
    HomeDemoBrand(
      id: 4,
      nameAr: 'أليجون',
      nameEn: 'Alejon',
      categoryAr: 'العناية الشخصية',
      categoryEn: 'Personal care',
      logoUrl: _Images.careLotion,
      color: Color(0xFF06A786),
      productIds: [7, 8, 18, 19],
    ),
    HomeDemoBrand(
      id: 5,
      nameAr: 'ساندوز',
      nameEn: 'Sandoz',
      categoryAr: 'أدوية',
      categoryEn: 'Medicines',
      logoUrl: _Images.diclac,
      color: Color(0xFF0B76B9),
      productIds: [9],
    ),
    HomeDemoBrand(
      id: 6,
      nameAr: 'إيسنس',
      nameEn: 'essence',
      categoryAr: 'مكياج',
      categoryEn: 'Makeup',
      logoUrl: _Images.essenceMascara,
      color: Color(0xFFEC4899),
      productIds: [10],
    ),
    HomeDemoBrand(
      id: 7,
      nameAr: 'إيه تي إم',
      nameEn: 'ATM',
      categoryAr: 'أدوية',
      categoryEn: 'Medicines',
      logoUrl: _Images.fatroxim,
      color: Color(0xFF0B76B9),
      productIds: [11],
    ),
    HomeDemoBrand(
      id: 8,
      nameAr: 'أسترازينيكا',
      nameEn: 'AstraZeneca',
      categoryAr: 'أدوية',
      categoryEn: 'Medicines',
      logoUrl: _Images.forxiga,
      color: Color(0xFF0B76B9),
      productIds: [12],
    ),
    HomeDemoBrand(
      id: 9,
      nameAr: 'فاوار',
      nameEn: 'Fawar',
      categoryAr: 'أكياس',
      categoryEn: 'Sachets',
      logoUrl: _Images.fawarFruit,
      color: Color(0xFFF59E0B),
      productIds: [13],
    ),
    HomeDemoBrand(
      id: 10,
      nameAr: 'آند هوني',
      nameEn: '&honey',
      categoryAr: 'العناية بالشعر والبشرة',
      categoryEn: 'Hair & skincare',
      logoUrl: _Images.honeyHairOil,
      color: Color(0xFFF59E0B),
      productIds: [14, 15],
    ),
    HomeDemoBrand(
      id: 11,
      nameAr: 'حكمة',
      nameEn: 'Hikma',
      categoryAr: 'أدوية',
      categoryEn: 'Medicines',
      logoUrl: _Images.bispyller,
      color: Color(0xFF0B76B9),
      productIds: [16],
    ),
    HomeDemoBrand(
      id: 12,
      nameAr: 'أديداس',
      nameEn: 'Adidas',
      categoryAr: 'العناية الشخصية',
      categoryEn: 'Personal care',
      logoUrl: _Images.adidasShower,
      color: Color(0xFF1D4ED8),
      productIds: [17],
    ),
    HomeDemoBrand(
      id: 13,
      nameAr: 'ألفا',
      nameEn: 'ALFA',
      categoryAr: 'مكملات غذائية',
      categoryEn: 'Supplements',
      logoUrl: _Images.collagenC,
      color: Color(0xFF0B76B9),
      productIds: [20],
    ),
  ];

  static List<HomeDemoChip> get brands =>
      catalogBrands
          .map(
            (brand) => HomeDemoChip(
              id: brand.id,
              nameAr: brand.nameAr,
              nameEn: brand.nameEn,
              imageUrl: brand.logoUrl,
            ),
          )
          .toList();

  static const catalogProblems = [
    HomeDemoProblem(
      id: 1,
      nameAr: 'العناية بالبشرة',
      nameEn: 'Skincare',
      subtitleAr: 'منتجات ACM للعناية بالبشرة',
      subtitleEn: 'ACM products for skincare',
      icon: Icons.face_retouching_natural_rounded,
      color: Color(0xFF0B76B9),
      productIds: [1, 2, 3],
    ),
    HomeDemoProblem(
      id: 2,
      nameAr: 'المفاصل والعضلات',
      nameEn: 'Joints & muscles',
      subtitleAr: 'مكملات أكياس لدعم المفاصل والعضلات',
      subtitleEn: 'Sachet supplements for joints and muscles',
      icon: Icons.accessibility_new_rounded,
      color: Color(0xFF06A786),
      productIds: [4, 5, 6],
    ),
    HomeDemoProblem(
      id: 3,
      nameAr: 'العناية بالشعر',
      nameEn: 'Hair care',
      subtitleAr: 'منتجات للشعر وفروة الرأس',
      subtitleEn: 'Products for hair and scalp care',
      icon: Icons.content_cut_rounded,
      color: Color(0xFFDB2777),
      productIds: [7, 14],
    ),
    HomeDemoProblem(
      id: 4,
      nameAr: 'العناية بالطفل',
      nameEn: 'Baby care',
      subtitleAr: 'منتجات أليجون للعناية اليومية بالطفل',
      subtitleEn: 'Alejon products for everyday baby care',
      icon: Icons.child_care_rounded,
      color: Color(0xFFEC4899),
      productIds: [8, 18, 19],
    ),
  ];

  static List<HomeDemoChip> get healthIssues =>
      catalogProblems
          .map(
            (problem) => HomeDemoChip(
              id: problem.id,
              nameAr: problem.nameAr,
              nameEn: problem.nameEn,
              imageUrl: '',
            ),
          )
          .toList();

  static const allProducts = [
    HomeDemoProduct(
      id: 1,
      categoryId: 3,
      subcategoryId: 301,
      nameAr: 'إيه سي إم سيكاستيم كريم إصلاح 20 مل',
      nameEn: 'ACM Cicastim Repair Cream 20ml',
      subtitleAr: 'كريم إصلاح للعناية بالبشرة الهشة والمتهيجة.',
      subtitleEn: 'Repair cream for fragile and irritated skin.',
      price: 285,
      imageUrl: _Images.cicastim,
    ),
    HomeDemoProduct(
      id: 2,
      categoryId: 3,
      subcategoryId: 301,
      nameAr: 'إيه سي إم ديبي وايت أدفانسد 40 مل',
      nameEn: 'ACM Depiwhite Advanced Cream 40ml',
      subtitleAr: 'كريم مكثف مضاد للبقع البنية للوجه واليدين.',
      subtitleEn: 'Intensive anti-brown spot cream for face and hands.',
      price: 240,
      imageUrl: _Images.depiwhite,
    ),
    HomeDemoProduct(
      id: 3,
      categoryId: 3,
      subcategoryId: 302,
      nameAr: 'إيه سي إم ديبي وايت جل محيط العين 15 مل',
      nameEn: 'ACM Depiwhite Eye Contour Gel 15ml',
      subtitleAr: 'جل ديبي وايت مخصص لمحيط العين.',
      subtitleEn: 'Depiwhite gel for the eye contour.',
      price: 720,
      imageUrl: _Images.depiwhiteEye,
    ),
    HomeDemoProduct(
      id: 4,
      categoryId: 2,
      subcategoryId: 201,
      nameAr: 'أكتي كولا أدفانس 30 كيس',
      nameEn: 'Acti-Colla Advance 30 sachets',
      subtitleAr: 'مكمل كولاجين مع الكركم والفلفل الأسود وفيتامين سي.',
      subtitleEn:
          'Collagen supplement with turmeric, black pepper, and vitamin C.',
      price: 55,
      imageUrl: _Images.actiCollaAdvance,
    ),
    HomeDemoProduct(
      id: 5,
      categoryId: 2,
      subcategoryId: 201,
      nameAr: 'أكتي كولا سي 30 كيس',
      nameEn: 'Acti-Colla C 30 sachets',
      subtitleAr: 'مكمل كولاجين مع فيتامين سي ومستخلص ثمار الورد.',
      subtitleEn: 'Collagen supplement with vitamin C and rosehip extract.',
      price: 95,
      imageUrl: _Images.actiCollaC,
    ),
    HomeDemoProduct(
      id: 6,
      categoryId: 2,
      subcategoryId: 202,
      nameAr: 'جيكلا أكتين بلس 30 كيس',
      nameEn: 'Gikla Actin Plus 30 sachets',
      subtitleAr: 'مكمل غذائي موضح على العبوة لدعم قوة العضلات.',
      subtitleEn: 'Dietary supplement labeled for muscle-strength support.',
      price: 98,
      imageUrl: _Images.actinPlus,
    ),
    HomeDemoProduct(
      id: 7,
      categoryId: 4,
      subcategoryId: 401,
      nameAr: 'أليجون أمبولات مضادة لتساقط الشعر، 15 أمبولة',
      nameEn: 'Alejon Anti Hair Loss Vials, 15 vials',
      subtitleAr: 'أمبولات للعناية بالشعر، عبوة 15 أمبولة.',
      subtitleEn: 'Hair-care vials in a 15-vial pack.',
      price: 480,
      imageUrl: _Images.alejonHairLoss,
    ),
    HomeDemoProduct(
      id: 8,
      categoryId: 5,
      subcategoryId: 501,
      nameAr: 'أليجون بيبي كير لوشن 220 مل',
      nameEn: 'Alejon Baby Care Lotion 220ml',
      subtitleAr: 'لوشن أطفال مضاد للحساسية للعناية اليومية.',
      subtitleEn: 'Hypoallergenic baby lotion for everyday care.',
      price: 90,
      imageUrl: _Images.careLotion,
    ),
    HomeDemoProduct(
      id: 9,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'ديكلاك 150 آي دي، 20 قرص',
      nameEn: 'Diclac 150 ID, 20 tablets',
      subtitleAr: 'ديكلوفيناك صوديوم 150 مجم، أقراص ممتدة المفعول.',
      subtitleEn: 'Diclofenac sodium 150mg prolonged-release tablets.',
      price: 110,
      imageUrl: _Images.diclac,
    ),
    HomeDemoProduct(
      id: 10,
      categoryId: 6,
      subcategoryId: 601,
      nameAr: 'إيسنس لاش برنسيس ماسكارا كيرل آند فوليوم',
      nameEn: 'essence Lash Princess Curl & Volume Mascara',
      subtitleAr: 'ماسكارا للرموش بتأثير الكيرل والحجم.',
      subtitleEn: 'Mascara with curl and volume effect.',
      price: 420,
      imageUrl: _Images.essenceMascara,
    ),
    HomeDemoProduct(
      id: 11,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'فاتروكسيم 550 مجم، 30 قرص',
      nameEn: 'Fatroxim 550mg, 30 tablets',
      subtitleAr: 'ريفاكسيمين 550 مجم، أقراص مغلفة.',
      subtitleEn: 'Rifaximin 550mg film-coated tablets.',
      price: 1180,
      imageUrl: _Images.fatroxim,
    ),
    HomeDemoProduct(
      id: 12,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'فورسيجا 5 مجم، 28 قرص',
      nameEn: 'Forxiga 5mg, 28 tablets',
      subtitleAr: 'داباغليفلوزين 5 مجم، أقراص مغلفة.',
      subtitleEn: 'Dapagliflozin 5mg film-coated tablets.',
      price: 380,
      imageUrl: _Images.forxiga,
    ),
    HomeDemoProduct(
      id: 13,
      categoryId: 1,
      subcategoryId: 102,
      nameAr: 'فوار فواكه، 6 أكياس',
      nameEn: 'Fawar Fruit, 6 sachets',
      subtitleAr:
          'عبوة أكياس بنكهة الفاكهة؛ راجع العبوة لمعرفة طريقة الاستخدام.',
      subtitleEn: 'Fruit-flavoured sachets; refer to the pack for directions.',
      price: 72,
      imageUrl: _Images.fawarFruit,
    ),
    HomeDemoProduct(
      id: 14,
      categoryId: 4,
      subcategoryId: 402,
      nameAr: 'آند هوني ديب موست زيت شعر 100 مل',
      nameEn: '&honey Deep Moist Hair Oil 100ml',
      subtitleAr: 'زيت شعر ديب موست من آند هوني، إصدار 3.0.',
      subtitleEn: '&honey Deep Moist Hair Oil, version 3.0.',
      price: 65,
      imageUrl: _Images.honeyHairOil,
    ),
    HomeDemoProduct(
      id: 15,
      categoryId: 3,
      subcategoryId: 301,
      nameAr: 'آند هوني زيت تنظيف 180 مل',
      nameEn: '&honey Cleansing Oil 180ml',
      subtitleAr: 'زيت تنظيف للوجه من آند هوني.',
      subtitleEn: '&honey facial cleansing oil.',
      price: 55,
      imageUrl: _Images.honeyCleansingOil,
    ),
    HomeDemoProduct(
      id: 16,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'بيسبيولر 140/125/125 مجم، 120 كبسولة',
      nameEn: 'Bispvyller 140/125/125mg, 120 capsules',
      subtitleAr:
          'بزموت سبساليسيلات البوتاسيوم وميترونيدازول وتيتراسيكلين هيدروكلوريد.',
      subtitleEn:
          'Bismuth subsalicylate potassium, metronidazole, and tetracycline hydrochloride.',
      price: 650,
      imageUrl: _Images.bispyller,
    ),
    HomeDemoProduct(
      id: 17,
      categoryId: 6,
      subcategoryId: 602,
      nameAr: 'أديداس آيس دايف جل استحمام 400 مل',
      nameEn: 'Adidas Ice Dive Shower Gel 400ml',
      subtitleAr: 'جل استحمام آيس دايف من أديداس.',
      subtitleEn: 'Adidas Ice Dive shower gel.',
      price: 395,
      imageUrl: _Images.adidasShower,
    ),
    HomeDemoProduct(
      id: 18,
      categoryId: 5,
      subcategoryId: 502,
      nameAr: 'أليجون بيبي حمام وشامبو 2 في 1، 250 مل',
      nameEn: 'Alejon Baby Bath & Shampoo 2-in-1, 250ml',
      subtitleAr: 'منتج استحمام وشامبو للأطفال 2 في 1.',
      subtitleEn: '2-in-1 baby bath and shampoo.',
      price: 75,
      imageUrl: _Images.babyBath,
    ),
    HomeDemoProduct(
      id: 19,
      categoryId: 5,
      subcategoryId: 501,
      nameAr: 'أليجون بيبي كريم قشرة الرأس',
      nameEn: 'Alejon Baby Anti-Cradle Cap Cream',
      subtitleAr: 'كريم أليجون بيبي للعناية بقشرة رأس الرضيع.',
      subtitleEn: 'Alejon Baby cream for cradle cap care.',
      price: 210,
      imageUrl: _Images.cradleCap,
    ),
    HomeDemoProduct(
      id: 20,
      categoryId: 2,
      subcategoryId: 202,
      nameAr: 'ألفا كولاجين سي مع البيوتين، 60 كبسولة',
      nameEn: 'ALFA Collagen C with Biotin, 60 capsules',
      subtitleAr: 'كولاجين متحلل مع البيوتين، 60 كبسولة.',
      subtitleEn: 'Hydrolysed collagen with biotin, 60 capsules.',
      price: 325,
      imageUrl: _Images.collagenC,
    ),
  ];

  static List<HomeDemoProduct> get discounts => productsForIds(const [1, 2, 3]);

  static List<HomeDemoProduct> get bestSelling =>
      productsForIds(const [4, 5, 6, 7, 8, 9]);

  static List<HomeDemoProduct> get newArrivals =>
      productsForIds(const [10, 11, 12, 13, 14, 15]);

  static List<HomeDemoProduct> get specialPackages =>
      productsForIds(const [16, 17, 18, 19, 20]);

  static List<HomeDemoProduct> productsForIds(List<int> ids) {
    final map = {for (final product in allProducts) product.id: product};
    return [
      for (final id in ids)
        if (map[id] != null) map[id]!,
    ];
  }

  static List<HomeDemoProduct> productsForBrand(int brandId) {
    for (final brand in catalogBrands) {
      if (brand.id == brandId) return productsForIds(brand.productIds);
    }
    return const [];
  }

  static List<HomeDemoProduct> productsForProblem(int problemId) {
    for (final problem in catalogProblems) {
      if (problem.id == problemId) return productsForIds(problem.productIds);
    }
    return const [];
  }

  static List<HomeDemoProduct> productsFor({
    int? categoryId,
    int? subcategoryId,
  }) {
    if (subcategoryId != null) {
      return allProducts
          .where((product) => product.subcategoryId == subcategoryId)
          .toList();
    }
    if (categoryId != null) {
      return allProducts
          .where((product) => product.categoryId == categoryId)
          .toList();
    }
    return allProducts;
  }

  static List<HomeDemoProduct> productsForBanner(int index) {
    switch (index) {
      case 1:
        return discounts;
      case 2:
        return bestSelling;
      default:
        return allProducts;
    }
  }

  static const reviews = <HomeDemoReview>[];
}

class _Images {
  const _Images._();

  static const cicastim =
      'assets/products/Acm-Cicastim-Repair-Cream-20ml-400x400.webp';
  static const depiwhite =
      'assets/products/ACM-DEPIWHITE-CREAM-ADVANCED-40-ML-3-441x441.webp';
  static const depiwhiteEye =
      'assets/products/ACM-DEPIWHITE-EYE-CONTOUR-GEL-15ML-2-400x400.webp';
  static const actiCollaAdvance =
      'assets/products/ACTI-COLLA-ADVANCE-30-SACHETS-400x400.webp';
  static const actiCollaC =
      'assets/products/ACTI-COLLA-C-30-SACHETS-1-400x400.webp';
  static const actinPlus = 'assets/products/ACTIN-PLUS-30-SACHETS-441x441.webp';
  static const alejonHairLoss =
      'assets/products/ALEJON-ANT-HAIR-LOSS-15VIALS-400x400.webp';
  static const careLotion =
      'assets/products/Care-Lotion-220-570x570-1-441x441.webp';
  static const diclac = 'assets/products/DICLAC-150MG-ID-20-TAB-400x400.webp';
  static const essenceMascara =
      'assets/products/Essence-Lash-PRINCESS-curl-amp-volume-mascara-400x400.webp';
  static const fatroxim =
      'assets/products/fatroxim-550mg-30-tabمحلى-400x400.webp';
  static const forxiga = 'assets/products/FORXIGA-5MG-28TAB-400x400.webp';
  static const fawarFruit = 'assets/products/FAWAR-FRUIT-6SACHETS-400x400.webp';
  static const honeyHairOil =
      'assets/products/HONEY-DEEP-MOIST-HAIR-OIL-100-ML-400x400.webp';
  static const honeyCleansingOil =
      'assets/products/HONEY-CLEANSING-OIL-180-ML-400x400.webp';
  static const bispyller = 'assets/products/New-Project-12-1-441x441.webp';
  static const adidasShower =
      'assets/products/New-Project-2026-09-23T093411.830-441x441.webp';
  static const babyBath =
      'assets/products/New-Project-2026-10-15T122505.250-441x441.webp';
  static const cradleCap =
      'assets/products/New-Project-2026-10-15T134715.591-441x441.webp';
  static const collagenC = 'assets/products/New-Project-74-1-441x441.webp';
}
