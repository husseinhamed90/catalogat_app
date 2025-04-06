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
    return Container(
      width: 160,
      padding: const EdgeInsets.all(Dimens.medium),
      child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(widget.item.imageUrl ?? "",fit: BoxFit.cover,)
                    ),
                  ),
                ),
                Gap(10),
                //Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.item.name ?? "", style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: FontSize.xSmall)),
                    Gap(5),
                    Text((widget.item.price1 ?? 0.0).toString(), style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w600, fontSize: FontSize.medium)),
                  ],
                ),
              ],
            ),
            Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(0xffF3F4F6),
                  child: PopupMenuButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.more_vert_outlined, color: AppColors.textColor, size: 17),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text("Edit", style: TextStyle(color: AppColors.textColor)),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text("Delete", style: TextStyle(color: AppColors.textColor)),
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
                        if(deletedSuccess) {
                          ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("Product deleted successfully"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                        else{
                          ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Failed to delete product"),
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
    );
  }
}