import 'package:trainning/domain/repositories/music_repository.dart';

class DeleteMusic {
  final MusicRepository repository;

  DeleteMusic(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteMusic(id);
  }
}
