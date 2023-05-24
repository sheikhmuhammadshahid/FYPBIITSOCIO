// import 'package:biit_social/Controllers/EventsController.dart';
// import 'package:biit_social/models/EventModel.dart';
// import 'package:biit_social/utils/SVConstants.dart';
// import 'package:calendar_view/calendar_view.dart';
// import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:omni_datetime_picker/omni_datetime_picker.dart';
// import 'package:provider/provider.dart';

// import '../../utils/SVCommon.dart';

// class AddEventsScreen extends StatefulWidget {
//   const AddEventsScreen({super.key});

//   @override
//   State<AddEventsScreen> createState() => _AddEventsScreenState();
// }

// class _AddEventsScreenState extends State<AddEventsScreen> {
//   TextEditingController controller = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController startDate = TextEditingController();
//   TextEditingController endDate = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   EventsController? eventsController;
//   bool toUpdate = false;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     eventsController ??= context.read<EventsController>();
//     eventsController!.getEvents();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: context.iconColor,
//           onPressed: () async {
//             toUpdate = false;
//             await SelectEvent(context, 0);
//           },
//           child: Icon(
//             Icons.add,
//             color: context.scaffoldBackgroundColor,
//           ),
//         ),
//         appBar: AppBar(
//           iconTheme: IconThemeData(color: context.iconColor),
//           backgroundColor: context.scaffoldBackgroundColor,
//           elevation: 0,
//           title: Text(
//             'Events',
//             style:
//                 TextStyle(color: context.iconColor, fontFamily: svFontRoboto),
//           ),
//         ),
//         backgroundColor: context.scaffoldBackgroundColor,
//         body: Padding(
//           padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: controller,
//                   decoration: const InputDecoration(
//                       label: Text('Date'), hintText: 'Select date to filter'),
//                   readOnly: true,
//                   onTap: () async {
//                     await selectDate(context, controller);
//                     if (controller.text.isNotEmpty) {
//                       setState(() {});
//                     }
//                   },
//                 ),
//                 20.height,
//                 Padding(
//                   padding: const EdgeInsets.only(left: 2, right: 2),
//                   child: SizedBox(
//                     height: context.height() * 0.74,
//                     child: context.watch<EventsController>().gettingEvents
//                         ? getNotificationShimmer(context)
//                         : eventsController!.events.isEmpty
//                             ? Center(
//                                 child: Text(
//                                 'Add some events to show!',
//                                 style: TextStyle(fontFamily: svFontRoboto),
//                               ))
//                             : ListView.builder(
//                                 itemCount: eventsController!.events.length,
//                                 itemBuilder: (context, index) {
//                                   EventModel event =
//                                       eventsController!.events[index];
//                                   return !(event.startDate
//                                               .toString()
//                                               .splitBefore('T')
//                                               .contains(controller.text
//                                                   .splitBefore(' ')) ||
//                                           event.endDate
//                                               .toString()
//                                               .splitBefore('T')
//                                               .contains(controller.text
//                                                   .splitBefore(' ')))
//                                       ? const SizedBox.shrink()
//                                       : Card(
//                                           color: context.cardColor,
//                                           child: ListTile(
//                                             title: Text(
//                                               event.Name,
//                                               style: TextStyle(
//                                                   fontFamily: svFontRoboto),
//                                             ),
//                                             subtitle: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 5.height,
//                                                 const Text('Dated:'),
//                                                 5.height,
//                                                 Text(
//                                                   "From: ${event.startDate.splitBefore('T')}",
//                                                   //? '${} - ${event.endDate.toString()}',
//                                                   style: TextStyle(
//                                                       fontFamily: svFontRoboto),
//                                                 ),
//                                                 3.height,
//                                                 Text(
//                                                   event.startDate ==
//                                                           event.endDate
//                                                       ? ''
//                                                       : 'To: ${event.endDate.toString().splitBefore('T')}',
//                                                   style: TextStyle(
//                                                       fontFamily: svFontRoboto),
//                                                 ),
//                                               ],
//                                             ),
//                                             trailing: PopupMenuButton(
//                                               itemBuilder: (context) {
//                                                 return [
//                                                   PopupMenuItem(
//                                                       child: TextButton(
//                                                           onPressed: () {
//                                                             eventsController!
//                                                                 .deleteEvent(
//                                                                     event.id);
//                                                             Navigator.pop(
//                                                                 context);
//                                                           },
//                                                           child: Row(
//                                                             children: [
//                                                               Icon(
//                                                                 Icons.delete,
//                                                                 color: context
//                                                                     .primaryColor
//                                                                     .withOpacity(
//                                                                         .8),
//                                                               ),
//                                                               const SizedBox(
//                                                                 width: 5,
//                                                               ),
//                                                               Text(
//                                                                 'Delete',
//                                                                 style:
//                                                                     boldTextStyle(),
//                                                               ),
//                                                             ],
//                                                           ))),
//                                                   PopupMenuItem(
//                                                       child: TextButton(
//                                                           onPressed: () async {
//                                                             nameController
//                                                                     .text =
//                                                                 event.Name;
//                                                             startDate.text =
//                                                                 event.startDate
//                                                                     .replaceAll(
//                                                                         'T',
//                                                                         ' ');
//                                                             endDate.text = event
//                                                                 .endDate
//                                                                 .replaceAll(
//                                                                     'T', ' ');
//                                                             toUpdate = true;
//                                                             await SelectEvent(
//                                                                 context,
//                                                                 event.id);
//                                                           },
//                                                           child: Row(
//                                                             children: [
//                                                               Icon(
//                                                                 Icons.edit,
//                                                                 color: context
//                                                                     .primaryColor
//                                                                     .withOpacity(
//                                                                         .8),
//                                                               ),
//                                                               const SizedBox(
//                                                                 width: 5,
//                                                               ),
//                                                               Text(
//                                                                 'Edit',
//                                                                 style: boldTextStyle(
//                                                                     color: context
//                                                                         .iconColor),
//                                                               ),
//                                                             ],
//                                                           ))),
//                                                 ];
//                                               },
//                                             ),
//                                           ),
//                                         );
//                                 }),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   selectDate(BuildContext context, TextEditingController controller) async {
//     DateTime? dt = await showOmniDateTimePicker(
//       context: context,
//       initialDate: controller.text.isNotEmpty
//           ? DateTime.parse(controller.text.trim())
//           : DateTime.now(),
//       firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
//       lastDate: DateTime.now().add(
//         const Duration(days: 3652),
//       ),
//       is24HourMode: false,
//       isShowSeconds: false,
//       minutesInterval: 1,
//       secondsInterval: 1,
//       borderRadius: const BorderRadius.all(Radius.circular(16)),
//       constraints: const BoxConstraints(
//         maxWidth: 350,
//         maxHeight: 650,
//       ),
//       transitionBuilder: (context, anim1, anim2, child) {
//         return FadeTransition(
//           opacity: anim1.drive(
//             Tween(
//               begin: 0,
//               end: 1,
//             ),
//           ),
//           child: child,
//         );
//       },
//       transitionDuration: const Duration(milliseconds: 200),
//       barrierDismissible: true,
//       selectableDayPredicate: (dateTime) {
//         // Disable 25th Feb 2023
//         if (dateTime == DateTime(2023, 2, 25)) {
//           return false;
//         } else {
//           return true;
//         }
//       },
//     );
//     if (dt != null) {
//       controller.text = dt.toString();
//     }
//   }

