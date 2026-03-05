part of 'products_cubit.dart';

enum ProductsStatus { initial, loading, success, failure }

class ProductsState extends Equatable {
  const ProductsState({
    required this.status,
    required this.products,
    required this.filteredProducts,
    required this.search,
    required this.errorMessage,
  });

  const ProductsState.initial()
      : this(
          status: ProductsStatus.initial,
          products: const [],
          filteredProducts: const [],
          search: '',
          errorMessage: '',
        );

  final ProductsStatus status;
  final List<Product> products;
  final List<Product> filteredProducts;
  final String search;
  final String errorMessage;

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? products,
    List<Product>? filteredProducts,
    String? search,
    String? errorMessage,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      search: search ?? this.search,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        filteredProducts,
        search,
        errorMessage,
      ];
}

