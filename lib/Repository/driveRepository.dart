import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';

class DriveRepository {
  // Service account JSON as a string
  final String serviceAccountKey;

  DriveRepository(this.serviceAccountKey);

  /// Authenticate using the Service Account
  Future<drive.DriveApi> authenticateServiceAccount() async {
    // Parse the service account JSON string into a map
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(
      jsonDecode(serviceAccountKey),
    );

    // Authenticate and create a client
    final authClient = await clientViaServiceAccount(
      serviceAccountCredentials,
      [drive.DriveApi.driveFileScope],
    );

    if (kDebugMode) {
      print('Service account authenticated successfully');
    }

    return drive.DriveApi(authClient);
  }

  /// Check if the folder exists, or create it if it doesn't
  Future<String> getOrCreateFolder(drive.DriveApi api) async {
    const folderName = "ProfileImages";

    // Search for folder
    final folderSearch = await api.files.list(
      q: "mimeType='application/vnd.google-apps.folder' and name='$folderName'",
      spaces: 'drive',
    );

    if (folderSearch.files!.isNotEmpty) {
      if (kDebugMode) {
        print('Folder "$folderName" found.');
      }
      return folderSearch.files!.first.id!;
    }

    // Create folder if not found
    final folderMetadata = drive.File()
      ..name = folderName
      ..mimeType = 'application/vnd.google-apps.folder';

    final folder = await api.files.create(folderMetadata);
    if (kDebugMode) {
      print('Folder "$folderName" created successfully.');
    }
    return folder.id!;
  }

  /// Upload an image file to the specified folder
  Future<String> uploadImageToFolder(
    drive.DriveApi api,
    String folderId,
    File imageFile,
    String name,
  ) async {
    // Ensure the name has a .jpg extension
    final fileName = name.endsWith('.jpg') ? name : '$name.jpg';

    final fileToUpload = drive.File()
      ..name = fileName
      ..parents = [folderId];

    final media = drive.Media(
      imageFile.openRead(),
      imageFile.lengthSync(),
    );

    // Upload the file to Google Drive
    final uploadedFile = await api.files.create(
      fileToUpload,
      uploadMedia: media,
      $fields: 'id,webViewLink', // Request the file ID and link
    );

    // Set file permissions to be publicly accessible
    final permission = drive.Permission()
      ..type = 'anyone'
      ..role = 'reader';
    await api.permissions.create(permission, uploadedFile.id!);

    if (kDebugMode) {
      print('File "$fileName" uploaded successfully.');
      print('File URL: ${uploadedFile.webViewLink}');
    }

    // Return the URL of the uploaded file
    return "https://drive.google.com/uc?export=view&id=${uploadedFile.id}";
  }

  /// Get an image by name from the specified folder
  Future<String?> getImage(
    drive.DriveApi api,
    String folderId,
    String name,
  ) async {
    name = "a@a.com.jpg";
    // Ensure the name has a .jpg extension
    final fileName = name.endsWith('.jpg') ? name : '$name.jpg';

    // Search for the file in the folder
    final fileSearch = await api.files.list(
      q: "'$folderId' in parents and name='$fileName'",
      spaces: 'drive',
      $fields: 'files(id, name, webViewLink)',
    );

    if (fileSearch.files!.isNotEmpty) {
      final file = fileSearch.files!.first;
      if (kDebugMode) {
        print('File "$fileName" found with URL: ${file.webViewLink}');
      }
      return "https://drive.google.com/uc?export=view&id=${file.id}";
    } else {
      if (kDebugMode) {
        print('File "$fileName" not found in the folder.');
      }
      return null;
    }
  }
}
