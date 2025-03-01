import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/home/views/bloc/product_display_cubit.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/home/views/bloc/product_display_state.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/home/views/widgets/product_card.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/product/domain/entities/product.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/product/domain/usecase/get_doctor_choice_usecase.dart';
import 'package:shop_bacsi_nguyentrongthuy/core/di/service_locator.dart';

class DoctorChoice extends StatelessWidget {
  const DoctorChoice({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductDisplayCubit(useCase: serviceLocator<GetDoctorChoiceUseCase>())
            ..displayProducts(),
      child: BlocBuilder<ProductDisplayCubit, ProductDisplayState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ProductLoaded) {
            return _products(state.products);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _products(List<ProductEntity> products) {
    return SizedBox(
      height: 300.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: 40.w,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(productEntity: products[index]);
        },
      ),
    );
  }
}
