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
    this.rating = 4.6,
    this.reviews = 32,
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
  });

  final int id;
  final String nameAr;
  final String nameEn;
  final String subtitleAr;
  final String subtitleEn;
  final IconData icon;
  final Color color;
  final List<int> productIds;

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
      titleAr: 'بانادول 500 – مسكنك اليومي',
      titleEn: 'Panadol 500 – everyday pain relief',
      imageUrl: _Images.bannerPharmacy,
    ),
    HomeDemoBanner(
      titleAr: 'خصم على سيرافي وسنتروم',
      titleEn: 'Offers on CeraVe and Centrum',
      imageUrl: _Images.bannerDiscount,
    ),
    HomeDemoBanner(
      titleAr: 'أجهزة قياس الضغط والحرارة',
      titleEn: 'BP monitors and thermometers',
      imageUrl: _Images.bannerDelivery,
    ),
  ];

  static const catalogCategories = [
    HomeDemoCategory(
      id: 1,
      nameAr: 'أدوية',
      nameEn: 'Medicines',
      imageUrl: _Images.panadol,
      subcategories: [
        HomeDemoSubcategory(
          id: 101,
          nameAr: 'مسكنات',
          nameEn: 'Pain relief',
          imageUrl: _Images.panadol,
        ),
        HomeDemoSubcategory(
          id: 102,
          nameAr: 'برد وإنفلونزا',
          nameEn: 'Cold & flu',
          imageUrl: _Images.strepsils,
        ),
      ],
    ),
    HomeDemoCategory(
      id: 2,
      nameAr: 'فيتامينات',
      nameEn: 'Vitamins',
      imageUrl: _Images.centrum,
      subcategories: [
        HomeDemoSubcategory(
          id: 201,
          nameAr: 'المناعة',
          nameEn: 'Immunity',
          imageUrl: _Images.redoxon,
        ),
        HomeDemoSubcategory(
          id: 202,
          nameAr: 'العظام والنوم',
          nameEn: 'Bone & sleep',
          imageUrl: _Images.vitaminD,
        ),
      ],
    ),
    HomeDemoCategory(
      id: 3,
      nameAr: 'عناية بالبشرة',
      nameEn: 'Skincare',
      imageUrl: _Images.cerave,
      subcategories: [
        HomeDemoSubcategory(
          id: 301,
          nameAr: 'مرطبات',
          nameEn: 'Moisturizers',
          imageUrl: _Images.cerave,
        ),
        HomeDemoSubcategory(
          id: 302,
          nameAr: 'سيروم',
          nameEn: 'Serums',
          imageUrl: _Images.ordinaryHa,
        ),
      ],
    ),
    HomeDemoCategory(
      id: 4,
      nameAr: 'عناية بالشعر',
      nameEn: 'Hair care',
      imageUrl: _Images.headShoulders,
      subcategories: [
        HomeDemoSubcategory(
          id: 401,
          nameAr: 'شامبو',
          nameEn: 'Shampoo',
          imageUrl: _Images.headShoulders,
        ),
        HomeDemoSubcategory(
          id: 402,
          nameAr: 'علاجات',
          nameEn: 'Treatments',
          imageUrl: _Images.mustelaHair,
        ),
      ],
    ),
    HomeDemoCategory(
      id: 5,
      nameAr: 'أطفال',
      nameEn: 'Baby',
      imageUrl: _Images.johnsonBaby,
      subcategories: [
        HomeDemoSubcategory(
          id: 501,
          nameAr: 'عناية الطفل',
          nameEn: 'Baby care',
          imageUrl: _Images.mustela,
        ),
        HomeDemoSubcategory(
          id: 502,
          nameAr: 'تغذية',
          nameEn: 'Feeding',
          imageUrl: _Images.johnsonBaby,
        ),
      ],
    ),
    HomeDemoCategory(
      id: 6,
      nameAr: 'أجهزة طبية',
      nameEn: 'Devices',
      imageUrl: _Images.bpMonitor,
      subcategories: [
        HomeDemoSubcategory(
          id: 601,
          nameAr: 'قياس ومتابعة',
          nameEn: 'Monitoring',
          imageUrl: _Images.thermometer,
        ),
        HomeDemoSubcategory(
          id: 602,
          nameAr: 'إسعاف أولي',
          nameEn: 'First aid',
          imageUrl: _Images.dettol,
        ),
      ],
    ),
  ];

  static List<HomeDemoChip> get categories => catalogCategories
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
      nameAr: 'بانادول',
      nameEn: 'Panadol',
      categoryAr: 'مسكنات',
      categoryEn: 'Pain relief',
      logoUrl: _Images.panadol,
      color: Color(0xFF0B76B9),
      productIds: [4, 13],
    ),
    HomeDemoBrand(
      id: 2,
      nameAr: 'سنتروم',
      nameEn: 'Centrum',
      categoryAr: 'فيتامينات',
      categoryEn: 'Vitamins',
      logoUrl: _Images.centrum,
      color: Color(0xFFF59E0B),
      productIds: [1, 10],
    ),
    HomeDemoBrand(
      id: 3,
      nameAr: 'لاروش بوزيه',
      nameEn: 'La Roche-Posay',
      categoryAr: 'عناية بالبشرة',
      categoryEn: 'Skincare',
      logoUrl: _Images.anthelios,
      color: Color(0xFF0B76B9),
      productIds: [16],
    ),
    HomeDemoBrand(
      id: 4,
      nameAr: 'سيرافي',
      nameEn: 'CeraVe',
      categoryAr: 'عناية بالبشرة',
      categoryEn: 'Skincare',
      logoUrl: _Images.cerave,
      color: Color(0xFF06A786),
      productIds: [17, 3, 11],
    ),
    HomeDemoBrand(
      id: 5,
      nameAr: 'جونسون',
      nameEn: "Johnson's",
      categoryAr: 'أطفال',
      categoryEn: 'Baby care',
      logoUrl: _Images.johnsonBaby,
      color: Color(0xFFEC4899),
      productIds: [12, 20, 21],
    ),
    HomeDemoBrand(
      id: 6,
      nameAr: 'موستيلا',
      nameEn: 'Mustela',
      categoryAr: 'أطفال',
      categoryEn: 'Baby care',
      logoUrl: _Images.mustela,
      color: Color(0xFF06A786),
      productIds: [20, 12],
    ),
    HomeDemoBrand(
      id: 7,
      nameAr: 'سنسوداين',
      nameEn: 'Sensodyne',
      categoryAr: 'العناية بالفم',
      categoryEn: 'Oral care',
      logoUrl: _Images.sensodyne,
      color: Color(0xFF0B76B9),
      productIds: [6],
    ),
    HomeDemoBrand(
      id: 8,
      nameAr: 'ديتول',
      nameEn: 'Dettol',
      categoryAr: 'تعقيم',
      categoryEn: 'Antiseptic',
      logoUrl: _Images.dettol,
      color: Color(0xFF16A34A),
      productIds: [24],
    ),
    HomeDemoBrand(
      id: 9,
      nameAr: 'هيد آند شولدرز',
      nameEn: 'Head & Shoulders',
      categoryAr: 'عناية بالشعر',
      categoryEn: 'Hair care',
      logoUrl: _Images.headShoulders,
      color: Color(0xFF7C3AED),
      productIds: [9],
    ),
    HomeDemoBrand(
      id: 10,
      nameAr: 'ستربسلز',
      nameEn: 'Strepsils',
      categoryAr: 'أدوية',
      categoryEn: 'Medicines',
      logoUrl: _Images.strepsils,
      color: Color(0xFF7C3AED),
      productIds: [14],
    ),
    HomeDemoBrand(
      id: 11,
      nameAr: 'حكمة',
      nameEn: 'Hikma',
      categoryAr: 'أدوية',
      categoryEn: 'Medicines',
      logoUrl: _Images.omeprazole,
      color: Color(0xFF0B76B9),
      productIds: [25],
    ),
    HomeDemoBrand(
      id: 12,
      nameAr: 'ذا أورديناري',
      nameEn: 'The Ordinary',
      categoryAr: 'عناية بالبشرة',
      categoryEn: 'Skincare',
      logoUrl: _Images.ordinaryHa,
      color: Color(0xFFDC2626),
      productIds: [7],
    ),
    HomeDemoBrand(
      id: 13,
      nameAr: 'نيڤيا',
      nameEn: 'Nivea',
      categoryAr: 'عناية يومية',
      categoryEn: 'Daily care',
      logoUrl: _Images.niveaSoft,
      color: Color(0xFF1D4ED8),
      productIds: [18],
    ),
    HomeDemoBrand(
      id: 14,
      nameAr: 'أبوت',
      nameEn: 'Abbott',
      categoryAr: 'أجهزة ومكملات',
      categoryEn: 'Devices & nutrition',
      logoUrl: _Images.bpMonitor,
      color: Color(0xFF0B76B9),
      productIds: [22, 23],
    ),
    HomeDemoBrand(
      id: 15,
      nameAr: 'باير',
      nameEn: 'Bayer',
      categoryAr: 'فيتامينات',
      categoryEn: 'Vitamins',
      logoUrl: _Images.redoxon,
      color: Color(0xFF16A34A),
      productIds: [5, 28],
    ),
    HomeDemoBrand(
      id: 16,
      nameAr: 'فاركو',
      nameEn: 'Pharco',
      categoryAr: 'أدوية',
      categoryEn: 'Medicines',
      logoUrl: _Images.ibuprofen,
      color: Color(0xFF0B76B9),
      productIds: [25, 26],
    ),
  ];

  static const catalogProblems = [
    HomeDemoProblem(
      id: 1,
      nameAr: 'الصداع',
      nameEn: 'Headache',
      subtitleAr: 'مسكنات للصداع والصداع النصفي',
      subtitleEn: 'Relief for headache and migraine',
      icon: Icons.psychology_alt_rounded,
      color: Color(0xFF0B76B9),
      productIds: [4, 13],
    ),
    HomeDemoProblem(
      id: 2,
      nameAr: 'برد وإنفلونزا',
      nameEn: 'Cold & flu',
      subtitleAr: 'حرارة، احتقان، وإرهاق',
      subtitleEn: 'Fever, congestion, and fatigue',
      icon: Icons.coronavirus_outlined,
      color: Color(0xFF06A786),
      productIds: [14, 4, 5],
    ),
    HomeDemoProblem(
      id: 3,
      nameAr: 'الحساسية',
      nameEn: 'Allergy',
      subtitleAr: 'عطس وحساسية موسمية',
      subtitleEn: 'Sneezing and seasonal allergy',
      icon: Icons.air_rounded,
      color: Color(0xFF7C3AED),
      productIds: [14, 5],
    ),
    HomeDemoProblem(
      id: 4,
      nameAr: 'السعال',
      nameEn: 'Cough',
      subtitleAr: 'تهدئة الحلق والسعال',
      subtitleEn: 'Soothe throat and cough',
      icon: Icons.masks_outlined,
      color: Color(0xFF0EA5E9),
      productIds: [14, 29],
    ),
    HomeDemoProblem(
      id: 5,
      nameAr: 'الجهاز الهضمي',
      nameEn: 'Digestion',
      subtitleAr: 'المعدة والهضم اليومي',
      subtitleEn: 'Stomach and daily digestion',
      icon: Icons.restaurant_outlined,
      color: Color(0xFFF59E0B),
      productIds: [26],
    ),
    HomeDemoProblem(
      id: 6,
      nameAr: 'المناعة',
      nameEn: 'Immunity',
      subtitleAr: 'فيتامينات لدعم المناعة',
      subtitleEn: 'Vitamins for immune support',
      icon: Icons.health_and_safety_outlined,
      color: Color(0xFF16A34A),
      productIds: [5, 15, 10, 1],
    ),
    HomeDemoProblem(
      id: 7,
      nameAr: 'النوم',
      nameEn: 'Sleep',
      subtitleAr: 'استرخاء وجودة النوم',
      subtitleEn: 'Relaxation and better sleep',
      icon: Icons.bedtime_outlined,
      color: Color(0xFF6366F1),
      productIds: [8],
    ),
    HomeDemoProblem(
      id: 8,
      nameAr: 'تساقط الشعر',
      nameEn: 'Hair loss',
      subtitleAr: 'تقوية الشعر والتغذية',
      subtitleEn: 'Hair strength and nourishment',
      icon: Icons.content_cut_rounded,
      color: Color(0xFFDB2777),
      productIds: [9, 19],
    ),
    HomeDemoProblem(
      id: 9,
      nameAr: 'حب الشباب',
      nameEn: 'Acne',
      subtitleAr: 'تنظيف وتهدئة البشرة',
      subtitleEn: 'Cleanse and calm the skin',
      icon: Icons.face_retouching_natural_rounded,
      color: Color(0xFF14B8A6),
      productIds: [7, 17, 16, 3],
    ),
    HomeDemoProblem(
      id: 10,
      nameAr: 'السكري',
      nameEn: 'Diabetes',
      subtitleAr: 'متابعة ودعم يومي',
      subtitleEn: 'Daily monitoring and support',
      icon: Icons.bloodtype_outlined,
      color: Color(0xFFDC2626),
      productIds: [23, 2],
    ),
    HomeDemoProblem(
      id: 11,
      nameAr: 'ضغط الدم',
      nameEn: 'Blood pressure',
      subtitleAr: 'قياس ومتابعة منزلية',
      subtitleEn: 'Home measuring and follow-up',
      icon: Icons.monitor_heart_outlined,
      color: Color(0xFFEF4444),
      productIds: [23],
    ),
    HomeDemoProblem(
      id: 12,
      nameAr: 'العظام والمفاصل',
      nameEn: 'Bones & joints',
      subtitleAr: 'فيتامين د ومسكنات الالتهاب',
      subtitleEn: 'Vitamin D and joint comfort',
      icon: Icons.accessibility_new_rounded,
      color: Color(0xFF0B76B9),
      productIds: [28, 25],
    ),
    HomeDemoProblem(
      id: 13,
      nameAr: 'عناية الطفل',
      nameEn: 'Baby care',
      subtitleAr: 'بشرة الطفل والتغذية',
      subtitleEn: 'Baby skin and nutrition',
      icon: Icons.child_care_rounded,
      color: Color(0xFFEC4899),
      productIds: [12, 20, 21],
    ),
    HomeDemoProblem(
      id: 14,
      nameAr: 'الحرارة',
      nameEn: 'Fever',
      subtitleAr: 'خافض حرارة ومتابعة',
      subtitleEn: 'Fever relief and monitoring',
      icon: Icons.thermostat_rounded,
      color: Color(0xFFF97316),
      productIds: [4, 22],
    ),
  ];

  static List<HomeDemoChip> get brands => catalogBrands
      .map(
        (brand) => HomeDemoChip(
          id: brand.id,
          nameAr: brand.nameAr,
          nameEn: brand.nameEn,
          imageUrl: brand.logoUrl,
        ),
      )
      .toList();

  static List<HomeDemoChip> get healthIssues => catalogProblems
      .map(
        (problem) => HomeDemoChip(
          id: problem.id,
          nameAr: problem.nameAr,
          nameEn: problem.nameEn,
          imageUrl: '',
        ),
      )
      .toList();

  static const discounts = [
    HomeDemoProduct(
      id: 1,
      categoryId: 2,
      subcategoryId: 201,
      nameAr: 'سنتروم للبالغين 30 قرص',
      nameEn: 'Centrum Adults 30 tablets',
      subtitleAr: 'ملتي فيتامين يومي كامل',
      subtitleEn: 'Complete daily multivitamin',
      price: 285,
      originalPrice: 360,
      discountLabel: '21%',
      rating: 4.8,
      reviews: 186,
      imageUrl: _Images.centrum,
    ),
    HomeDemoProduct(
      id: 2,
      categoryId: 2,
      subcategoryId: 201,
      nameAr: 'أوميغا 3 – 80 كبسولة',
      nameEn: 'Omega-3 80 capsules',
      subtitleAr: 'EPA و DHA لدعم القلب والذاكرة',
      subtitleEn: 'EPA & DHA for heart and memory',
      price: 240,
      originalPrice: 310,
      discountLabel: '23%',
      rating: 4.7,
      reviews: 94,
      imageUrl: _Images.omega3,
    ),
    HomeDemoProduct(
      id: 3,
      categoryId: 3,
      subcategoryId: 301,
      nameAr: 'سيرافي كريم مرطب 453 جم',
      nameEn: 'CeraVe Moisturizing Cream 453g',
      subtitleAr: 'سيراميد وحمض الهيالورونيك للبشرة الجافة',
      subtitleEn: 'Ceramides and hyaluronic acid for dry skin',
      price: 720,
      originalPrice: 890,
      discountLabel: '19%',
      rating: 4.9,
      reviews: 312,
      imageUrl: _Images.cerave,
    ),
  ];

  static const bestSelling = [
    HomeDemoProduct(
      id: 4,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'بانادول 500 مجم 24 قرص',
      nameEn: 'Panadol 500 mg 24 tablets',
      subtitleAr: 'باراسيتامول مسكن وخافض للحرارة',
      subtitleEn: 'Paracetamol for pain and fever',
      price: 55,
      rating: 4.9,
      reviews: 842,
      imageUrl: _Images.panadol,
    ),
    HomeDemoProduct(
      id: 5,
      categoryId: 2,
      subcategoryId: 201,
      nameAr: 'ريدوكسون فيتامين سي 1000 مجم',
      nameEn: 'Redoxon Vitamin C 1000 mg',
      subtitleAr: 'أقراص فوارة لدعم المناعة',
      subtitleEn: 'Effervescent tablets for immunity',
      price: 95,
      rating: 4.7,
      reviews: 268,
      imageUrl: _Images.redoxon,
    ),
    HomeDemoProduct(
      id: 6,
      categoryId: 1,
      subcategoryId: 102,
      nameAr: 'سنسوداين ريبير آند بروتكت 75 مل',
      nameEn: 'Sensodyne Repair & Protect 75ml',
      subtitleAr: 'معجون أسنان للحساسية وإصلاح المينا',
      subtitleEn: 'Toothpaste for sensitivity and enamel repair',
      price: 98,
      rating: 4.6,
      reviews: 154,
      imageUrl: _Images.sensodyne,
    ),
  ];

  static const newArrivals = [
    HomeDemoProduct(
      id: 7,
      categoryId: 3,
      subcategoryId: 302,
      nameAr: 'ذا أورديناري هيالورونيك 2% + B5',
      nameEn: 'The Ordinary Hyaluronic Acid 2% + B5',
      subtitleAr: 'سيروم ترطيب 30 مل',
      subtitleEn: 'Hydration serum 30ml',
      price: 480,
      rating: 4.7,
      reviews: 203,
      imageUrl: _Images.ordinaryHa,
    ),
    HomeDemoProduct(
      id: 8,
      categoryId: 2,
      subcategoryId: 202,
      nameAr: 'مغنيسيوم B6 50 قرص',
      nameEn: 'Magnesium B6 50 tablets',
      subtitleAr: 'للاسترخاء والعضلات والنوم',
      subtitleEn: 'For relaxation, muscles and sleep',
      price: 90,
      rating: 4.5,
      reviews: 77,
      imageUrl: _Images.magnesiumTabs,
    ),
    HomeDemoProduct(
      id: 9,
      categoryId: 4,
      subcategoryId: 401,
      nameAr: 'هيد آند شولدرز كلاسيك 400 مل',
      nameEn: 'Head & Shoulders Classic 400ml',
      subtitleAr: 'شامبو ضد القشرة للاستخدام اليومي',
      subtitleEn: 'Daily anti-dandruff shampoo',
      price: 110,
      rating: 4.4,
      reviews: 129,
      imageUrl: _Images.headShoulders,
    ),
  ];

  static const specialPackages = [
    HomeDemoProduct(
      id: 10,
      categoryId: 2,
      subcategoryId: 201,
      nameAr: 'باقة المناعة (سنتروم + ريدوكسون + زنك)',
      nameEn: 'Immunity pack (Centrum + Redoxon + Zinc)',
      subtitleAr: 'دعم يومي متكامل للمناعة',
      subtitleEn: 'Complete daily immune support',
      price: 420,
      originalPrice: 510,
      discountLabel: '90 EGP',
      rating: 4.8,
      reviews: 64,
      imageUrl: _Images.centrum,
    ),
    HomeDemoProduct(
      id: 11,
      categoryId: 3,
      subcategoryId: 301,
      nameAr: 'باقة العناية (سيرافي + أنثيليوس)',
      nameEn: 'Skincare pack (CeraVe + Anthelios)',
      subtitleAr: 'ترطيب وحماية من الشمس SPF50',
      subtitleEn: 'Moisturize and protect with SPF50',
      price: 1180,
      originalPrice: 1370,
      discountLabel: '190 EGP',
      rating: 4.7,
      reviews: 41,
      imageUrl: _Images.anthelios,
    ),
    HomeDemoProduct(
      id: 12,
      categoryId: 5,
      subcategoryId: 501,
      nameAr: 'باقة الأطفال (موستيلا + جونسون)',
      nameEn: "Baby pack (Mustela + Johnson's)",
      subtitleAr: 'عناية لطيفة لبشرة الطفل',
      subtitleEn: 'Gentle care for baby skin',
      price: 380,
      originalPrice: 450,
      discountLabel: '70 EGP',
      rating: 4.8,
      reviews: 52,
      imageUrl: _Images.mustela,
    ),
  ];

  static const extraCategoryProducts = [
    HomeDemoProduct(
      id: 13,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'بانادول إكسترا 24 قرص',
      nameEn: 'Panadol Extra 24 tablets',
      subtitleAr: 'باراسيتامول 500 مجم + كافيين 65 مجم',
      subtitleEn: 'Paracetamol 500mg + caffeine 65mg',
      price: 72,
      rating: 4.8,
      reviews: 431,
      imageUrl: _Images.panadol,
    ),
    HomeDemoProduct(
      id: 14,
      categoryId: 1,
      subcategoryId: 102,
      nameAr: 'ستربسلز عسل وليمون 24 قرص',
      nameEn: 'Strepsils Honey & Lemon 24 lozenges',
      subtitleAr: 'لعلاج التهاب الحلق والسعال الخفيف',
      subtitleEn: 'For sore throat and mild cough',
      price: 65,
      rating: 4.5,
      reviews: 118,
      imageUrl: _Images.strepsils,
    ),
    HomeDemoProduct(
      id: 15,
      categoryId: 2,
      subcategoryId: 201,
      nameAr: 'زنك 50 مجم 30 قرص',
      nameEn: 'Zinc 50 mg 30 tablets',
      subtitleAr: 'دعم المناعة وصحة الجلد',
      subtitleEn: 'Immunity and skin support',
      price: 55,
      rating: 4.4,
      reviews: 63,
      imageUrl: _Images.zinc,
    ),
    HomeDemoProduct(
      id: 16,
      categoryId: 3,
      subcategoryId: 301,
      nameAr: 'لاروش بوزيه أنثيليوس XL SPF50',
      nameEn: 'La Roche-Posay Anthelios XL SPF50',
      subtitleAr: 'واقي شمس 50 مل للوجه',
      subtitleEn: 'Face sunscreen 50ml',
      price: 650,
      rating: 4.8,
      reviews: 227,
      imageUrl: _Images.anthelios,
    ),
    HomeDemoProduct(
      id: 17,
      categoryId: 3,
      subcategoryId: 302,
      nameAr: 'سيرافي غسول رغوي 236 مل',
      nameEn: 'CeraVe Foaming Cleanser 236ml',
      subtitleAr: 'ينظف البشرة دون إزالة الحاجز الدهني',
      subtitleEn: 'Cleanses without stripping the skin barrier',
      price: 395,
      rating: 4.6,
      reviews: 174,
      imageUrl: _Images.cerave,
    ),
    HomeDemoProduct(
      id: 18,
      categoryId: 3,
      subcategoryId: 301,
      nameAr: 'نيڤيا سوفت 200 مل',
      nameEn: 'Nivea Soft 200ml',
      subtitleAr: 'كريم مرطب خفيف للجسم والوجه',
      subtitleEn: 'Light moisturizing cream for body and face',
      price: 75,
      rating: 4.5,
      reviews: 201,
      imageUrl: _Images.niveaSoft,
    ),
    HomeDemoProduct(
      id: 19,
      categoryId: 4,
      subcategoryId: 402,
      nameAr: 'موستيلا ماء منعش للشعر',
      nameEn: 'Mustela refreshing hair water',
      subtitleAr: 'يرطب ويسهل تسريح شعر الطفل',
      subtitleEn: 'Moisturizes and eases baby hair styling',
      price: 210,
      rating: 4.6,
      reviews: 48,
      imageUrl: _Images.mustelaHair,
    ),
    HomeDemoProduct(
      id: 20,
      categoryId: 5,
      subcategoryId: 501,
      nameAr: 'موستيلا جل استحمام 500 مل',
      nameEn: 'Mustela cleansing gel 500ml',
      subtitleAr: 'غسول لطيف للجسم والشعر من الولادة',
      subtitleEn: 'Gentle body and hair wash from birth',
      price: 325,
      rating: 4.8,
      reviews: 96,
      imageUrl: _Images.mustela,
    ),
    HomeDemoProduct(
      id: 21,
      categoryId: 5,
      subcategoryId: 502,
      nameAr: 'جونسون شامبو الأطفال 500 مل',
      nameEn: "Johnson's Baby Shampoo 500ml",
      subtitleAr: 'تركيبة لا دموع بعد اليوم',
      subtitleEn: 'No more tears formula',
      price: 95,
      rating: 4.7,
      reviews: 158,
      imageUrl: _Images.johnsonBaby,
    ),
    HomeDemoProduct(
      id: 22,
      categoryId: 6,
      subcategoryId: 601,
      nameAr: 'ترمومتر رقمي فموي',
      nameEn: 'Digital oral thermometer',
      subtitleAr: 'قياس سريع للحرارة خلال ثوانٍ',
      subtitleEn: 'Fast temperature reading in seconds',
      price: 180,
      rating: 4.6,
      reviews: 89,
      imageUrl: _Images.thermometer,
    ),
    HomeDemoProduct(
      id: 23,
      categoryId: 6,
      subcategoryId: 601,
      nameAr: 'جهاز ضغط دم رقمي للذراع',
      nameEn: 'Upper-arm blood pressure monitor',
      subtitleAr: 'متابعة منزلية مع ذاكرة للقراءات',
      subtitleEn: 'Home monitoring with reading memory',
      price: 1250,
      rating: 4.5,
      reviews: 67,
      imageUrl: _Images.bpMonitor,
    ),
    HomeDemoProduct(
      id: 24,
      categoryId: 6,
      subcategoryId: 602,
      nameAr: 'ديتول مطهر سائل 250 مل',
      nameEn: 'Dettol antiseptic liquid 250ml',
      subtitleAr: 'تعقيم الجروح والأسطح والاستخدام المنزلي',
      subtitleEn: 'Wound, surface and household antiseptic',
      price: 85,
      rating: 4.7,
      reviews: 143,
      imageUrl: _Images.dettol,
    ),
    HomeDemoProduct(
      id: 25,
      categoryId: 1,
      subcategoryId: 101,
      nameAr: 'إيبالجين 400 مجم 24 قرص',
      nameEn: 'Ibalgin 400 mg 24 tablets',
      subtitleAr: 'إيبوبروفين مضاد للالتهاب ومسكن',
      subtitleEn: 'Ibuprofen anti-inflammatory pain relief',
      price: 48,
      rating: 4.6,
      reviews: 192,
      imageUrl: _Images.ibuprofen,
    ),
    HomeDemoProduct(
      id: 26,
      categoryId: 1,
      subcategoryId: 102,
      nameAr: 'أوميبرازول 20 مجم 14 كبسولة',
      nameEn: 'Omeprazole 20 mg 14 capsules',
      subtitleAr: 'لحموضة المعدة وحرقة المعدة',
      subtitleEn: 'For acid reflux and heartburn',
      price: 62,
      rating: 4.5,
      reviews: 81,
      imageUrl: _Images.omeprazole,
    ),
    HomeDemoProduct(
      id: 27,
      categoryId: 6,
      subcategoryId: 602,
      nameAr: 'بيتادين مطهر 120 مل',
      nameEn: 'Betadine antiseptic 120ml',
      subtitleAr: 'بوفيدون أيودين لتعقيم الجروح',
      subtitleEn: 'Povidone-iodine for wound disinfection',
      price: 78,
      rating: 4.7,
      reviews: 74,
      imageUrl: _Images.betadine,
    ),
    HomeDemoProduct(
      id: 28,
      categoryId: 2,
      subcategoryId: 202,
      nameAr: 'فيتامين د3 5000 وحدة 30 كبسولة',
      nameEn: 'Vitamin D3 5000 IU 30 capsules',
      subtitleAr: 'لدعم العظام والمناعة',
      subtitleEn: 'Bone and immune support',
      price: 165,
      originalPrice: 210,
      discountLabel: '21%',
      rating: 4.8,
      reviews: 139,
      imageUrl: _Images.vitaminD,
    ),
    HomeDemoProduct(
      id: 29,
      categoryId: 1,
      subcategoryId: 102,
      nameAr: 'ليسترين كول منت 500 مل',
      nameEn: 'Listerine Cool Mint 500ml',
      subtitleAr: 'غسول فم مضاد للبكتيريا',
      subtitleEn: 'Antiseptic mouthwash',
      price: 120,
      rating: 4.4,
      reviews: 88,
      imageUrl: _Images.listerine,
    ),
    HomeDemoProduct(
      id: 30,
      categoryId: 6,
      subcategoryId: 602,
      nameAr: 'علبة إسعاف أولي كاملة',
      nameEn: 'Complete first aid kit',
      subtitleAr: 'شاش، بلاستر، مطهر وأدوات أساسية',
      subtitleEn: 'Gauze, plasters, antiseptic and essentials',
      price: 195,
      rating: 4.6,
      reviews: 39,
      imageUrl: _Images.firstAid,
    ),
  ];

  static List<HomeDemoProduct> get allProducts {
    final seen = <int>{};
    final products = <HomeDemoProduct>[];
    for (final product in [
      ...discounts,
      ...bestSelling,
      ...newArrivals,
      ...specialPackages,
      ...extraCategoryProducts,
    ]) {
      if (seen.add(product.id)) {
        products.add(product);
      }
    }
    return products;
  }

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
    final products = allProducts;
    if (subcategoryId != null) {
      return products
          .where((product) => product.subcategoryId == subcategoryId)
          .toList();
    }
    if (categoryId != null) {
      return products
          .where((product) => product.categoryId == categoryId)
          .toList();
    }
    return products;
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

  static const reviews = [
    HomeDemoReview(
      nameAr: 'سارة أحمد',
      nameEn: 'Sara Ahmed',
      commentAr: 'بانادول نفعني للصداع من أول جرعة.',
      commentEn: 'Panadol helped my headache from the first dose.',
      rating: 5,
      date: '12/08/2026',
    ),
    HomeDemoReview(
      nameAr: 'محمد علي',
      nameEn: 'Mohamed Ali',
      commentAr: 'كريم سيرافي ممتاز للبشرة الجافة وسعره مناسب.',
      commentEn: 'CeraVe cream is great for dry skin and fairly priced.',
      rating: 4,
      date: '04/08/2026',
    ),
    HomeDemoReview(
      nameAr: 'نورا حسن',
      nameEn: 'Noura Hassan',
      commentAr: 'التوصيل سريع والتغليف ممتاز.',
      commentEn: 'Fast delivery and excellent packaging.',
      rating: 5,
      date: '28/07/2026',
    ),
    HomeDemoReview(
      nameAr: 'أحمد يوسف',
      nameEn: 'Ahmed Youssef',
      commentAr: 'جيد جداً لكن العبوة أصغر مما توقعت.',
      commentEn: 'Very good, but the pack is smaller than I expected.',
      rating: 4,
      date: '19/07/2026',
    ),
  ];
}

