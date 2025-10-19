import 'package:equatable/equatable.dart';
import 'package:trainning/domain/entities/music.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object?> get props => [];
}

class LoadMusics extends MusicEvent {}

class AddMusic extends MusicEvent {
  final Music music;

  const AddMusic(this.music);

  @override
  List<Object?> get props => [music];
}

class UpdateMusic extends MusicEvent {
  final Music music;

  const UpdateMusic(this.music);

  @override
  List<Object?> get props => [music];
}

class DeleteMusic extends MusicEvent {
  final String id;

  const DeleteMusic(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchMusics extends MusicEvent {
  final String query;

  const SearchMusics(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterMusicsByGenre extends MusicEvent {
  final String genre;

  const FilterMusicsByGenre(this.genre);

  @override
  List<Object?> get props => [genre];
}

class SortMusicsByYear extends MusicEvent {}