//   Future<dynamic> SelectEvent(BuildContext context, int id) {
//     return showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) => AlertDialog(
//         icon: Align(
//           alignment: Alignment.topRight,
//           child: IconButton(
//               icon: Icon(
//                 Icons.cancel,
//                 color: context.iconColor,
//               ),
//               onPressed: () {
//                 context.pop();
//               }),
//         ),
//         backgroundColor: context.cardColor,
//         title: Text(toUpdate ? 'Edit Event' : 'Add Event',
//             style:
//                 TextStyle(fontFamily: svFontRoboto, color: context.iconColor)),
//         content: SizedBox(
//           height: context.height() * 0.3,
//           child: Padding(
//             padding: const EdgeInsets.only(left: 5, right: 5),
//             child: Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       validator: (value) {
//                         if (value != null && value != '') {
//                           return null;
//                         }
//                         return 'Please enter name';
//                       },
//                       controller: nameController,
//                       decoration: const InputDecoration(
//                           label: Text('Name'), hintText: 'Enter event name'),
//                     ),
//                     10.height,
//                     TextFormField(
//                       readOnly: true,
//                       controller: startDate,
//                       onTap: () {
//                         selectDate(context, startDate);
//                       },
//                       validator: (value) {
//                         if (value != null && value != '') {
//                           return null;
//                         }
//                         return 'Please select start date!';
//                       },
//                       decoration: const InputDecoration(
//                           label: Text('Start date'), hintText: 'Start date'),
//                     ),
//                     10.height,
//                     TextFormField(
//                       readOnly: true,
//                       onTap: () {
//                         selectDate(context, endDate);
//                       },
//                       validator: (value) {
//                         if (value != null && value != '') {
//                           if (startDate.text.isNotEmpty) {
//                             if (DateTime.parse(startDate.text)
//                                     .isBefore(DateTime.parse(endDate.text)) ||
//                                 DateTime.parse(startDate.text).dateYMD ==
//                                     (DateTime.parse(endDate.text)).dateYMD) {
//                               return null;
//                             }
//                             return 'End date must be greater than start date!';
//                           }
//                         }
//                         return 'Please select end date!';
//                       },
//                       controller: endDate,
//                       decoration: const InputDecoration(
//                           label: Text('end date'), hintText: 'end date'),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         actions: [
//           ElevatedButton(
//               onPressed: () {
//                 // if (_formKey.currentState!.validate()) {
//                 //   EventModel event = EventModel(
//                 //       colorId: 0,
//                 //       id: id,
//                 //       startDate: startDate.text,
//                 //       endDate: endDate.text,
//                 //       Name: nameController.text);
//                 //   if (toUpdate) {
//                 //     eventsController!.updateEvent(event);
//                 //   } else {
//                 //     eventsController!.addEvent(event);
//                 //   }
//                 //   context.pop();
//                 // }
//               },
//               child: Text(
//                 toUpdate ? 'Update' : 'Add',
//                 style: TextStyle(
//                     color: context.scaffoldBackgroundColor,
//                     fontFamily: svFontRoboto),
//               ))
//         ],
//       ),
//     );
//   }
// }
