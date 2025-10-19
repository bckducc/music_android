import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainning/domain/usecases/add_music.dart' as add_music_usecase;
import 'package:trainning/domain/usecases/delete_music.dart' as delete_music_usecase;
import 'package:trainning/domain/usecases/get_all_musics.dart';
import 'package:trainning/domain/usecases/search_musics.dart' as search_musics_usecase;
import 'package:trainning/domain/usecases/update_music.dart' as update_music_usecase;
import 'package:trainning/presentation/bloc/music_event.dart';
import 'package:trainning/presentation/bloc/music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final GetAllMusics getAllMusics;
  final add_music_usecase.AddMusic addMusic;
  final update_music_usecase.UpdateMusic updateMusic;
  final delete_music_usecase.DeleteMusic deleteMusic;
  final search_musics_usecase.SearchMusics searchMusics;

  MusicBloc({
    required this.getAllMusics,
    required this.addMusic,
    required this.updateMusic,
    required this.deleteMusic,
    required this.searchMusics,
  }) : super(MusicInitial()) {
    on<LoadMusics>(_onLoadMusics);
    on<AddMusic>(_onAddMusic);
    on<UpdateMusic>(_onUpdateMusic);
    on<DeleteMusic>(_onDeleteMusic);
    on<SearchMusics>(_onSearchMusics);
  }

  Future<void> _onLoadMusics(LoadMusics event, Emitter<MusicState> emit) async {
    print('🎵 MusicBloc: Loading musics...');
    emit(MusicLoading());
    try {
      final musics = await getAllMusics();
      print('🎵 MusicBloc: Loaded ${musics.length} musics');
      emit(MusicLoaded(musics));
    } catch (e) {
      print('🎵 MusicBloc: Error loading musics: $e');
      emit(MusicError(e.toString()));
    }
  }

  Future<void> _onAddMusic(AddMusic event, Emitter<MusicState> emit) async {
    try {
      await addMusic(event.music);
      emit(MusicOperationSuccess('Music added successfully'));
      add(LoadMusics()); // Reload the list
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }

  Future<void> _onUpdateMusic(UpdateMusic event, Emitter<MusicState> emit) async {
    try {
      await updateMusic(event.music);
      emit(MusicOperationSuccess('Music updated successfully'));
      add(LoadMusics()); // Reload the list
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }

  Future<void> _onDeleteMusic(DeleteMusic event, Emitter<MusicState> emit) async {
    try {
      await deleteMusic(event.id);
      emit(MusicOperationSuccess('Music deleted successfully'));
      add(LoadMusics()); // Reload the list
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }

  Future<void> _onSearchMusics(SearchMusics event, Emitter<MusicState> emit) async {
    emit(MusicLoading());
    try {
      final musics = await searchMusics(event.query);
      emit(MusicLoaded(musics));
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }
}
