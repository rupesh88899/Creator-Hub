class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime? timestamp;
  final String status;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    this.timestamp,
    this.status = 'sent',
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return MessageModel(
      id: docId,
      senderId: map['senderId'] as String? ?? '',
      receiverId: map['receiverId'] as String? ?? '',
      text: map['text'] as String? ?? '',
      timestamp: (map['timestamp'] as dynamic)?.toDate(),
      status: map['status'] as String? ?? 'sent',
    );
  }

  bool get isSent => status == 'sent';
  bool get isDelivered => status == 'delivered';
  bool get isRead => status == 'read';
}
