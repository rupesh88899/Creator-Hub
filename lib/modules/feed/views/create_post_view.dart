import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/string_constants.dart';
import '../../../data/repositories/post_repository.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final _textController = TextEditingController();
  final _postRepository = PostRepository();
  final _picker = ImagePicker();

  File? _imageFile;
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
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

  Future<void> _createPost() async {
    if (_textController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      await _postRepository.createPost(
        userId: user?.uid ?? '',
        userName: user?.displayName ?? user?.email?.split('@').first ?? 'User',
        userPhoto: user?.photoURL ?? '',
        text: _textController.text.trim(),
        imagePath: _imageFile?.path,
      );
      Get.back();
      Get.snackbar(
        'Success',
        'Post created!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        StringConstants.errorOccurred,
        'Failed to create post',
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
        title: const Text(StringConstants.createPost),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _createPost,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(StringConstants.post),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: StringConstants.whatOnMind,
                border: InputBorder.none,
              ),
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            if (_imageFile != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                child: Stack(
                  children: [
                    Image.file(
                      _imageFile!,
                      height: 200,
                      width: double.infinity,
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
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => setState(() => _imageFile = null),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text(StringConstants.addImage),
            ),
          ],
        ),
      ),
    );
  }
}
