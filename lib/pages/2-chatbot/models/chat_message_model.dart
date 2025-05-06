import 'package:hive/hive.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

part 'chat_message_model.g.dart';

@HiveType(typeId: 1)  // Using typeId 1 since UserModel uses 0
class ChatMessageModel extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final String userFirstName;

  @HiveField(4)
  final String? mediaUrl;

  @HiveField(5)
  final String role;

  ChatMessageModel({
    required this.text,
    required this.createdAt,
    required this.userId,
    required this.userFirstName,
    required this.role,
    this.mediaUrl,
  });

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
    );
  }
}