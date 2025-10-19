import 'package:trainning/domain/entities/music.dart';
import 'package:trainning/domain/repositories/music_repository.dart';

class UpdateMusic {
  final MusicRepository repository;

  UpdateMusic(this.repository);

  Future<void> call(Music music) async {
    return await repository.updateMusic(music);
  }
}
