import 'package:trainning/domain/entities/music.dart';
import 'package:trainning/domain/repositories/music_repository.dart';

class SearchMusics {
  final MusicRepository repository;

  SearchMusics(this.repository);

  Future<List<Music>> call(String query) async {
    return await repository.searchMusics(query);
  }
}
