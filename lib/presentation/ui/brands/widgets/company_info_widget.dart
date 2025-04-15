import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompanyInfoWidget extends StatelessWidget {
  const CompanyInfoWidget({super.key, required this.companyCubit, required this.orderCubit});

  final CompanyCubit companyCubit;
  final OrderCubit orderCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: companyCubit),
        BlocProvider.value(value: orderCubit),
      ],
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(
          vertical: Dimens.verticalSemiSmall,
          horizontal: Dimens.horizontalLarge,
        ),
        child: Row(
          children: [
            BlocBuilder<CompanyCubit, CompanyState>(
              buildWhen: (state, previous) {
                return state.company?.logoUrl != previous.company?.logoUrl;
              },
              builder: (context, state) {
                if(state.company?.logoUrl.isEmpty ?? true) {
                  return Image.asset(
                    Assets.images.imgPlaceholder.path,
                    width: 60.w,
                    height: 60.w,
                    fit: BoxFit.contain,
                  );
                }
                return Image.network(
                  state.company?.logoUrl ?? "",
                  width: 100.w,
                  height: 60.w,
                  fit: BoxFit.contain,
                );
              },
            ),
            Gap(Dimens.horizontalMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<CompanyCubit,CompanyState>(
                    bloc: companyCubit,
                    buildWhen: (state, previous) {
                      return state.company?.name != previous.company?.name;
                    },
                    builder: (context, state) {
                      final companyName = state.company?.name ?? context.l10n.label_companyName;
                      return AutoSizeText(
                        companyName,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                  Gap(4.h),
                  BlocBuilder<OrderCubit, OrderState>(
                    buildWhen: (state, previous) {
                      if(state.totalPrice != previous.totalPrice) return true;
                      if(state.cartProducts != previous.cartProducts) return true;
                      return false;
                    },
                    builder: (context, state) {
                      if(state.totalPrice == 0) return SizedBox.shrink();
                      final orderValue = state.totalPrice;
                      return AutoSizeText(
                        "${orderValue.formatAsCurrency()} ${context.l10n.currency}",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
