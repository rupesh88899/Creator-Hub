import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Users
  CollectionReference get usersCollection => _firestore.collection('users');

  Future<void> createUser({
    required String uid,
    required String email,
    required String name,
    String photoUrl = '',
  }) {
    return usersCollection.doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getUser(String uid) {
    return usersCollection.doc(uid).get();
  }

  Stream<QuerySnapshot> getAllUsers() {
    return usersCollection.snapshots();
  }

  // Posts
  CollectionReference get postsCollection => _firestore.collection('posts');

  Future<DocumentReference> createPost(Map<String, dynamic> data) {
    return postsCollection.add(data);
  }

  Stream<QuerySnapshot> getPosts() {
    return postsCollection
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> likePost(String postId, String userId) {
    return postsCollection.doc(postId).update({
      'likes': FieldValue.arrayUnion([userId]),
      'likeCount': FieldValue.increment(1),
    });
  }

  Future<void> unlikePost(String postId, String userId) {
    return postsCollection.doc(postId).update({
      'likes': FieldValue.arrayRemove([userId]),
      'likeCount': FieldValue.increment(-1),
    });
  }

  // Chats
  CollectionReference get chatsCollection => _firestore.collection('chats');

  Future<DocumentReference> createChat(List<String> participants) {
    return chatsCollection.add({
      'participants': participants,
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getUserChats(String userId) {
    return chatsCollection
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  CollectionReference getMessages(String chatId) {
    return chatsCollection.doc(chatId).collection('messages');
  }

  Future<DocumentReference> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
  }) {
    return getMessages(chatId).add({
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'sent',
    }).then((docRef) {
      chatsCollection.doc(chatId).update({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
      return docRef;
    });
  }

  Stream<QuerySnapshot> getMessagesStream(String chatId) {
    return getMessages(chatId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Products
  CollectionReference get productsCollection =>
      _firestore.collection('products');

  Future<DocumentReference> createProduct(Map<String, dynamic> data) {
    return productsCollection.add(data);
  }

  Stream<QuerySnapshot> getProducts() {
    return productsCollection
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
