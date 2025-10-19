import 'dart:convert';

import 'package:trainning/domain/entities/music.dart';

class MusicModel extends Music {
  const MusicModel({
    required super.id,
    required super.title,
    required super.artist,
    required super.genre,
    required super.year,
    required super.coverUrl,
    required super.linkUrl,
  });

  factory MusicModel.fromMusic(Music music) {
    return MusicModel(
      id: music.id,
      title: music.title,
      artist: music.artist,
      genre: music.genre,
      year: music.year,
      coverUrl: music.coverUrl,
      linkUrl: music.linkUrl,
    );
  }

  factory MusicModel.fromMap(Map<String, dynamic> map) {
    return MusicModel(
      id: map['id'] as String,
      title: map['title'] as String,
      artist: map['artist'] as String,
      genre: map['genre'] as String,
      year: map['year'] as int,
      coverUrl: map['coverUrl'] as String,
      linkUrl: map['linkUrl'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'genre': genre,
      'year': year,
      'coverUrl': coverUrl,
      'linkUrl': linkUrl,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory MusicModel.fromJson(String source) =>
      MusicModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
