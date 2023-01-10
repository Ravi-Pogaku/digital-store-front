import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_material_pickers/helpers/show_number_picker.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/settings_BLoC.dart';

Future<int?> showSizePickerDialog(
    BuildContext context, List sizeSelection) async {
  return await showMaterialNumberPicker(
    headerColor: Colors.orange,
    headerTextColor: Colors.black,
    buttonTextColor:
        Provider.of<SettingsBLoC>(context, listen: false).isDarkMode
            ? Colors.white
            : Colors.black,
    maxLongSide: MediaQuery.of(context).size.height / 2,
    context: context,
    title: FlutterI18n.translate(context, "SizePickerDialog.size_picker"),
    maxNumber: sizeSelection.last,
    minNumber: sizeSelection.first,
    confirmText: FlutterI18n.translate(context, "SizePickerDialog.confirm"),
    cancelText: FlutterI18n.translate(context, "SizePickerDialog.cancel"),
  );
}
