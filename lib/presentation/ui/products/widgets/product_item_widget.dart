import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';

class ProductItemWidget extends StatefulWidget {
  final ProductEntity item;

  const ProductItemWidget({super.key, required this.item});

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: SizedBox(
        width: 190,
        child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                        child: Builder(
                          builder: (context) {
                            if(widget.item.imageUrl == null || widget.item.imageUrl!.isEmpty) {
                              return Image.asset(Assets.images.imgPlaceholder.path, fit: BoxFit.cover);
                            }
                            return Image.network(widget.item.imageUrl ?? "",fit: BoxFit.cover,);
                          }
                        )
                    ),
                  ),
                  Gap(8),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  widget.item.name ?? "",
                                  style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: FontSize.xSmall)
                              ),
                            ),
                          ),
                          Gap(5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: FittedBox(
                              child: Text(
                                  maxLines: 1,
                                  context.l10n.price_1_value((widget.item.price1 ?? 0.0).formatAsCurrency())
                              )
                            ),
                          ),
                          Gap(5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: FittedBox(
                              child: Text(
                                  maxLines: 1,
                                  context.l10n.price_2_value((widget.item.price2 ?? 0.0).formatAsCurrency())
                              )
                            ),
                          ),
                          Gap(15),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              PositionedDirectional(
                  top: 8,
                  end: 8,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xffF3F4F6),
                    child: PopupMenuButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.more_vert_outlined, color: AppColors.textColor, size: 17),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Text(context.l10n.action_edit, style: TextStyle(color: AppColors.textColor)),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Text(context.l10n.action_delete, style: TextStyle(color: AppColors.textColor)),
                        ),
                      ],
                      onSelected: (value) async {
                        if(value == 1) {
                          Navigator.pushNamed(context, Routes.editProduct, arguments: {
                            ArgumentsNames.product: widget.item,
                            ArgumentsNames.brandsCubit: context.read<BrandsCubit>(),
                          });
                        } else if(value == 2) {
                          final deletedSuccess = await context.read<BrandsCubit>().deleteProduct(productId: widget.item.id ?? "", currentBrandId: widget.item.brandId ?? "");
                          if(deletedSuccess.$1) {
                            ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(deletedSuccess.$2 ?? "Product deleted successfully"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                          else{
                            ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(deletedSuccess.$2 ?? "Failed to delete product"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  )
              ),
            ]),
      ),
    );
  }
}