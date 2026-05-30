import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/string_constants.dart';
import '../../../data/repositories/product_repository.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _productRepository = ProductRepository();
  final _picker = ImagePicker();

  File? _imageFile;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _addProduct() async {
    if (_titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a product title',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (_priceController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a price',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (_imageFile == null) {
      Get.snackbar(
        'Error',
        'Please select a product image',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final price = double.tryParse(_priceController.text.trim());
    if (price == null || price <= 0) {
      Get.snackbar(
        'Error',
        'Please enter a valid price',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      await _productRepository.createProduct(
        userId: user?.uid ?? '',
        title: _titleController.text.trim(),
        price: price,
        imagePath: _imageFile!.path,
        description: _descriptionController.text.trim(),
      );
      Get.back();
      Get.snackbar(
        'Success',
        'Product added!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        StringConstants.errorOccurred,
        'Failed to add product',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.addProduct),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _addProduct,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(StringConstants.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: StringConstants.productTitle,
                hintText: 'Enter product name',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: StringConstants.productPrice,
                hintText: '0.00',
                prefixText: '₹ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: StringConstants.productDescription,
                hintText: 'Describe your product',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppConstants.cardRadius),
                        child: Stack(
                          children: [
                            Image.file(
                              _imageFile!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: CircleAvatar(
                                backgroundColor: Colors.black54,
                                radius: 16,
                                child: IconButton(
                                  iconSize: 16,
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onPressed: () =>
                                      setState(() => _imageFile = null),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            StringConstants.productImage,
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
