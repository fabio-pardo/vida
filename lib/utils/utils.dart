import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<File> prepareImageFile(String fileLocation) async {
  // Load the image from the app bundle
  ByteData imageData = await rootBundle.load(fileLocation);

  // Convert the image data to a list of bytes
  List<int> bytes = imageData.buffer.asUint8List();

  // Create a reference to the app directory
  Directory appDocDir = await getApplicationDocumentsDirectory();

  // Create a reference to the file path
  String filePath = '${appDocDir.path}/chicken_parm.png';

  // Create a reference to the file
  File imageFile = File(filePath);

  // Write to the file
  await imageFile.writeAsBytes(bytes);

  return imageFile;
}
