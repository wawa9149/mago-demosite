// import 'package:comet/apiResultPage.dart';
// import 'package:flutter/material.dart';
//
// class TextResult extends StatefulWidget {
//   const TextResult({super.key});
//
//   @override
//   State<TextResult> createState() => TextResultState();
//
// }
//
// class TextResultState extends State<TextResult> {
//   // String? s2tResult = '';
//   // String? abmResult = '';
//   // String? emoResult = '';
//   final apiResultPageState = ApiResultPageState();
//   // bool isLoaded = false;
//
//   // void receiveResult(String flag, String s2tRequestResult, String abmRequestResult, String emoRequestResult) {
//   //       s2tResult = s2tRequestResult;
//   //       abmResult = abmRequestResult;
//   //       emoResult = emoRequestResult;
//   //       //print('전달 결과 값 출력! s2tResult: $s2tResult, abmResult: $abmResult, emoResult: $emoResult');
//   // }
//
//   // @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         //ElevatedButton(onPressed: setResult, child: const Text('결과 확인')),
//         Container(
//           height: 300,
//           width: 300,
//           padding: EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             border: Border.all(
//               width: 5,
//               color: Colors.blue,
//             ),
//             borderRadius: const BorderRadius.all(Radius.circular(20)),
//           ),
//           child: SingleChildScrollView(
//               // 스크롤 가능
//               child: Center(
//                 child: Text(apiResultPageState.s2tResult!), // 결과 출력
//               ),
//           ),
//         ),
//         SizedBox(width: 20),
//         Container(
//           height: 300,
//           width: 300,
//           padding: EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             border: Border.all(
//               width: 5,
//               color: Colors.blue,
//             ),
//             borderRadius: const BorderRadius.all(Radius.circular(20)),
//           ),
//           child: SingleChildScrollView(
//               // 스크롤 가능
//               child: Center(
//                   child: Text(apiResultPageState.abmResult!)) // 결과 출력
//           ),
//         ),
//         SizedBox(width: 20),
//         Container(
//           height: 300,
//           width: 300,
//           padding: EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             border: Border.all(
//               width: 5,
//               color: Colors.blue,
//             ),
//             borderRadius: const BorderRadius.all(Radius.circular(20)),
//           ),
//           child: SingleChildScrollView(
//               // 스크롤 가능
//               child: Center(
//                   child: Text(apiResultPageState.emoResult!)) // 결과 출력
//           ),
//         ),
//       ],
//     );
//   }
// }
