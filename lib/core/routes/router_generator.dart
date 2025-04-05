import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/presentation/screens.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/presentation/ui/products/screens/brand_all_products.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppPaths.home:
        return MaterialPageRoute(builder: (_) => BrandsProductsScreen());
      case AppPaths.addBrand:
        return MaterialPageRoute(builder: (_) => AddBrandScreen(
          brandsCubit: (args as Map<String, dynamic>)[ArgumentsNames.brandsCubit] as BrandsCubit,
        ));
      case AppPaths.editBrand:
        return MaterialPageRoute(builder: (_) => EditBrandScreen(
          brand: (args as Map<String, dynamic>)[ArgumentsNames.brand] as BrandEntity,
          brandsCubit: (args)[ArgumentsNames.brandsCubit] as BrandsCubit,
        ));
      case AppPaths.editProduct:
        return MaterialPageRoute(builder: (_) => EditProductScreen(
          product: (args as Map<String, dynamic>)[ArgumentsNames.product] as ProductEntity,
          brandsCubit: (args)[ArgumentsNames.brandsCubit] as BrandsCubit,
        ));
      case AppPaths.addProduct:
        return MaterialPageRoute(
            builder: (_) => AddNewProductScreen(
              brandsCubit: (args as Map<String, dynamic>)[ArgumentsNames.brandsCubit] as BrandsCubit,
            )
        );
      case AppPaths.productsList:
        return MaterialPageRoute(
            builder: (_) => BrandAllProducts(
              brand: (args as Map<String, dynamic>)[ArgumentsNames.brand] as BrandEntity,
              brandsCubit: (args)[ArgumentsNames.brandsCubit] as BrandsCubit,
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