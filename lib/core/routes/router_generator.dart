import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/presentation/screens.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => BrandsProductsScreen());
      case Routes.brandsAndProducts:
        return MaterialPageRoute(builder: (_) => BrandsProductsScreen());
      case Routes.addBrand:
        return MaterialPageRoute(builder: (_) => AddBrandScreen(
          brandsCubit: (args as Map<String, dynamic>)[ArgumentsNames.brandsCubit] as BrandsCubit,
        ));
      case Routes.editBrand:
        return MaterialPageRoute(builder: (_) => EditBrandScreen(
          brand: (args as Map<String, dynamic>)[ArgumentsNames.brand] as BrandEntity,
          brandsCubit: (args)[ArgumentsNames.brandsCubit] as BrandsCubit,
        ));
      case Routes.editProduct:
        return MaterialPageRoute(builder: (_) => EditProductScreen(
          product: (args as Map<String, dynamic>)[ArgumentsNames.product] as ProductEntity,
          brandsCubit: (args)[ArgumentsNames.brandsCubit] as BrandsCubit,
        ));
      case Routes.addProduct:
        return MaterialPageRoute(
            builder: (_) => AddNewProductScreen(
              brandsCubit: (args as Map<String, dynamic>)[ArgumentsNames.brandsCubit] as BrandsCubit,
            )
        );
      case Routes.productsList:
        return MaterialPageRoute(
            builder: (_) => BrandAllProducts(
              brand: (args as Map<String, dynamic>)[ArgumentsNames.brand] as BrandEntity,
              brandsCubit: (args)[ArgumentsNames.brandsCubit] as BrandsCubit,
              orderCubit: (args)[ArgumentsNames.orderCubit] as OrderCubit,
            )
        );
      case Routes.shopping:
        return MaterialPageRoute(
            builder: (_) => ShoppingScreen(
              product: (args as Map<String, dynamic>)[ArgumentsNames.product] as ProductEntity,
              productCartItem: (args)[ArgumentsNames.productCartItemEntity] as ProductCartItemEntity ? ?? ProductCartItemEntity(),
            )
        );
      case Routes.orders:
        return MaterialPageRoute(
            builder: (_) => OrdersScreen(
              orderCubit: (args as Map<String, dynamic>)[ArgumentsNames.orderCubit] as OrderCubit,
              companyName: (args)[ArgumentsNames.companyName] as String,
              representativeName: (args)[ArgumentsNames.representativeName] as String,
            )
        );
      case Routes.editCompanyInfo:
        return MaterialPageRoute(
            builder: (_) => EditCompanyScreen(
              companyCubit: (args as Map<String, dynamic>)[ArgumentsNames.companyCubit] as CompanyCubit,
            )
        );
      case Routes.addNewCustomer:
        return MaterialPageRoute(
            builder: (_) => AddNewCustomerScreen(
              customersCubit: (args as Map<String, dynamic>)[ArgumentsNames.customersCubit] as CustomersCubit,
            )
        );
      case Routes.customers:
        return MaterialPageRoute(
            builder: (_) => CustomersScreen(
              customerCubit: (args as Map<String, dynamic>)[ArgumentsNames.customersCubit] as CustomersCubit,
            )
        );
      default:
        return _errorRoute();
    }
  }
}

/// Error Route
Route<dynamic> _errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Text('ERROR'),
      ),
    );
  });
}