import 'package:image_picker/image_picker.dart';

class PhotoPickerService {
  static final ImagePicker picker = ImagePicker();

  static Future<XFile?> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 50,
    );
    return image;
  }
}