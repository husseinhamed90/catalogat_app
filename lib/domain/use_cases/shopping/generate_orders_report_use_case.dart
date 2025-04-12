import 'dart:io';
import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/core/services/pdf_service.dart';
import 'package:catalogat_app/domain/use_cases/use_cases.dart';


class GenerateOrdersReportUseCase {

  final FetchOrdersUseCase _fetchOrdersUseCase;

  GenerateOrdersReportUseCase(this._fetchOrdersUseCase);

  Future<Resource<File>> call() async {
    final result = await _fetchOrdersUseCase();
    if(result.isSuccess){
      final orders = result.data ?? [];
      if(orders.isEmpty){
        return Resource.failure(globalKey.currentContext!.l10n.message_noOrders);
      }
      final pdf = await PdfService.generateOrdersPdf(orders);
      return Resource.success(
        pdf,
        message: globalKey.currentContext!.l10n.message_reportGenerated,
      );
    }
    return Resource.failure(result.message ?? "Error generating report");
  }
}