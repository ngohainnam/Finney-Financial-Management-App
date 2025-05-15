import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../network/connectivity_service.dart';

// The cloud service implementation
class ChatCloudService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'chatMessages';
  
  // Constructor with no unused parameters
  ChatCloudService();
  
  // Get user-specific collection reference
  CollectionReference get _chatMessagesCollection {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }
    return _firestore.collection('users').doc(user.uid).collection(_collection);
  }
  
  // Get all chat messages as DashChat messages
  Future<List<ChatMessage>> getAllMessages() async {
    try {
      final snapshot = await _chatMessagesCollection
          .orderBy('createdAt', descending: true)
          .get();
      
      return _convertSnapshotToChatMessages(snapshot);
    } catch (e) {
      debugPrint('Error getting chat messages: $e');
      return [];
    }
  }
  
  // Stream chat messages for real-time updates
  Stream<List<ChatMessage>> streamMessages() {
    try {
      return _chatMessagesCollection
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(_convertSnapshotToChatMessages);
    } catch (e) {
      debugPrint('Error streaming chat messages: $e');
      return Stream.value([]);
    }
  }
  
  // Convert to Gemini content format for LLM context
  List<Content> toGeminiContent(List<ChatMessage> messages) {
    return messages.map((message) => Content(
      parts: [Part.text(message.text)],
      role: message.customProperties?['role'] as String? ?? 'user',
    )).toList();
  }
  
  // Save a new message
  Future<void> saveMessage(ChatMessage message, {required String role}) async {
    try {
      // Create map for Firestore
      Map<String, dynamic> messageData = {
        'text': message.text,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': message.user.id,
        'userFirstName': message.user.firstName ?? 'User',
        'role': role,
      };

      // Add media if available
      if (message.medias != null && message.medias!.isNotEmpty) {
        messageData['mediaUrl'] = message.medias!.first.url;
      }

      // Add to Firestore
      await _chatMessagesCollection.add(messageData);
    } catch (e) {
      debugPrint('Error saving chat message: $e');
      rethrow;
    }
  }
  
  // Delete a message
  Future<void> deleteMessage(String messageId) async {
    try {
      await _chatMessagesCollection.doc(messageId).delete();
    } catch (e) {
      debugPrint('Error deleting message: $e');
      rethrow;
    }
  }
  
  // Clear all messages
  Future<void> clearChat() async {
    try {
      // Get all documents in the collection
      QuerySnapshot snapshot = await _chatMessagesCollection.get();
      
      // Create batch operation for efficiency
      WriteBatch batch = _firestore.batch();
      
      // Add delete operations to batch
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      // Commit the batch
      await batch.commit();
    } catch (e) {
      debugPrint('Error clearing messages: $e');
      rethrow;
    }
  }
  
  // Helper method to convert Firestore QuerySnapshot to ChatMessage list
  List<ChatMessage> _convertSnapshotToChatMessages(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      
      // Handle Timestamp vs. String
      DateTime createdAt;
      if (data['createdAt'] is Timestamp) {
        createdAt = (data['createdAt'] as Timestamp).toDate();
      } else if (data['createdAt'] is String) {
        createdAt = DateTime.parse(data['createdAt']);
      } else {
        createdAt = DateTime.now();
      }
      
      // Create chat media if available
      List<ChatMedia>? chatMedias;
      if (data['mediaUrl'] != null) {
        chatMedias = [
          ChatMedia(
            url: data['mediaUrl'],
            fileName: 'media',
            type: MediaType.image,
          )
        ];
      }
      
      return ChatMessage(
        text: data['text'] ?? '',
        user: ChatUser(
          id: data['userId'] ?? '',
          firstName: data['userFirstName'] ?? 'User',
        ),
        createdAt: createdAt,
        medias: chatMedias,
        customProperties: {'messageId': doc.id, 'role': data['role'] ?? 'user'},
      );
    }).toList();
  }
}

// The service class that will be used by the UI
class ChatService {
  final ChatCloudService _cloudService;
  final ConnectivityService _connectivityService;
  
  ChatService({
    required ChatCloudService cloudService,
    required ConnectivityService connectivityService,
  }) : 
    _cloudService = cloudService,
    _connectivityService = connectivityService;

  // Get all messages directly as dash_chat format
  Future<List<ChatMessage>> getAllMessages() async {
    if (!_connectivityService.isConnected) {
      return []; // Return empty list when offline
    }
    
    try {
      return await _cloudService.getAllMessages();
    } catch (e) {
      debugPrint('Error getting messages: $e');
      return [];
    }
  }
  
  // Stream messages with real-time updates
  Stream<List<ChatMessage>> streamMessages() {
    if (!_connectivityService.isConnected) {
      return Stream.value([]); // Return empty stream when offline
    }
    
    return _cloudService.streamMessages();
  }
  
  // Convert to Gemini content format for LLM
  List<Content> toGeminiContent(List<ChatMessage> messages) {
    return _cloudService.toGeminiContent(messages);
  }
  
  // Save a new message
  Future<void> saveMessage(ChatMessage message, {required String role}) async {
    if (!_connectivityService.isConnected) {
      // Show error or notification that message couldn't be sent
      debugPrint('Cannot save message: No internet connection');
      return;
    }
    
    try {
      await _cloudService.saveMessage(message, role: role);
    } catch (e) {
      debugPrint('Error saving chat message: $e');
      // Handle error - show notification to user
    }
  }
  
  // Delete a message
  Future<void> deleteMessage(String messageId) async {
    if (!_connectivityService.isConnected) {
      // Show error or notification
      debugPrint('Cannot delete message: No internet connection');
      return;
    }
    
    try {
      await _cloudService.deleteMessage(messageId);
    } catch (e) {
      debugPrint('Error deleting message: $e');
    }
  }
  
  // Clear all messages
  Future<void> clearChat() async {
    if (!_connectivityService.isConnected) {
      // Show error or notification
      debugPrint('Cannot clear messages: No internet connection');
      return;
    }
    
    try {
      await _cloudService.clearChat();
    } catch (e) {
      debugPrint('Error clearing messages: $e');
    }
  }
}