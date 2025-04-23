import 'dart:io';
import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/core/services/pdf_service.dart';
import 'package:catalogat_app/domain/entities/entities.dart';


class GenerateBrandProductsPdfFileUseCase {

  Future<Resource<File>> call(BrandEntity brand) async {
    final pdf = await PdfService.generateProductsPdf(brand);
    return Resource.success(
      pdf,
      message: globalKey.currentContext!.l10n.message_reportGenerated,
    );
  }
}