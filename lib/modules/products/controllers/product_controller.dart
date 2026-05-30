import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/string_constants.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository _productRepository = ProductRepository();

  final products = <ProductModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() {
    isLoading.value = true;
    _productRepository.getProducts().listen(
      (data) {
        products.assignAll(data);
        isLoading.value = false;
      },
      onError: (e) {
        isLoading.value = false;
        Get.snackbar(
          StringConstants.errorOccurred,
          'Failed to load products',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  void mockBuyNow(ProductModel product) {
    Get.dialog(
      AlertDialog(
        title: const Text(StringConstants.buyNow),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product: ${product.title}'),
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text(StringConstants.purchaseMock),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(StringConstants.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Success',
                StringConstants.purchaseSuccess,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text(StringConstants.confirm),
          ),
        ],
      ),
    );
  }
}
