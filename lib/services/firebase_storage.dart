import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImageToFirebaseStorage(
    File imageFile, String fileName) async {
  // Create a reference to the location you want to upload to in firebase
  Reference storageReference = FirebaseStorage.instance.ref().child(fileName);

  // Upload the file to the specified location
  UploadTask uploadTask = storageReference.putFile(imageFile);

  // Waits for the upload to complete
  TaskSnapshot taskSnapshot = await uploadTask;

  // Get the download URL
  String downloadUrl = await taskSnapshot.ref.getDownloadURL();

  return downloadUrl;
}
