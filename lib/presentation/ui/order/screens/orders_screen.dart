import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/order/order_cubit.dart';
import 'package:catalogat_app/presentation/widgets/primary_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key, required this.orderCubit, required this.companyName, required this.representativeName});

  final String companyName;
  final OrderCubit orderCubit;
  final String representativeName;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  @override
  void initState() {
    super.initState();
    widget.orderCubit.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.orderCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PrimaryAppBar(
          title: context.l10n.title_orders_screen,
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: BlocBuilder<OrderCubit, OrderState>(
            buildWhen: (previous, current) {
              return previous.ordersResource != current.ordersResource;
            },
            builder: (context, state) {
              if (state.ordersResource.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final List<OrderEntity> orders = state.ordersResource.data ?? [];
              if (orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.icons.icProduct,
                        width: 100.w,
                        height: 100.w,
                      ),
                      Gap(Dimens.verticalXXLarge),
                      Text(context.l10n.empty_orders_list, style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: FontSize.medium)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.ordersResource.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final order = state.ordersResource.data![index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(Dimens.verticalXSmall),
                    margin: EdgeInsets.symmetric(
                        horizontal: Dimens.horizontalLarge,
                        vertical: Dimens.verticalSemiSmall),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.customerName,
                          style: TextStyle(
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(Dimens.verticalSemiSmall),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.l10n.created_at_value((order.createdAt ?? DateTime.now()).formattedDate),
                                style: TextStyle(
                                  fontSize: FontSize.xSmall,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text("${order.totalPrice.formatAsCurrency()} ${context.l10n.currency}",
                                style: TextStyle(
                                  fontSize: FontSize.xSmall,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ]
                        ),
                        Gap(Dimens.verticalSemiSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(),
                            InkWell(
                              onTap: () {
                                 widget.orderCubit.generateOrderReport(OrderPdfFileEntity(
                                     products: order.products,
                                     totalPrice: order.totalPrice,
                                     companyName: widget.companyName,
                                     customerName: order.customerName,
                                     representativeName: widget.representativeName,
                                     creationDate: order.createdAt?.formattedDate ?? "",
                                 ));
                              },
                              child: Row(
                                children: [
                                  Text(context.l10n.action_view_pdf,
                                    style: TextStyle(
                                      fontSize: FontSize.xSmall,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Gap(5.w),
                                  Icon(Icons.picture_as_pdf, color: Colors.red),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
