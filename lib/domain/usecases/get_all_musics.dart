import 'package:trainning/domain/entities/music.dart';
import 'package:trainning/domain/repositories/music_repository.dart';

class GetAllMusics {
  final MusicRepository repository;

  GetAllMusics(this.repository);

  Future<List<Music>> call() async {
    return await repository.getAllMusics();
  }
}
