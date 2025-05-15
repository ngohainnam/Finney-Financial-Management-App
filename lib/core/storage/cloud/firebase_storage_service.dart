import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String get userId => _auth.currentUser?.uid ?? '';
  
  // Initialize Firebase service
  Future<void> init() async {
    // No specific initialization needed for Firestore
  }
  
  // Get a document reference with user-specific path
  DocumentReference _getDocumentRef(String collection, String documentId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection(collection)
        .doc(documentId);
  }
  
  // Get a collection reference with user-specific path
  CollectionReference _getCollectionRef(String collection) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection(collection);
  }
  
  // Get a document by ID
  Future<Map<String, dynamic>?> getDocument(String collection, String documentId) async {
    try {
      if (userId.isEmpty) return null;
      
      final docRef = _getDocumentRef(collection, documentId);
      final snapshot = await docRef.get();
      
      if (snapshot.exists) {
        return {
          'id': snapshot.id,
          ...snapshot.data() as Map<String, dynamic>
        };
      }
      return null;
    } catch (e) {
      debugPrint('Error getting Firestore document: $e');
      return null;
    }
  }
  
  // Get all documents in a collection
  Future<List<Map<String, dynamic>>> getCollection(String collection) async {
    try {
      if (userId.isEmpty) return [];
      
      final collectionRef = _getCollectionRef(collection);
      final snapshot = await collectionRef.get();
      
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>
      }).toList();
    } catch (e) {
      debugPrint('Error getting Firestore collection: $e');
      return [];
    }
  }
  
  // Add a document with auto-generated ID
  Future<String> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      if (userId.isEmpty) throw Exception('User not logged in');
      
      final collectionRef = _getCollectionRef(collection);
      final docRef = await collectionRef.add(data);
      return docRef.id;
    } catch (e) {
      debugPrint('Error adding Firestore document: $e');
      rethrow;
    }
  }
  
  // Set a document with specific ID
  Future<void> setDocument(String collection, String documentId, Map<String, dynamic> data, {bool merge = false}) async {
    try {
      if (userId.isEmpty) throw Exception('User not logged in');
      
      final docRef = _getDocumentRef(collection, documentId);
      await docRef.set(data, SetOptions(merge: merge));
    } catch (e) {
      debugPrint('Error setting Firestore document: $e');
      rethrow;
    }
  }
  
  // Update specific fields in a document
  Future<void> updateDocument(String collection, String documentId, Map<String, dynamic> data) async {
    try {
      if (userId.isEmpty) throw Exception('User not logged in');
      
      final docRef = _getDocumentRef(collection, documentId);
      await docRef.update(data);
    } catch (e) {
      debugPrint('Error updating Firestore document: $e');
      rethrow;
    }
  }
  
  // Delete a document
  Future<void> deleteDocument(String collection, String documentId) async {
    try {
      if (userId.isEmpty) return;
      
      final docRef = _getDocumentRef(collection, documentId);
      await docRef.delete();
    } catch (e) {
      debugPrint('Error deleting Firestore document: $e');
      rethrow;
    }
  }
  
  // Delete all documents in a collection
  Future<void> clearCollection(String collection) async {
    try {
      if (userId.isEmpty) return;
      
      final collectionRef = _getCollectionRef(collection);
      final snapshot = await collectionRef.get();
      
      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      debugPrint('Error clearing Firestore collection: $e');
      rethrow;
    }
  }
  
  // Stream a collection (real-time updates)
  Stream<List<Map<String, dynamic>>> streamCollection(
    String collection, {
    Query Function(CollectionReference ref)? queryBuilder,
  }) {
    if (userId.isEmpty) {
      return Stream.value([]);
    }
    
    CollectionReference colRef = _getCollectionRef(collection);
    Query query = queryBuilder != null ? queryBuilder(colRef) : colRef;
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    });
  }
  
  // Stream a single document (real-time updates)
  Stream<Map<String, dynamic>?> streamDocument(String collection, String documentId) {
    if (userId.isEmpty) {
      return Stream.value(null);
    }
    
    DocumentReference docRef = _getDocumentRef(collection, documentId);
    
    return docRef.snapshots().map((snapshot) {
      if (snapshot.exists) {
        return {
          'id': snapshot.id,
          ...snapshot.data() as Map<String, dynamic>
        };
      }
      return null;
    });
  }
  
  // Count documents in a collection
  Future<int> countDocuments(String collection) async {
    try {
      if (userId.isEmpty) return 0;
      
      final collectionRef = _getCollectionRef(collection);
      final snapshot = await collectionRef.get();
      return snapshot.size;
    } catch (e) {
      debugPrint('Error counting Firestore documents: $e');
      return 0;
    }
  }
  
  // Check if a document exists
  Future<bool> documentExists(String collection, String documentId) async {
    try {
      if (userId.isEmpty) return false;
      
      final docRef = _getDocumentRef(collection, documentId);
      final snapshot = await docRef.get();
      return snapshot.exists;
    } catch (e) {
      debugPrint('Error checking document existence: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> queryCollection(
    String collection, {
    required Query Function(CollectionReference ref) queryBuilder,
  }) async {
    try {
      if (userId.isEmpty) return [];
      
      final collectionRef = _getCollectionRef(collection);
      final query = queryBuilder(collectionRef);
      final snapshot = await query.get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      debugPrint('Error querying Firestore collection: $e');
      return [];
    }
  }
}