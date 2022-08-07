// import 'package:flutter/material.dart';

// class Permessions {
//   //get cam per shows dialog if rejected!!
//   static Future<bool> getCamPerm(BuildContext context) async {
//     await PermissionHandler().requestPermissions([PermissionGroup.camera]);
//     final permissionStatus =
//         await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

//     if (permissionStatus.value != 2) {
//       final locale = AppLocalizations.of(context);

//       final action = await UI.dialog(
//               context: context,
//               child: Icon(Icons.camera, size: 44),
//               title: locale.tr("permission denied"),
//               accept: true,
//               msg: locale.tr("camera denied"),
//               cancelMsg: locale.tr('cancel'),
//               acceptMsg: locale.tr('try again')) ??
//           false;
//       if (action) return getCamPerm(context) ?? false;
//       return false;
//     }
//     return true;
//   }

//   static Future<bool> getStoragePerm(BuildContext context) async {
//     await PermissionHandler().requestPermissions(
//         [PermissionGroup.storage, PermissionGroup.mediaLibrary]);
//     final permissionStatus1 = await PermissionHandler()
//         .checkPermissionStatus(PermissionGroup.storage);
//     final permissionStatus2 = await PermissionHandler()
//         .checkPermissionStatus(PermissionGroup.mediaLibrary);

//     if (permissionStatus2.value != 2 || permissionStatus1.value != 2) {
//       final locale = AppLocalizations.of(context);

//       final action = await UI.dialog(
//               context: context,
//               child: Icon(Icons.storage, size: 44),
//               title: locale.tr("permission denied"),
//               accept: true,
//               // msg: locale.tr("camera denied"),
//               cancelMsg: locale.tr('cancel'),
//               acceptMsg: locale.tr('try again')) ??
//           false;
//       if (action) return getStoragePerm(context) ?? false;
//       return false;
//     }
//     return true;
//   }
// }
