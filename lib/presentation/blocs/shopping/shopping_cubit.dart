import 'dart:io';

import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';

part 'shopping_state.dart';

class ShoppingCubit extends Cubit<ShoppingState> {
  ShoppingCubit() : super(ShoppingState());

  void increaseQuantity() => emit(state.copyWith(quantity: state.quantity + 1,));

  void decreaseQuantity() {
    if (state.quantity > 0) {
      emit(state.copyWith(quantity: state.quantity - 1,));
    }
  }

  double getTotalPrice(double productPrice) => productPrice * state.quantity;

  void setQuantity(int quantity) {
    if (quantity >= 0) {
      emit(state.copyWith(quantity: quantity));
    }
  }
}
