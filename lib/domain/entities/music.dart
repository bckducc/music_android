import 'package:equatable/equatable.dart';

class Music extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String genre;
  final int year;
  final String coverUrl;
  final String linkUrl;

  const Music({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.year,
    required this.coverUrl,
    required this.linkUrl,
  });

  Music copyWith({
    String? id,
    String? title,
    String? artist,
    String? genre,
    int? year,
    String? coverUrl,
    String? linkUrl,
  }) {
    return Music(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      genre: genre ?? this.genre,
      year: year ?? this.year,
      coverUrl: coverUrl ?? this.coverUrl,
      linkUrl: linkUrl ?? this.linkUrl,
    );
  }

  @override
  List<Object?> get props => [id, title, artist, genre, year, coverUrl, linkUrl];
}
