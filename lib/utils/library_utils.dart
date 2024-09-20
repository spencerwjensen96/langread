import 'dart:io';
import 'package:file_picker/file_picker.dart';

Future<File> importFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowedExtensions: ['.pdf', '.epub'],
    type: FileType.custom,
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    return file;
  } else {
    throw Exception('User canceled the picker');
  }
}