import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:finney/pages/2-chatbot/models/chat_message_model.dart';
import 'package:flutter/material.dart';

class FirebaseChatStorageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user's chat messages collection reference
  CollectionReference get _chatMessagesCollection {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }
    return _firestore.collection('users').doc(user.uid).collection('chat_messages');
  }

  // Add a new chat message
  Future<void> saveMessage(ChatMessage message, {required String role}) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Convert to your chat message model
      final messageModel = ChatMessageModel.fromChatMessage(message, role: role);
      
      // Create map for Firestore
      Map<String, dynamic> messageData = {
        'text': messageModel.text,
        'userId': messageModel.userId,
        'userName': messageModel.userFirstName,
        'createdAt': messageModel.createdAt,
        'role': messageModel.role,
      };

      // Add medias field if there are any attachments
      if (message.medias != null && message.medias!.isNotEmpty) {
        messageData['mediaUrls'] = message.medias!.map((media) => media.url).toList();
      }

      // Add to Firebase
      await _chatMessagesCollection.add(messageData);
    } catch (e) {
      debugPrint('Error saving chat message: $e');
      rethrow;
    }
  }

  // Get all chat messages for the current user
  Stream<List<ChatMessage>> getMessages() {
    return _chatMessagesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        // Create ChatUser
        ChatUser user = ChatUser(
          id: data['userId'] ?? '',
          firstName: data['userName'] ?? 'User',
        );
        
        // Create ChatMessage
        return ChatMessage(
          text: data['text'] ?? '',
          user: user,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          customProperties: {'messageId': doc.id, 'role': data['role']},
        );
      }).toList();
    });
  }

  // Delete a specific chat message
  Future<void> deleteMessage(String messageId) async {
    try {
      await _chatMessagesCollection.doc(messageId).delete();
    } catch (e) {
      debugPrint('Error deleting chat message: $e');
      rethrow;
    }
  }

  // Delete all chat messages (clear chat history)
  Future<void> clearChat() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Get all documents in the collection
      QuerySnapshot snapshot = await _chatMessagesCollection.get();
      
      // Create a batch operation for efficiency
      WriteBatch batch = _firestore.batch();
      
      // Add delete operations to batch
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      // Commit the batch
      await batch.commit();
    } catch (e) {
      debugPrint('Error clearing chat messages: $e');
      rethrow;
    }
  }
}