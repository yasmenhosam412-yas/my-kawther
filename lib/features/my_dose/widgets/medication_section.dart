// import 'package:flutter/material.dart';
// import '../../../../utils/app_colors.dart';
// import '../../../generated/l10n.dart';
// import 'medication_item.dart';
//
// class MedicationsSection extends StatelessWidget {
//   final List<Map<String, String>> medications;
//   final VoidCallback onAddPressed;
//
//   const MedicationsSection({
//     required this.medications,
//     required this.onAddPressed,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       child: Column(
//         children: [
//           // Top drag handle
//           Container(
//             height: 25,
//             decoration: const BoxDecoration(
//               color: AppColors.primaryColor,
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//           ),
//
//           // Inner container with slight overlap
//           Transform.translate(
//             offset: const Offset(0, -8),
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius:  BorderRadius.vertical(top: Radius.circular(16)),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       S.of(context).yourDailyDose,
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     CircleAvatar(
//                       radius: 15,
//                       backgroundColor: AppColors.primaryColor,
//                       child: IconButton(
//                         icon: const Icon(Icons.add, color: Colors.white),
//                         onPressed: onAddPressed,
//                         iconSize: 15,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // Content below
//           Expanded(
//             child: medications.isEmpty ? Center(
//               child: Text(
//                 S.of(context).thereAreNoDosesForTheSpecifiedDay,
//                 style: const TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             )
//                 : ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               itemCount: medications.length,
//               itemBuilder: (context, index) {
//                 final item = medications[index];
//                 return MedicationItem(
//                   time: item['time']!,
//                   name: item['name']!,
//                   details: item['details']!,
//                   iconPath: item['iconPath']!,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//
//
//
//   }
// }
