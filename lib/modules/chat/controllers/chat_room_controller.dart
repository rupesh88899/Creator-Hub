import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/chat_repository.dart';

class ChatRoomController extends GetxController {
  final ChatRepository _chatRepository = ChatRepository();

  final messages = <MessageModel>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;

  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late final UserModel otherUser;
  String? chatId;

  final textController = TextEditingController();
  final scrollController = ScrollController();

  ChatRoomController({required this.otherUser});

  @override
  void onInit() {
    super.onInit();
    _initChat();
  }

  void _initChat() async {
    isLoading.value = true;
    chatId = await _chatRepository.getOrCreateChat(
      currentUserId,
      otherUser.uid,
    );
    _chatRepository.getMessages(chatId!).listen(
      (data) {
        messages.assignAll(data);
        isLoading.value = false;
        _scrollToBottom();
      },
      onError: (e) {
        isLoading.value = false;
      },
    );
  }

  Future<void> sendMessage() async {
    if (textController.text.trim().isEmpty) return;

    final text = textController.text.trim();
    textController.clear();

    isSending.value = true;

    final tempMsg = MessageModel(
      id: 'sending_${DateTime.now().millisecondsSinceEpoch}',
      senderId: currentUserId,
      receiverId: otherUser.uid,
      text: text,
      timestamp: DateTime.now(),
      status: 'sending',
    );
    messages.add(tempMsg);
    _scrollToBottom();

    await _chatRepository.sendMessage(
      chatId: chatId!,
      senderId: currentUserId,
      receiverId: otherUser.uid,
      text: text,
    );

    isSending.value = false;
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
