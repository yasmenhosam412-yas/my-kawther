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

  String name(BuildContext context) => Localizations.localeOf(context).languageCode == 'ar' ? nameAr : nameEn;

  String subtitle(BuildContext context) => Localizations.localeOf(context).languageCode == 'ar'
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

  String name(BuildContext context) => Localizations.localeOf(context).languageCode == 'ar' ? nameAr : nameEn;
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

  String name(BuildContext context) => Localizations.localeOf(context).languageCode == 'ar' ? nameAr : nameEn;

  String category(BuildContext context) => Localizations.localeOf(context).languageCode == 'ar'
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

  String name(BuildContext context) => Localizations.localeOf(context).languageCode == 'ar' ? nameAr : nameEn;

  String subtitle(BuildContext context) => Localizations.localeOf(context).languageCode == 'ar'
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

  String name(BuildContext context) => Localizations.localeOf(context).languageCode == 'ar' ? nameAr : nameEn;
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

  String name(BuildContext context) => Localizations.localeOf(context).languageCode == 'ar' ? nameAr : nameEn;
}

class HomeDemoBanner {
  const HomeDemoBanner({
    required this.titleAr,
    required this.titleEn,
    required this.imageUrl,
    this.link,
  });

  final String titleAr;
  final String titleEn;
  final String imageUrl;
  final String? link;

  String title(BuildContext context) => Localizations.localeOf(context).languageCode == 'ar' ? titleAr : titleEn;
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

  String name(BuildContext context) => Localizations.localeOf(context).languageCode == 'ar' ? nameAr : nameEn;

  String comment(BuildContext context) => Localizations.localeOf(context).languageCode == 'ar'
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

  static List<HomeDemoChip> get categories => catalogCategories.map((category) => HomeDemoChip(id: category.id, nameAr: category.nameAr, nameEn: category.nameEn, imageUrl: category.imageUrl)).toList();

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

  static List<HomeDemoChip> get brands => catalogBrands.map((brand) => HomeDemoChip(id: brand.id, nameAr: brand.nameAr, nameEn: brand.nameEn, imageUrl: brand.logoUrl)).toList();

