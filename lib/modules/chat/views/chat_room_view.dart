import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/string_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/user_model.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../controllers/chat_room_controller.dart';

class ChatRoomView extends StatelessWidget {
  final UserModel otherUser;

  ChatRoomView({super.key, required this.otherUser}) {
    Get.put(ChatRoomController(otherUser: otherUser));
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatRoomController>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: otherUser.photoUrl.isNotEmpty
                  ? NetworkImage(otherUser.photoUrl)
                  : null,
              child: otherUser.photoUrl.isEmpty
                  ? Text(
                      otherUser.name.isNotEmpty
                          ? otherUser.name[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              otherUser.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.messages.isEmpty) {
          return const LoadingWidget();
        }
        return Column(
          children: [
            Expanded(
              child: controller.messages.isEmpty
                  ? const EmptyStateWidget(
                      message: StringConstants.noMessages,
                      icon: Icons.chat_bubble_outline,
                    )
                  : ListView.builder(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final message = controller.messages[index];
                        final isMe = message.senderId == controller.currentUserId;
                        return _MessageBubble(
                          message: message,
                          isMe: isMe,
                        );
                      },
                    ),
            ),
            _ChatInput(controller: controller),
          ],
        );
      }),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const _MessageBubble({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final isSending = message.status == 'sending';

    return Padding(
      padding: EdgeInsets.only(
        left: isMe ? 48 : 0,
        right: isMe ? 0 : 48,
        bottom: 4,
      ),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isMe ? AppTheme.primaryColor : Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: isMe
                  ? const Radius.circular(18)
                  : const Radius.circular(4),
              bottomRight: isMe
                  ? const Radius.circular(4)
                  : const Radius.circular(18),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Helpers.formatMessageTime(message.timestamp),
                    style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    isSending
                        ? SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: Colors.white70,
                            ),
                          )
                        : Icon(
                            message.isRead
                                ? Icons.done_all
                                : message.isDelivered
                                    ? Icons.done_all
                                    : Icons.done,
                            size: 14,
                            color: message.isRead
                                ? Colors.blue[300]
                                : Colors.white70,
                          ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  final ChatRoomController controller;

  const _ChatInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.textController,
                decoration: InputDecoration(
                  hintText: StringConstants.typeMessage,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            Obx(() => CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  radius: 22,
                  child: controller.isSending.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send, color: Colors.white, size: 18),
                          onPressed: () => controller.sendMessage(),
                        ),
                )),
          ],
        ),
      ),
    );
  }
}
