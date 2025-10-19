import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trainning/data/models/music_model.dart';

abstract class MusicFirestoreDataSource {
  Future<List<MusicModel>> getAllMusics();
  Future<MusicModel> getMusicById(String id);
  Future<void> addMusic(MusicModel music);
  Future<void> updateMusic(MusicModel music);
  Future<void> deleteMusic(String id);
  Future<List<MusicModel>> searchMusics(String query);
  Future<List<MusicModel>> filterMusicsByGenre(String genre);
  Future<List<MusicModel>> sortMusicsByYear();
}

class MusicFirestoreDataSourceImpl implements MusicFirestoreDataSource {
  final FirebaseFirestore firestore;

  MusicFirestoreDataSourceImpl({required this.firestore});

  @override
  Future<List<MusicModel>> getAllMusics() async {
    try {
      print('🔍 Fetching musics from Firestore...');
      print('🔍 Firestore instance: $firestore');
      print('🔍 Collection path: musics');
      
      final snapshot = await firestore.collection('musics').get();
      print('📊 Found ${snapshot.docs.length} documents');
      print('📊 Snapshot metadata: ${snapshot.metadata}');
      
      if (snapshot.docs.isEmpty) {
        print('⚠️ No documents found in musics collection');
        return [];
      }
      
      final musics = <MusicModel>[];
      for (var doc in snapshot.docs) {
        try {
          print('📄 Processing document ID: ${doc.id}');
          print('📄 Document data: ${doc.data()}');
          print('📄 Document exists: ${doc.exists}');
          
          if (doc.exists && doc.data().isNotEmpty) {
            final musicModel = MusicModel.fromMap(doc.data() as Map<String, dynamic>);
            musics.add(musicModel);
            print('✅ Successfully converted document ${doc.id} to MusicModel');
          } else {
            print('⚠️ Document ${doc.id} is empty or does not exist');
          }
        } catch (e) {
          print('❌ Error processing document ${doc.id}: $e');
          print('❌ Document data: ${doc.data()}');
        }
      }
      
      print('✅ Successfully loaded ${musics.length} musics');
      return musics;
    } catch (e) {
      print('❌ Error fetching musics: $e');
      print('❌ Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  @override
  Future<MusicModel> getMusicById(String id) async {
    final doc = await firestore.collection('musics').doc(id).get();
    if (doc.exists) {
      return MusicModel.fromMap(doc.data()! as Map<String, dynamic>);
    } else {
      throw Exception('Music not found');
    }
  }

  @override
  Future<void> addMusic(MusicModel music) async {
    await firestore.collection('musics').doc(music.id).set(music.toMap());
  }

  @override
  Future<void> updateMusic(MusicModel music) async {
    await firestore.collection('musics').doc(music.id).update(music.toMap());
  }

  @override
  Future<void> deleteMusic(String id) async {
    await firestore.collection('musics').doc(id).delete();
  }

  @override
  Future<List<MusicModel>> searchMusics(String query) async {
    final snapshot = await firestore
        .collection('musics')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThan: query + 'z')
        .get();
    return snapshot.docs
        .map((doc) => MusicModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MusicModel>> filterMusicsByGenre(String genre) async {
    final snapshot = await firestore
        .collection('musics')
        .where('genre', isEqualTo: genre)
        .get();
    return snapshot.docs
        .map((doc) => MusicModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MusicModel>> sortMusicsByYear() async {
    final snapshot = await firestore
        .collection('musics')
        .orderBy('year', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => MusicModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
