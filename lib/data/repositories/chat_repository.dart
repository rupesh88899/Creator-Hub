import 'dart:async';
import '../../core/services/firestore_service.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class ChatRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<List<UserModel>> getAllUsers(String currentUserId) {
    return _firestoreService.getAllUsers().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .where((user) => user.uid != currentUserId)
          .toList();
    });
  }

  Future<String> getOrCreateChat(String userId1, String userId2) async {
    final existingChats = await _firestoreService.chatsCollection
        .where('participants', arrayContains: userId1)
        .get();

    for (final doc in existingChats.docs) {
      final participants = List<String>.from(doc['participants'] as List);
      if (participants.contains(userId2)) {
        return doc.id;
      }
    }

    final docRef = await _firestoreService.createChat([userId1, userId2]);
    return docRef.id;
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestoreService.getMessagesStream(chatId).map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
  }) {
    return _firestoreService.sendMessage(
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
    );
  }
}
