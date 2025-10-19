import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  print('🔥 Adding test data to Firestore...');
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
    
    // Get Firestore instance
    final firestore = FirebaseFirestore.instance;
    print('📊 Firestore instance: $firestore');
    
    // Test data
    final testMusics = [
      {
        'id': 'music-1',
        'title': 'Shape of You',
        'artist': 'Ed Sheeran',
        'genre': 'Pop',
        'year': 2017,
        'coverUrl': 'https://via.placeholder.com/300x300/FF6B6B/FFFFFF?text=Shape+of+You',
        'linkUrl': 'https://example.com/shape-of-you.mp3',
      },
      {
        'id': 'music-2',
        'title': 'Bohemian Rhapsody',
        'artist': 'Queen',
        'genre': 'Rock',
        'year': 1975,
        'coverUrl': 'https://via.placeholder.com/300x300/4ECDC4/FFFFFF?text=Bohemian+Rhapsody',
        'linkUrl': 'https://example.com/bohemian-rhapsody.mp3',
      },
      {
        'id': 'music-3',
        'title': 'Billie Jean',
        'artist': 'Michael Jackson',
        'genre': 'Pop',
        'year': 1982,
        'coverUrl': 'https://via.placeholder.com/300x300/45B7D1/FFFFFF?text=Billie+Jean',
        'linkUrl': 'https://example.com/billie-jean.mp3',
      },
    ];
    
    // Add test data to Firestore
    final batch = firestore.batch();
    
    for (var music in testMusics) {
      final docRef = firestore.collection('musics').doc(music['id'] as String);
      batch.set(docRef, music);
      print('📝 Added music: ${music['title']} by ${music['artist']}');
    }
    
    await batch.commit();
    print('✅ Successfully added ${testMusics.length} test musics to Firestore');
    
    // Verify data was added
    final snapshot = await firestore.collection('musics').get();
    print('📊 Verification: Found ${snapshot.docs.length} documents in musics collection');
    
    for (var doc in snapshot.docs) {
      print('📄 Document: ${doc.id} - ${doc.data()['title']}');
    }
    
  } catch (e) {
    print('❌ Error adding test data: $e');
    print('Stack trace: ${StackTrace.current}');
  }
}
