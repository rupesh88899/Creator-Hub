class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String userPhoto;
  final String text;
  final String? imageUrl;
  final List<String> likes;
  final int likeCount;
  final DateTime? createdAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhoto = '',
    required this.text,
    this.imageUrl,
    this.likes = const [],
    this.likeCount = 0,
    this.createdAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> map, String docId) {
    return PostModel(
      id: docId,
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String? ?? '',
      userPhoto: map['userPhoto'] as String? ?? '',
      text: map['text'] as String? ?? '',
      imageUrl: map['imageUrl'] as String?,
      likes: List<String>.from(map['likes'] as List? ?? []),
      likeCount: (map['likeCount'] as num? ?? 0).toInt(),
      createdAt: (map['createdAt'] as dynamic)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhoto': userPhoto,
      'text': text,
      'imageUrl': imageUrl,
      'likes': likes,
      'likeCount': likeCount,
    };
  }
}
