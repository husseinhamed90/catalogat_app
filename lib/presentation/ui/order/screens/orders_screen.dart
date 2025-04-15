import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/order/order_cubit.dart';
import 'package:catalogat_app/presentation/widgets/primary_app_bar.dart';
import 'package:catalogat_app/presentation/widgets/primary_floating_action_button.dart';
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
        floatingActionButton: BlocBuilder<OrderCubit, OrderState>(
          buildWhen: (previous, current) {
            if(previous.orderResource != current.orderResource) return true;
            if(previous.selectedOrders != current.selectedOrders) return true;
            if(previous.deleteMode != current.deleteMode) return true;
            if(previous.deleteSelectedOrdersResource != current.deleteSelectedOrdersResource) return true;
            return false;
          },
          builder: (context, state) {
            if(!state.deleteMode) return SizedBox.shrink();
            if(state.selectedOrders.isEmpty) return SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(bottom: Dimens.verticalLarge),
              child: PrimaryFloatingActionButton(
                padding: EdgeInsets.all(Dimens.horizontalMedium),
                onPressed: () async{
                  final deleteSelectedOrdersResource = await widget.orderCubit.deleteSelectedOrders();
                  if(!context.mounted) return;
                  if(deleteSelectedOrdersResource) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.message_orders_deleted_successfully),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.message_orders_deleted_successfully),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: Builder(
                    builder: (context) {
                      if(state.deleteSelectedOrdersResource.isLoading) {
                        return SizedBox.square(dimension: FontSize.large,child: CircularProgressIndicator());
                      }
                      return Icon(Icons.delete_rounded, size: Dimens.horizontalExtraLarge, color: Colors.white,);
                    }
                ),
              ),
            );
          },
        ),
        appBar: PrimaryAppBar(
          title: context.l10n.title_orders_screen,
          actions: [
            BlocBuilder<OrderCubit, OrderState>(
              buildWhen: (previous, current) {
                if(previous.selectedOrders != current.selectedOrders) return true;
                if(previous.deleteMode != current.deleteMode) return true;
                return false;
              },
              builder: (context, state) {
                if(state.deleteMode) {
                  return InkWell(
                    onTap: () {
                      widget.orderCubit.toggleDeleteMode();
                    },
                    child: Icon(Icons.clear,size: Dimens.horizontalExtraLarge,),
                  );
                }
                return InkWell(
                  onTap: () {
                    widget.orderCubit.toggleDeleteMode();
                  },
                  child: Icon(Icons.delete_rounded,size: Dimens.horizontalExtraLarge,),
                );
              },
            ),
            Gap(Dimens.horizontalMedium),
          ],
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
                    margin: EdgeInsets.only(
                      left: Dimens.horizontalLarge,
                      right: Dimens.horizontalLarge,
                      bottom: index == orders.length - 1 ? 90.h : 0,
                      top: Dimens.verticalSemiSmall,
                    ),
                    child: InkWell(
                      onTap:(){
                        widget.orderCubit.generateOrderReport(OrderPdfFileEntity(
                          products: order.products,
                          totalPrice: order.totalPrice,
                          companyName: widget.companyName,
                          customerName: order.customerName,
                          representativeName: widget.representativeName,
                          creationDate: order.createdAt?.formattedDate ?? "",
                        ));
                      },
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(order.customerName,
                                    style: TextStyle(
                                      fontSize: FontSize.medium,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Gap(Dimens.horizontalSmall),
                                BlocBuilder<OrderCubit, OrderState>(
                                  buildWhen: (previous, current) {
                                    if(previous.selectedOrders[orders[index].id] != current.selectedOrders[orders[index].id]) return true;
                                    if(previous.deleteMode != current.deleteMode) return true;
                                    return false;
                                  },
                                  builder: (context, state) {
                                    if(!state.deleteMode) return SizedBox.shrink();
                                    return Checkbox(
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // reduces default padding
                                      value: state.selectedOrders.containsKey(order.id) && state.selectedOrders[order.id] == true,
                                      onChanged: (bool? value) {
                                        widget.orderCubit.selectOrder(order);
                                      },
                                      checkColor: Colors.white, // color of the check mark (✓)
                                      activeColor: Colors.black, // background when checked
                                      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                                        if (states.contains(MaterialState.selected)) {
                                          return Colors.black; // checkbox background when selected
                                        }
                                        return Colors.white; // background when not selected
                                      }),
                                      side: const BorderSide(color: Colors.black, width: 2), // black border
                                    );
                                  },
                                ),
                              ],
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
                      ),
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
