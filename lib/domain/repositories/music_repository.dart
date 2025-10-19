import 'package:trainning/domain/entities/music.dart';

abstract class MusicRepository {
  Future<List<Music>> getAllMusics();
  Future<Music> getMusicById(String id);
  Future<void> addMusic(Music music);
  Future<void> updateMusic(Music music);
  Future<void> deleteMusic(String id);
  Future<List<Music>> searchMusics(String query);
  Future<List<Music>> filterMusicsByGenre(String genre);
  Future<List<Music>> sortMusicsByYear();
}