  static const catalogProblems = [
    HomeDemoProblem(
      id: 1,
      nameAr: 'العناية بالبشرة',
      nameEn: 'Skin care',
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

  static List<HomeDemoChip> get healthIssues => catalogProblems.map((problem) => HomeDemoChip(id: problem.id, nameAr: problem.nameAr, nameEn: problem.nameEn, imageUrl: '')).toList();

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
      subtitleEn: 'Collagen supplement with turmeric, black pepper, and vitamin C.',
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
      nameAr: 'ديك拉克 150 آي دي، 20 قرص',
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
      subtitleAr: 'عبوة أكياس بنكهة الفاكهة؛ راجع العبوة لمعرفة طريقة الاستخدام.',
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
      subtitleAr: 'بزموت سبساليسيلات البوتاسيوم وميترونيدازول وتيتراسيكلين هيدروكلوريد.',
      subtitleEn: 'Bismuth subsalicylate potassium, metronidazole, and tetracycline hydrochloride.',
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
    // Additional products
    HomeDemoProduct(
      id: 21,
      categoryId: 3,
      subcategoryId: 301,
      nameAr: 'إيه سي إم مرطب يومي 50 مل',
      nameEn: 'ACM Daily Moisturizer 50ml',
      subtitleAr: 'ترطيب مستمر للبشرة الجافة والحساسة.',
      subtitleEn: 'Continuous hydration for dry and sensitive skin.',
      price: 180,
      imageUrl: _Images.cicastim,
    ),
    HomeDemoProduct(
      id: 22,
      categoryId: 3,
      subcategoryId: 301,
      nameAr: 'إيه سي إم سنسبشن كريم SPF 50',
      nameEn: 'ACM sensation Cream SPF 50',
      subtitleAr: 'كريم حماية من الشمس SPF 50',
      subtitleEn: 'Sun protection cream SPF 50',
      price: 320,
      imageUrl: _Images.depiwhite,
    ),
    HomeDemoProduct(
      id: 23,
      categoryId: 2,
      subcategoryId: 201,
      nameAr: 'مكمل كولاجين فيتامين سي 60 كيس',
      nameEn: 'Collagen Vitamin C 60 sachets',
      subtitleAr: 'مكمل كولاجين وفيتامين سي لدعم الصحة العامة.',
      subtitleEn: 'Collagen and vitamin C supplement for overall health.',
      price: 120,
      imageUrl: _Images.actiCollaAdvance,
    ),
    HomeDemoProduct(
      id: 24,
      categoryId: 2,
      subcategoryId: 202,
      nameAr: 'مكملات المفاصل والكولاجين',
      nameEn: 'Joints and Collagen Supplements',
      subtitleAr: 'دعم صحة المفاصل والعظام.',
      subtitleEn: 'Joint and bone health support.',
      price: 150,
      imageUrl: _Images.actinPlus,
    ),
    HomeDemoProduct(
      id: 25,
      categoryId: 4,
      subcategoryId: 401,
      nameAr: 'زيت روزماري للشعر',
      nameEn: 'Rosemary Hair Oil',
      subtitleAr: 'زيت روزماري لتقوية الشعر ونموه.',
      subtitleEn: 'Rosemary oil for hair strengthening and growth.',
      price: 85,
      imageUrl: _Images.alejonHairLoss,
    ),
    HomeDemoProduct(
      id: 26,
      categoryId: 5,
      subcategoryId: 501,
      nameAr: 'غسول أطفال لطيف',
      nameEn: 'Gentle Baby Wash',
      subtitleAr: 'غسول لطيف للبشرة الحساسة للأطفال.',
      subtitleEn: 'Gentle wash for sensitive baby skin.',
      price: 55,
      imageUrl: _Images.careLotion,
    ),
    HomeDemoProduct(
      id: 27,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'أسيتامينوفين 500 مجم، 20 قرص',
      nameEn: 'Acetaminophen 500mg, 20 tablets',
      subtitleAr: 'مسكّن ومخفض للحرارة.',
      subtitleEn: 'Pain reliever and fever reducer.',
      price: 45,
      imageUrl: _Images.diclac,
    ),
    HomeDemoProduct(
      id: 28,
      categoryId: 6,
      subcategoryId: 601,
      nameAr: ' rougesérosity قلم Eye Liner',
      nameEn: 'Rouge Serosity Eye Liner',
      subtitleAr: ' قلم تحديد العيون.',
      subtitleEn: 'Eye liner pencil.',
      price: 120,
      imageUrl: _Images.essenceMascara,
    ),
    HomeDemoProduct(
      id: 29,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'أموكسيسيلين 500 مجم، 20 قرص',
      nameEn: 'Amoxicillin 500mg, 20 tablets',
      subtitleAr: 'مضاد حيوي واسع المجال.',
      subtitleEn: 'Broad-spectrum antibiotic.',
      price: 85,
      imageUrl: _Images.fatroxim,
    ),
    HomeDemoProduct(
      id: 30,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'اوميبرازول 20 مجم، 14 قرص',
      nameEn: 'Omeprazole 20mg, 14 tablets',
      subtitleAr: 'علاج الحموضة وعسر الهضم.',
      subtitleEn: 'Treatment for acid reflux and indigestion.',
      price: 70,
      imageUrl: _Images.forxiga,
    ),
    HomeDemoProduct(
      id: 31,
      categoryId: 1,
      subcategoryId: 102,
      nameAr: 'اسمحيل 6 أكياس',
      nameEn: 'Samhafil 6 sachets',
      subtitleAr: 'عبوة أكياس للجهاز الهضمي.',
      subtitleEn: 'Sachets for digestive system.',
      price: 60,
      imageUrl: _Images.fawarFruit,
    ),
    HomeDemoProduct(
      id: 32,
      categoryId: 4,
      subcategoryId: 402,
      nameAr: 'زيت أركان للشعر',
      nameEn: 'Argan Hair Oil',
      subtitleAr: 'زيت أركان لترطيب الشعر.',
      subtitleEn: 'Argan oil for hair moisturizing.',
      price: 95,
      imageUrl: _Images.honeyHairOil,
    ),
    HomeDemoProduct(
      id: 33,
      categoryId: 5,
      subcategoryId: 502,
      nameAr: ' شامبو الأطفال الطبيعي',
      nameEn: 'Natural Baby Shampoo',
      subtitleAr: 'شامبو طبيعي لطيف للأطفال.',
      subtitleEn: 'Gentle natural shampoo for babies.',
      price: 65,
      imageUrl: _Images.babyBath,
    ),
    HomeDemoProduct(
      id: 34,
      categoryId: 5,
      subcategoryId: 501,
      nameAr: 'كريم حماية من الحفاضات',
      nameEn: 'Diaper Rash Cream',
      subtitleAr: 'كريم حماية من الحفاضات.',
      subtitleEn: 'Diaper rash protection cream.',
      price: 90,
      imageUrl: _Images.cradleCap,
    ),
    HomeDemoProduct(
      id: 35,
      categoryId: 2,
      subcategoryId: 202,
      nameAr: 'مكمل البيوتين للكولاجين',
      nameEn: 'Biotin Collagen Supplement',
      subtitleAr: 'مكمل البيوتين لتعزيز الكولاجين.',
      subtitleEn: 'Biotin supplement for collagen enhancement.',
      price: 110,
      imageUrl: _Images.collagenC,
    ),
  ];
  // Extended demo products 36-135
  static const allProductsExtended = [
    HomeDemoProduct(
      id: 36,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'سيبروفلوكساسين 500 مجم، 10 أقراص',
      nameEn: 'Ciprofloxacin 500mg, 10 tablets',
      subtitleAr: 'مضاد حيوي للعدوات البكتيرية.',
      subtitleEn: 'Antibiotic for bacterial infections.',
      price: 120,
      imageUrl: _Images.fatroxim,
    ),
    HomeDemoProduct(
      id: 37,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'أموكسيسيلين 250 مجم، 20 قرص',
      nameEn: 'Amoxicillin 250mg, 20 tablets',
      subtitleAr: 'مضاد حيوي واسع المجال للأطفال.',
      subtitleEn: 'Broad-spectrum antibiotic for children.',
      price: 95,
      imageUrl: _Images.fatroxim,
    ),
    HomeDemoProduct(
      id: 38,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'أزيثرومايسين 500 مجم، 3 أقراص',
      nameEn: 'Azithromycin 500mg, 3 tablets',
      subtitleAr: 'مضاد حيوي لعلاج التهابات الجهاز التنفسي.',
      subtitleEn: 'Antibiotic for respiratory tract infections.',
      price: 150,
      imageUrl: _Images.forxiga,
    ),
    HomeDemoProduct(
      id: 39,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'وارفارين 5 مجم، 28 قرص',
      nameEn: 'Warfarin 5mg, 28 tablets',
      subtitleAr: 'مسيّل للدم.',
      subtitleEn: 'Blood thinner.',
      price: 80,
      imageUrl: _Images.forxiga,
    ),
    HomeDemoProduct(
      id: 40,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'ريفامبين 450 مجم، 30 كبسولة',
      nameEn: 'Rifampin 450mg, 30 capsules',
      subtitleAr: 'مضاد حيوي لعلاج السل.',
      subtitleEn: 'Antibiotic for tuberculosis treatment.',
      price: 200,
      imageUrl: _Images.diclac,
    ),
    HomeDemoProduct(
      id: 41,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'ليدوكائين 2٪ جل، 30 جرام',
      nameEn: 'Lidocaine 2% Gel, 30g',
      subtitleAr: 'مخدر موضعي للجلد.',
      subtitleEn: 'Topical anesthetic for skin.',
      price: 65,
      imageUrl: _Images.diclac,
    ),
    HomeDemoProduct(
      id: 42,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'مينوكسيديل 5% محلول، 60 مل',
      nameEn: 'Minoxidil 5% Solution, 60ml',
      subtitleAr: 'علاج تساقط الشعر.',
      subtitleEn: 'Hair loss treatment.',
      price: 180,
      imageUrl: _Images.alejonHairLoss,
    ),
    HomeDemoProduct(
      id: 43,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'فيناسترايد 5 مجم، 30 قرص',
      nameEn: 'Finasteride 5mg, 30 tablets',
      subtitleAr: 'علاج تساقط الشعر وزيادة النمو.',
      subtitleEn: 'Hair loss treatment and growth promotion.',
      price: 220,
      imageUrl: _Images.alejonHairLoss,
    ),
    HomeDemoProduct(
      id: 44,
      categoryId: 1,
      subcategoryId: 102,
      nameAr: 'ثلاميتون 250 مجم، 10 أقراص',
      nameEn: 'Thalitone 250mg, 10 tablets',
      subtitleAr: 'حبوب مدرة للبول.',
      subtitleEn: 'Diuretic tablets.',
      price: 75,
      imageUrl: _Images.fawarFruit,
    ),
    HomeDemoProduct(
      id: 45,
      categoryId: 1,
      subcategoryId: 102,
      nameAr: 'فيدرال 10 مجم، 30 قرص',
      nameEn: 'Fedral 10mg, 30 tablets',
      subtitleAr: 'علاج فرط النشاط ونقص الانتباه.',
      subtitleEn: 'ADHD treatment.',
      price: 250,
      imageUrl: _Images.fawarFruit,
    ),
    HomeDemoProduct(
      id: 46,
      categoryId: 2,
      subcategoryId: 201,
      nameAr: 'مكمل أوميغا 3، 30 كبسولة',
      nameEn: 'Omega-3 Supplement, 30 capsules',
      subtitleAr: 'مكمل صحي للقلب والدماغ.',
      subtitleEn: 'Health supplement for heart and brain.',
      price: 110,
      imageUrl: _Images.actiCollaAdvance,
    ),
    HomeDemoProduct(
      id: 47,
      categoryId: 2,
      subcategoryId: 201,
      nameAr: 'فيتامين د3 1000 وحدة، 30 قرص',
      nameEn: 'Vitamin D3 1000 IU, 30 tablets',
      subtitleAr: 'لصحة العظام والمناعة.',
      subtitleEn: 'For bone and immune health.',
      price: 85,
      imageUrl: _Images.actiCollaAdvance,
    ),
    HomeDemoProduct(
      id: 48,
      categoryId: 2,
      subcategoryId: 201,
      nameAr: 'مكمل مغنيسيوم 200 مجم، 60 قرص',
      nameEn: 'Magnesium 200mg, 60 tablets',
      subtitleAr: 'لصحة العضلات والأعصاب.',
      subtitleEn: 'For muscle and nerve health.',
      price: 70,
      imageUrl: _Images.actiCollaC,
    ),
    HomeDemoProduct(
      id: 49,
      categoryId: 2,
      subcategoryId: 202,
      nameAr: 'كلس الكالسيوم مع فيتامين د',
      nameEn: 'Calcium with Vitamin D',
      subtitleAr: 'لصحة العظام والأسنان.',
      subtitleEn: 'For bone and dental health.',
      price: 95,
      imageUrl: _Images.actinPlus,
    ),
    HomeDemoProduct(
      id: 50,
      categoryId: 2,
      subcategoryId: 202,
      nameAr: 'مكمل البروتوكول اليومي',
      nameEn: 'Daily Protocol Supplement',
      subtitleAr: 'مكمل شامل للصحة اليومية.',
      subtitleEn: 'Daily health comprehensive supplement.',
      price: 150,
      imageUrl: _Images.actinPlus,
    ),
    HomeDemoProduct(
      id: 51,
      categoryId: 2,
      subcategoryId: 202,
      nameAr: 'بيروسيكولين 10 مجم، 30 قرص',
      nameEn: 'Pyridoxine B6 10mg, 30 tablets',
      subtitleAr: 'فيتامين ب6 لصحة الأعصاب.',
      subtitleEn: 'Vitamin B6 for nerve health.',
      price: 60,
      imageUrl: _Images.actinPlus,
    ),
    HomeDemoProduct(
      id: 52,
      categoryId: 3,
      subcategoryId: 301,
      nameAr: 'تونر ترطيب البشرة',
      nameEn: 'Hydration Toner',
      subtitleAr: 'ترطيب وتفريش البشرة.',
      subtitleEn: 'Hydration and refreshing toner.',
      price: 90,
      imageUrl: _Images.cicastim,
    ),
    HomeDemoProduct(
      id: 53,
      categoryId: 3,
      subcategoryId: 301,
      nameAr: 'قشطرة كيميائية خفيفة',
      nameEn: 'Light Chemical Peeling',
      subtitleAr: 'تجديد خلايا البشرة.',
      subtitleEn: 'Cell renewal peeling.',
      price: 350,
      imageUrl: _Images.depiwhite,
    ),
    HomeDemoProduct(
      id: 54,
      categoryId: 3,
      subcategoryId: 302,
      nameAr: 'كريم حماية شمسensitive',
      nameEn: 'Sensitive Skin Sunscreen',
      subtitleAr: 'حماية من الشمس للبشرة الحساسة.',
      subtitleEn: 'Sun protection for sensitive skin.',
      price: 280,
      imageUrl: _Images.depiwhiteEye,
    ),
    HomeDemoProduct(
      id: 55,
      categoryId: 3,
      subcategoryId: 301,
      nameAr: 'سرباتيل الكوبراسي',
      nameEn: 'Copper Peptide Serum',
      subtitleAr: 'مصل لبناء الكولاجين.',
      subtitleEn: 'Collagen-building serum.',
      price: 320,
      imageUrl: _Images.cicastim,
    ),
    HomeDemoProduct(
      id: 56,
      categoryId: 3,
      subcategoryId: 301,
      nameAr: 'قناع الطين الأخضر',
      nameEn: 'Green Clay Mask',
      subtitleAr: 'قناصطاف عميق وتنقيص المسام.',
      subtitleEn: 'Deep cleansing and pore minimization.',
      price: 120,
      imageUrl: _Images.cicastim,
    ),
    HomeDemoProduct(
      id: 57,
      categoryId: 3,
      subcategoryId: 301,
      nameAr: 'سيروم فيتامين سي',
      nameEn: 'Vitamin C Serum',
      subtitleAr: 'تبييض وتوحيد لون البشرة.',
      subtitleEn: 'Skin brightening and evening tone.',
      price: 250,
      imageUrl: _Images.depiwhite,
    ),
    HomeDemoProduct(
      id: 58,
      categoryId: 4,
      subcategoryId: 401,
      nameAr: 'شامبو تقوية الشعر',
      nameEn: 'Hair Strengthening Shampoo',
      subtitleAr: 'لتقوية البصيلات ومنع التساقط.',
      subtitleEn: 'Strengthens hair follicles and prevents loss.',
      price: 110,
      imageUrl: _Images.alejonHairLoss,
    ),
    HomeDemoProduct(
      id: 59,
      categoryId: 4,
      subcategoryId: 401,
      nameAr: 'بلسم ترميمي',
      nameEn: 'Restorative Conditioner',
      subtitleAr: 'لإصلاح التلف وتنعيم الشعر.',
      subtitleEn: 'Repairs damage and smooths hair.',
      price: 95,
      imageUrl: _Images.alejonHairLoss,
    ),
    HomeDemoProduct(
      id: 60,
      categoryId: 4,
      subcategoryId: 401,
      nameAr: 'زيت خروع للشعر',
      nameEn: 'Castor Oil for Hair',
      subtitleAr: 'لنمو الشعر الكثيف.',
      subtitleEn: 'For thick hair growth.',
      price: 75,
      imageUrl: _Images.alejonHairLoss,
    ),
    HomeDemoProduct(
      id: 61,
      categoryId: 4,
      subcategoryId: 402,
      nameAr: 'ماسك شعر avocat',
      nameEn: 'Avocado Hair Mask',
      subtitleAr: 'غنية بالفيتامينات والترطيب العميق.',
      subtitleEn: 'Rich in vitamins and deep hydration.',
      price: 140,
      imageUrl: _Images.honeyHairOil,
    ),
    HomeDemoProduct(
      id: 62,
      categoryId: 4,
      subcategoryId: 402,
      nameAr: 'علاج التقصف twinning',
      nameEn: 'Split Ends Treatment',
      subtitleAr: 'لإصلاح أطراف الشعر المتقصفة.',
      subtitleEn: 'Repair split ends.',
      price: 100,
      imageUrl: _Images.honeyHairOil,
    ),
    HomeDemoProduct(
      id: 63,
      categoryId: 4,
      subcategoryId: 402,
      nameAr: 'زيت الجوجوبا',
      nameEn: 'Jojoba Oil',
      subtitleAr: ' لترطيب فروة الرأس.',
      subtitleEn: 'For scalp moisturizing.',
      price: 85,
      imageUrl: _Images.honeyHairOil,
    ),
    HomeDemoProduct(
      id: 64,
      categoryId: 5,
      subcategoryId: 501,
      nameAr: 'مناديل أطفال رطبة',
      nameEn: 'Baby Wet Wipes',
      subtitleAr: 'للتنظيف السريع والمنع.',
      subtitleEn: 'Quick cleaning and refreshing.',
      price: 45,
      imageUrl: _Images.careLotion,
    ),
  ];

  static List<HomeDemoProduct> get discounts => productsForIds(const [1, 2, 3]);

  static List<HomeDemoProduct> get bestSelling => productsForIds(const [4, 5, 6, 7, 8, 9]);

  static List<HomeDemoProduct> get newArrivals => productsForIds(const [10, 11, 12, 13, 14, 15]);

  static List<HomeDemoProduct> get specialPackages => productsForIds(const [16, 17, 18, 19, 20]);

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

  static List<HomeDemoProduct> productsFor({int? categoryId, int? subcategoryId}) {
    if (subcategoryId != null) {
      return allProducts.where((product) => product.subcategoryId == subcategoryId).toList();
    }
    if (categoryId != null) {
      return allProducts.where((product) => product.categoryId == categoryId).toList();
    }
    return allProducts;
  }

  static List<HomeDemoProduct> productsForBanner(int index) {
    switch (index) {
      case 1: return discounts;
      case 2: return bestSelling;
      default: return allProducts;
    }
  }

  static const reviews = <HomeDemoReview>[];
}

class _Images {
  const _Images._();

