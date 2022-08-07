import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_option/either_option.dart';
import 'package:flutter/material.dart';
import 'package:ts_academy/core/models/server_error.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/ui/routes/ui.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart' as WEPICKER;

import 'api/api.dart';
import 'api/http_api.dart';
import 'localization/localization.dart';

/// الترجمة العربية
class ArabicDelegate extends AssetsPickerTextDelegate {
  @override
  String get confirm => 'تأكيد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get edit => 'تعديل';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get heicNotSupported => 'نوع HEIC غير مدعوم.';

  @override
  String get loadFailed => 'فشل التحميل';

  @override
  String get original => 'الأصل';

  @override
  String get preview => 'معاينة';

  @override
  String get select => 'تحديد';

  @override
  String get emptyList => 'القائمة فارغة';

  @override
  String get unSupportedAssetType => 'نوع HEIC غير مدعوم';

  @override
  String get unableToAccessAll =>
      'لا يمكن الوصول إلى جميع الملفات الموجودة على الجهاز';

  @override
  String get viewingLimitedAssetsTip =>
      'إظهار الملفات والألبومات التي يمكن للتطبيق الوصول إليها فقط.';

  @override
  String get changeAccessibleLimitedAssets => 'السماح بالوصول إلى ملفات إضافية';

  @override
  String get accessAllTip =>
      'يمكن للتطبيق الوصول فقط إلى بعض الملفات الموجودة على الجهاز. '
      'افتح إعدادات النظام واسمح للتطبيق بالوصول إلى جميع الملفات الموجودة على الجهاز.';

  @override
  String get goToSystemSettings => 'الذهاب إلى إعدادات النظام';

  @override
  String get accessLimitedAssets => 'تواصل مع وصول محدود';

  @override
  String get accessiblePathName => 'ملفات يمكن الوصول إليها';
}

class ImageUplaod {
  final api = locator<HttpApi>();
  Future<String> uploadSingleImage(BuildContext context,
      {Function(int sent, int total) onSendProgress}) async {
    final locale = AppLocalizations.of(context);
    final List<AssetEntity> assets = await AssetPicker.pickAssets(
      context,
      maxAssets: 1,
      requestType: WEPICKER.RequestType.image,
      themeColor: Theme.of(context).primaryColor,
      textDelegate: locale.locale.languageCode == 'en'
          ? EnglishTextDelegate()
          : ArabicDelegate(),
    );
    String fileId;

    if (assets.isNotEmpty) {
      File file = await assets.first.originFile;

      var res = await api.uploadFile(context,
          file: file, onSendProgress: onSendProgress);
      res.fold((err) => UI.toast(err.message.toString()),
          (data) => fileId = data['id']);
    }

    return fileId;
  }

  Future<Either<ServerError, dynamic>> uploadImageProfile(BuildContext context,
      {Function(int sent, int total) onSendProgress, File file}) async {
    return api.uploadFile(context, file: file, onSendProgress: onSendProgress);
  }
}
