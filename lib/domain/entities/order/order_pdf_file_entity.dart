import 'package:catalogat_app/domain/entities/shopping/product_cart_item_entity.dart';

class OrderPdfFileEntity {
  final List<ProductCartItemEntity> products;
  final double totalPrice;
  final String companyName;
  final String customerName;
  final String representativeName;
  final String creationDate;


  const OrderPdfFileEntity({
    required this.products,
    required this.totalPrice,
    required this.companyName,
    required this.customerName,
    required this.creationDate,
    required this.representativeName,
  });
}