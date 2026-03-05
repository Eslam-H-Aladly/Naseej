import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/products_repository.dart';
import '../../domain/entities/product.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit({
    ProductsRepository? repository,
  })  : _repository = repository ?? MockProductsRepository(),
        super(const ProductsState.initial());

  final ProductsRepository _repository;

  Future<void> loadMockProducts() async {
    emit(state.copyWith(status: ProductsStatus.loading));
    try {
      final products = await _repository.fetchVendorProducts();
      emit(
        state.copyWith(
          status: ProductsStatus.success,
          products: products,
          filteredProducts: products,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void search(String value) {
    final query = value.toLowerCase();
    final filtered = state.products.where((product) {
      return product.name.contains(value) ||
          product.nameEn.toLowerCase().contains(query);
    }).toList();

    emit(state.copyWith(search: value, filteredProducts: filtered));
  }
}

