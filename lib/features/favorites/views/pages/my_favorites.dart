import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/home/views/bloc/product_display_cubit.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/home/views/bloc/product_display_state.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/product/domain/entities/product.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/product/domain/usecase/get_favorite_products_usecase.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/search/views/widgets/product_card.dart';
import 'package:shop_bacsi_nguyentrongthuy/service_locator.dart';

class MyFavoritesPage extends StatelessWidget {
  const MyFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDisplayCubit(
          useCase: serviceLocator<GetFavoriteProductsUseCase>())
        ..displayProducts(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFF0F1F2),
              elevation: 0,
            ),
            body: BlocBuilder<ProductDisplayCubit, ProductDisplayState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ProductLoaded) {
                  return Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF0F1F2),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 5,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'SẢN PHẨM YÊU THÍCH CỦA BẠN',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: _products(state.products)),
                    ],
                  );
                }
                return Container(
                  color: const Color(0xFFF0F1F2),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _products(List<ProductEntity> products) {
    return Container(
      color: const Color(0xFFF0F1F2),
      child: GridView.builder(
        itemCount: products.length,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (BuildContext context, int index) {
          return ProductCard(productEntity: products[index]);
        },
      ),
    );
  }
}