  static const cicastim = 'assets/products/Acm-Cicastim-Repair-Cream-20ml-400x400.webp';
  static const depiwhite = 'assets/products/ACM-DEPIWHITE-CREAM-ADVANCED-40-ML-3-441x441.webp';
  static const depiwhiteEye = 'assets/products/ACM-DEPIWHITE-EYE-CONTOUR-GEL-15ML-2-400x400.webp';
  static const actiCollaAdvance = 'assets/products/ACTI-COLLA-ADVANCE-30-SACHETS-400x400.webp';
  static const actiCollaC = 'assets/products/ACTI-COLLA-C-30-SACHETS-1-400x400.webp';
  static const actinPlus = 'assets/products/ACTIN-PLUS-30-SACHETS-441x441.webp';
  static const alejonHairLoss = 'assets/products/ALEJON-ANT-HAIR-LOSS-15VIALS-400x400.webp';
  static const careLotion = 'assets/products/Care-Lotion-220-570x570-1-441x441.webp';
  static const diclac = 'assets/products/DICLAC-150MG-ID-20-TAB-400x400.webp';
  static const essenceMascara = 'assets/products/Essence-Lash-PRINCESS-curl-amp-volume-mascara-400x400.webp';
  static const fatroxim = 'assets/products/fatroxim-550mg-30-tabمحلى-400x400.webp';
  static const forxiga = 'assets/products/FORXIGA-5MG-28TAB-400x400.webp';
  static const fawarFruit = 'assets/products/FAWAR-FRUIT-6SACHETS-400x400.webp';
  static const honeyHairOil = 'assets/products/HONEY-DEEP-MOIST-HAIR-OIL-100-ML-400x400.webp';
  static const honeyCleansingOil = 'assets/products/HONEY-CLEANSING-OIL-180-ML-400x400.webp';
  static const bispyller = 'assets/products/New-Project-12-1-441x441.webp';
  static const adidasShower = 'assets/products/New-Project-2026-09-23T093411.830-441x441.webp';
  static const babyBath = 'assets/products/New-Project-2026-10-15T122505.250-441x441.webp';
  static const cradleCap = 'assets/products/New-Project-2026-10-15T134715.591-441x441.webp';
  static const collagenC = 'assets/products/New-Project-74-1-441x441.webp';
}