import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/core/storage/cloud/models/chat_message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:finney/core/network/connectivity_service.dart';

class ChatCloudService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ConnectivityService _connectivityService;
  
  // Constructor that accepts connectivity service
  ChatCloudService({
    required ConnectivityService connectivityService,
  }) : _connectivityService = connectivityService;
  
  // Check internet connectivity
  Future<void> _checkConnectivity() async {
    if (!_connectivityService.isConnected) {
      throw Exception('No internet connection available. Please check your connection and try again.');
    }
  }
  
  // Collection name for chat messages
  static const String collectionName = 'chat_messages';

  // Get the current user's chat messages collection reference
  CollectionReference get _messagesCollection {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }
    return _firestore.collection('users').doc(user.uid).collection(collectionName);
  }
  
  // Add a new chat message
  Future<DocumentReference> addMessage(ChatMessageModel message) async {
    try {
      await _checkConnectivity();
      
      return await _messagesCollection.add(message.toMap());
    } catch (e) {
      debugPrint('Error adding message: $e');
      rethrow;
    }
  }
  
  // Delete all chat messages (clear chat)
  Future<void> clearChat() async {
    try {
      await _checkConnectivity();
      
      WriteBatch batch = _firestore.batch();
      
      QuerySnapshot snapshot = await _messagesCollection.get();
      
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      debugPrint('Error clearing chat: $e');
      rethrow;
    }
  }
  
  // Get all chat messages
  Future<List<ChatMessageModel>> getAllMessages() async {
    try {
      await _checkConnectivity();
      
      QuerySnapshot snapshot = await _messagesCollection
          .orderBy('createdAt', descending: true)
          .get();
          
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ChatMessageModel.fromMap(data);
      }).toList();
    } catch (e) {
      debugPrint('Error getting all messages: $e');
      rethrow;
    }
  }
  
  // Stream messages
  Stream<List<ChatMessageModel>> streamMessages() {
    try {
      if (!_connectivityService.isConnected) {
        return Stream.error('No internet connection available.');
      }
      
      return _messagesCollection
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ChatMessageModel.fromMap(data);
            }).toList();
          });
    } catch (e) {
      debugPrint('Error streaming messages: $e');
      return Stream.error(e);
    }
  }

  
}