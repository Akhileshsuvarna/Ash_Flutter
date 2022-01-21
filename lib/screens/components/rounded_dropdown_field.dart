// import 'package:flutter/material.dart';

// class RoundedDropdownField extends StatelessWidget {
//   dynamic currentSelectedValue;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: FormField<dynamic>(
//         builder: (FormFieldState<dynamic> state) {
//           return InputDecorator(
//             decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5.0))),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<dynamic>(
//                 hint: Text("Select Device"),
//                 value: currentSelectedValue,
//                 isDense: true,
//                 onChanged: (newValue) {
  
//                     currentSelectedValue = newValue;
            
//                   print(currentSelectedValue);
//                 },
//                 items: deviceTypes.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
