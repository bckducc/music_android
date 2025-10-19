import 'package:trainning/domain/entities/music.dart';
import 'package:trainning/domain/repositories/music_repository.dart';

class AddMusic {
  final MusicRepository repository;

  AddMusic(this.repository);

  Future<void> call(Music music) async {
    return await repository.addMusic(music);
  }
}
