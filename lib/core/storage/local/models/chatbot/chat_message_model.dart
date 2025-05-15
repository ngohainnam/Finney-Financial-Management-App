import 'package:dash_chat_2/dash_chat_2.dart';

class ChatMessageModel {
  final String text;
  final DateTime createdAt;
  final String userId;
  final String userFirstName;
  final String? mediaUrl;
  final String role;

  ChatMessageModel({
    required this.text,
    required this.createdAt,
    required this.userId,
    required this.userFirstName,
    required this.role,
    this.mediaUrl,
  });

  // Create from a Firebase document
  factory ChatMessageModel.fromMap(Map<String, dynamic> data) {
    DateTime createdAt;
    if (data['createdAt'] is DateTime) {
      createdAt = data['createdAt'] as DateTime;
    } else if (data['createdAt']?.toDate != null) {
      createdAt = data['createdAt'].toDate();
    } else if (data['createdAt'] is String) {
      createdAt = DateTime.parse(data['createdAt']);
    } else {
      createdAt = DateTime.now();
    }
    
    return ChatMessageModel(
      text: data['text'] ?? '',
      createdAt: createdAt,
      userId: data['userId'] ?? '',
      userFirstName: data['userFirstName'] ?? '',
      role: data['role'] ?? 'user',
      mediaUrl: data['mediaUrl'],
    );
  }

  // Convert to a map for Firebase storage
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'createdAt': createdAt,
      'userId': userId,
      'userFirstName': userFirstName,
      'role': role,
      if (mediaUrl != null) 'mediaUrl': mediaUrl,
    };
  }

  // Create from a dash_chat ChatMessage
  factory ChatMessageModel.fromChatMessage(ChatMessage message, {required String role}) {
    return ChatMessageModel(
      text: message.text,
      createdAt: message.createdAt,
      userId: message.user.id,
      userFirstName: message.user.firstName ?? '',
      role: role,
      mediaUrl: message.medias?.firstOrNull?.url,
    );
  }

  // Convert to a dash_chat ChatMessage
  ChatMessage toChatMessage() {
    return ChatMessage(
      text: text,
      createdAt: createdAt,
      user: ChatUser(
        id: userId,
        firstName: userFirstName,
      ),
      medias: mediaUrl != null 
          ? [ChatMedia(url: mediaUrl!, fileName: '', type: MediaType.image)]
          : null,
      customProperties: {'role': role},
    );
  }
}