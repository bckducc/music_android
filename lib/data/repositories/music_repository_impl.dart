import 'package:trainning/data/datasources/music_firestore_data_source.dart';
import 'package:trainning/data/models/music_model.dart';
import 'package:trainning/domain/entities/music.dart';
import 'package:trainning/domain/repositories/music_repository.dart';

class MusicRepositoryImpl implements MusicRepository {
  final MusicFirestoreDataSource firestoreDataSource;

  MusicRepositoryImpl({required this.firestoreDataSource});

  @override
  Future<List<Music>> getAllMusics() async {
    try {
      print('🎵 MusicRepository: Getting all musics...');
      final musicModels = await firestoreDataSource.getAllMusics();
      print('🎵 MusicRepository: Got ${musicModels.length} music models');
      final musics = musicModels.map((model) => model as Music).toList();
      print('🎵 MusicRepository: Converted to ${musics.length} music entities');
      return musics;
    } catch (e) {
      print('🎵 MusicRepository: Error getting musics: $e');
      rethrow;
    }
  }

  @override
  Future<Music> getMusicById(String id) async {
    final musicModel = await firestoreDataSource.getMusicById(id);
    return musicModel as Music;
  }

  @override
  Future<void> addMusic(Music music) async {
    final musicModel = MusicModel.fromMusic(music);
    await firestoreDataSource.addMusic(musicModel);
  }

  @override
  Future<void> updateMusic(Music music) async {
    final musicModel = MusicModel.fromMusic(music);
    await firestoreDataSource.updateMusic(musicModel);
  }

  @override
  Future<void> deleteMusic(String id) async {
    await firestoreDataSource.deleteMusic(id);
  }

  @override
  Future<List<Music>> searchMusics(String query) async {
    final musicModels = await firestoreDataSource.searchMusics(query);
    return musicModels.map((model) => model as Music).toList();
  }

  @override
  Future<List<Music>> filterMusicsByGenre(String genre) async {
    final musicModels = await firestoreDataSource.filterMusicsByGenre(genre);
    return musicModels.map((model) => model as Music).toList();
  }

  @override
  Future<List<Music>> sortMusicsByYear() async {
    final musicModels = await firestoreDataSource.sortMusicsByYear();
    return musicModels.map((model) => model as Music).toList();
  }
}
