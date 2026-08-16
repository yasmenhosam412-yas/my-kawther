// import 'package:elkawther/views/my_dose/widgets/medication_section.dart';
// import 'package:flutter/material.dart';
//
// import 'package:table_calendar/table_calendar.dart';
// import '../../../generated/l10n.dart';
// import '../../../utils/app_colors.dart';
// import '../../../utils/app_padding.dart';
// import '../../../../generated/assets.dart';
// import '../../utils/routes.dart';
//
// class CalendarView  extends StatefulWidget {
//   const CalendarView({super.key});
//
//   @override
//   State<CalendarView> createState() => _CalendarViewState();
// }
//
// class _CalendarViewState extends State<CalendarView> {
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//
//   final Map<DateTime, List<Map<String, String>>> mockMedications = {
//     DateTime(2025, 4, 9): [
//       {
//         'time': '06:13',
//         'name': 'فطار 12u',
//         'details': 'فطار - 1200 مج',
//         'iconPath': Assets.iconsInfo,
//       },
//       {
//         'time': '09:41',
//         'name': 'أوميغا 3 بلس',
//         'details': 'أسبوعية - بعد 1000 مج',
//         'iconPath': Assets.iconsCheck,
//       },
//     ],
//   };
//
//   List<Map<String, String>> _getMedicationsForDay(DateTime day) {
//     return mockMedications[DateTime(day.year, day.month, day.day)] ?? [];
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final meds = _getMedicationsForDay(_selectedDay!);
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//
//           title: Text(S.of(context).calendar,
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//               //fontWeight: FontWeight.bold,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: Column(
//           children: [
//             const SizedBox(height: AppPadding.medium),
//             Divider(color: Colors.grey[300]),
//             TableCalendar(
//               locale: 'ar',
//               firstDay: DateTime.utc(2020, 1, 1),
//               lastDay: DateTime.utc(2030, 12, 31),
//               focusedDay: _focusedDay,
//               selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//               onDaySelected: (selectedDay, focusedDay) {
//                 setState(() {
//                   _selectedDay = selectedDay;
//                   _focusedDay = focusedDay;
//                 });
//               },
//               calendarStyle: const CalendarStyle(
//                 defaultTextStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 14, letterSpacing: 0.5), // تصغير الخط و المسافة بين الحروف
//                 //todayDecoration: BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
//                 selectedDecoration: BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
//               ),
//               daysOfWeekStyle: const DaysOfWeekStyle(
//                 weekdayStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5), // الأيام Bold و حجم أصغر مع مسافة بين الحروف
//                 weekendStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5), // نهاية الأسبوع Bold و حجم أصغر مع مسافة بين الحروف
//               ),
//               headerStyle: const HeaderStyle(
//                 formatButtonVisible: false,
//                 titleCentered: true,
//               ),
//             )
//             ,
//
//             Expanded(
//               child: MedicationsSection(
//                 medications: meds,
//                 onAddPressed: () {
//                     Navigator.pushNamed(context, Routes.addDose);
//
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
