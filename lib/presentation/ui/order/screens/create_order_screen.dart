import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _orderCubit = sl<OrderCubit>();
  }

  final TextEditingController _customerNameController = TextEditingController();
  final FocusNode _customerNameFocusNode = FocusNode();

  late OrderCubit _orderCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _orderCubit,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(30.h),
                  CompanyInfoWidget(),
                  Gap(Dimens.horizontalSmall),
                  BlocBuilder<OrderCubit,OrderState>(
                    buildWhen: (prevState, currentState) {
                      if (currentState.customersResource != prevState.customersResource) return true;
                      return false;
                    },
                    builder: (context, state) {
                      if (state.customersResource.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Expanded(
                        child: Column(
                          children: [
                            TabBar(
                              dividerColor: Color(0xffE5E7EB),
                              overlayColor: WidgetStateProperty.all(Colors.transparent),
                              labelPadding: EdgeInsets.symmetric(vertical: 4.w),
                              unselectedLabelStyle: TextStyle(
                                fontSize: FontSize.medium,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppConstants.fontFamilyName,
                              ),
                              unselectedLabelColor: Color(0xff6B7280),
                              labelColor: Colors.black,
                              indicatorColor: Colors.black,
                              labelStyle: TextStyle(
                                fontSize: FontSize.medium,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppConstants.fontFamilyName,
                              ),
                              tabs: [
                                Tab(text: context.l10n.tab_name_existingCustomer),
                                Tab(text: context.l10n.tab_name_newCustomer)
                              ],
                              controller: _tabController,
                              indicatorSize: TabBarIndicatorSize.tab,
                              onTap: (int index) {
                                print("tabIndex: $index");
                                _orderCubit.changeTabIndex(index);
                              },
                            ),
                            Gap(Dimens.horizontalSmall),
                            Expanded(
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.15,
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimens.horizontalMedium,
                                  vertical: Dimens.verticalLarge,
                                ),
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: _tabController,
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          BlocSelector(
                                            bloc: _orderCubit,
                                            selector: (OrderState state) => state.selectedCustomer,
                                            builder: (context, selectedCustomer) {
                                              return PrimaryDropDown<CustomerEntity>(
                                                items: state.customersResource.data ?? [],
                                                selectedItem: selectedCustomer,
                                                hintText: context.l10n.label_selectCustomer,
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    _orderCubit.selectCustomer(value);
                                                  }
                                                },
                                                validator: (value) => null,
                                                displayValue: (item) => item.name,
                                              );
                                            },
                                          ),
                                          Gap(Dimens.verticalXXLarge),
                                          ActionButtons(customerNameFocusNode: _customerNameFocusNode),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          BlocBuilder<OrderCubit, OrderState>(
                                            buildWhen: (prevState, currentState) {
                                              return currentState.customerName != prevState.customerName;
                                            },
                                            builder: (context, state) {
                                              return TextInputField(
                                                focusNode: _customerNameFocusNode,
                                                controller: _customerNameController,
                                                hint: context.l10n.label_enterCustomerName,
                                                onChanged: (value) {
                                                  _orderCubit.updateCustomerName(value);
                                                },
                                                validator: (value) => null,
                                              );
                                            },
                                          ),
                                          Gap(Dimens.verticalXXLarge),
                                          ActionButtons(customerNameFocusNode: _customerNameFocusNode)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    required FocusNode customerNameFocusNode,
  }) : _customerNameFocusNode = customerNameFocusNode;

  final FocusNode _customerNameFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.horizontalXSmall,),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: BlocBuilder<OrderCubit, OrderState>(
                buildWhen: (prevState, currentState) {
                  if (currentState.customerName != prevState.customerName) return true;
                  if (currentState.currentTabIndex != prevState.currentTabIndex) return true;
                  if (currentState.selectedCustomer != prevState.selectedCustomer) return true;
                  return false;
                },
                builder: (context, state) {
                  return PrimaryButton(
                    elevation: 0,
                    title: context.l10n.action_createOrder,
                    onPressed: () {
                      final tabIndex = state.currentTabIndex;
                      if (tabIndex == 0) {
                        if(state.selectedCustomer == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.l10n.error_selectCustomer),),
                          );
                          return;
                        }
                      } else {
                        if(state.customerName.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.l10n.error_enterCustomerName),),
                          );
                          return;
                        }
                      }
                      FocusScope.of(context).unfocus();
                      if (_customerNameFocusNode.hasFocus) _customerNameFocusNode.unfocus();
                      Navigator.pushNamed(context, Routes.brandsAndProducts);
                    },
                  );
                },
              ),
            ),
            Gap(Dimens.verticalXSmall),
            BlocBuilder<OrderCubit, OrderState>(
              buildWhen: (prevState, currentState) {
                if (currentState.customerName != prevState.customerName) return true;
                if (currentState.currentTabIndex != prevState.currentTabIndex) return true;
                if (currentState.selectedCustomer != prevState.selectedCustomer) return true;
                return false;
              },
              builder: (context, state) {
                final tabIndex = state.currentTabIndex;
                if (tabIndex == 1) return const SizedBox.shrink();
                if (tabIndex == 0 && state.selectedCustomer == null) return const SizedBox.shrink();
                return Container(
                  padding: EdgeInsets.only(
                    bottom: Dimens.verticalXSmall,
                  ),
                  width: double.infinity,
                  child: PrimaryButton(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    iconPath: Assets.icons.icDocument,
                    title: context.l10n.action_generateCustomerOrdersReport,
                    onPressed: () {
                      // Handle cancel action
                    },
                  ),
                );
              },
            ),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                elevation: 0,
                borderColor: Color(0xffF3F4F6),
                backgroundColor: Color(0xffF3F4F6),
                textColor: Color(0xff374151),
                title: context.l10n.action_viewAllOrders,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.orders);
                },
              ),
            ),
          ],
        )
    );
  }
}

class CompanyInfoWidget extends StatelessWidget {
  const CompanyInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.w),
            image: DecorationImage(
              image: NetworkImage(
                'http://res.cloudinary.com/dd7vqecuj/image/upload/v1744414028/mk3wexzkgtkx7sgjcihg.jpg',
              ),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Gap(Dimens.horizontalSmall),
        Text(
          context.l10n.label_companyName,
          style: TextStyle(
            fontSize: FontSize.extraLarge,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
