import 'dart:io';

import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/core/services/photo_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';

class PrimaryChangeableImage extends StatelessWidget {
  const PrimaryChangeableImage({super.key, this.onImageChanged, this.imageFile, required this.labelText, this.imageUrl});

  final void Function(XFile)? onImageChanged;
  final String labelText;
  final File? imageFile;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(90),
      onTap: () async {
        final pickedFile = await PhotoPickerService.pickImage(
          ImageSource.gallery,
        );
        if (pickedFile != null) onImageChanged?.call(pickedFile);
      },
      child: Builder(
          builder: (context) {
            if (imageFile != null) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: Image.file(
                  File(imageFile!.path),
                  fit: BoxFit.cover,
                  width: 180,
                  height: 180,
                ),
              );
            }
            if (imageUrl != null) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  width: 180,
                  height: 180,
                ),
              );
            }
            return DottedBorder(
              padding: EdgeInsets.zero,
              borderType: BorderType.Circle,
              dashPattern: [6, 3],
              child: CircleAvatar(
                radius: 90,
                backgroundColor: Colors.transparent,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        Assets.icons.icCamera,
                        width: 40,
                        height: 40,
                      ),
                      Gap(Dimens.verticalSemiSmall),
                      Text(
                        labelText,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: FontSize.xSmall,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
