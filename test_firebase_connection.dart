import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  print('🔥 Testing Firebase connection...');
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
    
    // Test Firestore connection
    final firestore = FirebaseFirestore.instance;
    print('📊 Testing Firestore connection...');
    
    // Try to read from musics collection
    final snapshot = await firestore.collection('musics').limit(1).get();
    print('✅ Successfully connected to Firestore');
    print('📄 Found ${snapshot.docs.length} documents in musics collection');
    
    // Test write operation
    print('✍️ Testing write operation...');
    final testDoc = firestore.collection('musics').doc('test-connection');
    await testDoc.set({
      'title': 'Test Connection',
      'artist': 'Test Artist',
      'genre': 'Test',
      'year': 2024,
      'coverUrl': 'https://example.com/cover.jpg',
      'linkUrl': 'https://example.com/music.mp3',
      'id': 'test-connection',
    });
    print('✅ Write operation successful');
    
    // Clean up test document
    await testDoc.delete();
    print('🧹 Test document cleaned up');
    
    print('🎉 All Firebase tests passed!');
    
  } catch (e) {
    print('❌ Firebase test failed: $e');
    print('Stack trace: ${StackTrace.current}');
  }
}