class _Images {
  const _Images._();

  static const panadol =
      'https://images.openproductsfacts.org/images/products/505/456/312/5491/front_en.14.400.jpg';
  static const ibuprofen =
      'https://images.openproductsfacts.org/images/products/500/015/810/6512/front_ro.8.400.jpg';
  static const redoxon =
      'https://images.openfoodfacts.org/images/products/628/507/400/4688/front_en.3.400.jpg';
  static const centrum =
      'https://images.openfoodfacts.org/images/products/030/573/445/1747/front_en.5.400.jpg';
  static const vitaminD =
      'https://images.openfoodfacts.org/images/products/002/324/901/1347/front_en.53.400.jpg';
  static const magnesiumTabs =
      'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?auto=format&fit=crop&w=500&q=80';
  static const omeprazole =
      'https://images.openproductsfacts.org/images/products/502/590/302/9649/front_fr.3.400.jpg';
  static const strepsils =
      'https://images.openproductsfacts.org/images/products/340/093/322/6619/front_en.11.400.jpg';
  static const betadine =
      'https://images.openbeautyfacts.org/images/products/899/284/310/1902/front_en.3.400.jpg';
  static const thermometer =
      'https://images.openproductsfacts.org/images/products/890/435/540/0879/front_en.3.400.jpg';
  static const bpMonitor =
      'https://images.openproductsfacts.org/images/products/934/520/700/0363/front_en.3.400.jpg';
  static const firstAid =
      'https://images.openproductsfacts.org/images/products/062/280/101/5559/front_en.3.400.jpg';
  static const cerave =
      'https://images.openbeautyfacts.org/images/products/360/600/053/7323/front_en.3.400.jpg';
  static const anthelios =
      'https://images.openbeautyfacts.org/images/products/333/787/549/1822/front_fr.4.400.jpg';
  static const ordinaryHa =
      'https://images.openbeautyfacts.org/images/products/076/991/519/0199/front_en.10.400.jpg';
  static const niveaSoft =
      'https://images.openbeautyfacts.org/images/products/400/580/889/0576/front_en.26.400.jpg';
  static const mustela =
      'https://images.openbeautyfacts.org/images/products/350/410/503/6751/front_en.7.400.jpg';
  static const mustelaHair =
      'https://images.openbeautyfacts.org/images/products/350/410/503/6027/front_fr.3.400.jpg';
  static const johnsonBaby =
      'https://images.openbeautyfacts.org/images/products/622/300/065/9243/front_fr.3.400.jpg';
  static const headShoulders =
      'https://images.openbeautyfacts.org/images/products/000/001/410/0765/front_en.26.400.jpg';
  static const sensodyne =
      'https://images.openbeautyfacts.org/images/products/309/490/500/1306/front_en.6.400.jpg';
  static const listerine =
      'https://images.openbeautyfacts.org/images/products/357/466/163/4920/front_en.9.400.jpg';
  static const dettol =
      'https://images.openbeautyfacts.org/images/products/600/110/610/8991/front_fr.16.400.jpg';
  static const omega3 =
      'https://images.openfoodfacts.org/images/products/340/159/919/7046/front_fr.7.400.jpg';
  static const zinc =
      'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=500&q=80';
  static const bannerPharmacy = panadol;
  static const bannerDiscount = cerave;
  static const bannerDelivery = bpMonitor;
}
