import 'package:flutter/material.dart';


// showModalBottomSheet(
//                       context: context,
//                       isScrollControlled: true,
//                       showDragHandle: true,
//                       useSafeArea: true,
//                       builder: (context) {
//                         return ListView(
//                           shrinkWrap: true,
//                           children: [
//                             GestureDetector(
//                               onTap: () => selectImage('Camera'),
//                               child: const BottomModalItem(
//                                   text: "Click a picture",
//                                   icon: Icons.photo_outlined),
//                             ),
//                             const Divider(),
//                             GestureDetector(
//                               onTap: () => selectImage('Gallery'),
//                               child: const BottomModalItem(
//                                   text: "Choose from gallery",
//                                   icon: Icons.camera_alt_outlined),
//                             ),
//                           ],
//                         );
//                       },
//                     ) ;