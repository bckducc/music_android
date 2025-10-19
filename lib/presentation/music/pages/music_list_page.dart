import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainning/presentation/bloc/music_bloc.dart';
import 'package:trainning/presentation/bloc/music_event.dart';
import 'package:trainning/presentation/bloc/music_state.dart';
import 'package:trainning/presentation/music/pages/add_music_page.dart';
import 'package:trainning/presentation/music/pages/music_detail_page.dart';

class MusicListPage extends StatefulWidget {
  const MusicListPage({super.key});

  @override
  State<MusicListPage> createState() => _MusicListPageState();
}

class _MusicListPageState extends State<MusicListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedGenre = 'Tất cả';
  final List<String> _genres = ['Tất cả', 'Pop', 'Rock', 'Jazz', 'EDM', 'Ballad'];

  @override
  void initState() {
    super.initState();
    print('🎵 MusicListPage: initState called');
    context.read<MusicBloc>().add(LoadMusics());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Manager'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm bài hát...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<MusicBloc>().add(LoadMusics());
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<MusicBloc>().add(LoadMusics());
                    } else {
                      context.read<MusicBloc>().add(SearchMusics(value));
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Genre Filter
                Row(
                  children: [
                    const Text('Thể loại: '),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedGenre,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: _genres.map((String genre) {
                          return DropdownMenuItem<String>(
                            value: genre,
                            child: Text(genre),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGenre = newValue!;
                          });
                          if (newValue == 'Tất cả') {
                            context.read<MusicBloc>().add(LoadMusics());
                          } else {
                            // TODO: Implement genre filtering
                            context.read<MusicBloc>().add(LoadMusics());
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement sort by year
                        context.read<MusicBloc>().add(LoadMusics());
                      },
                      icon: const Icon(Icons.sort),
                      label: const Text('Sắp xếp'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Music List
          Expanded(
            child: BlocBuilder<MusicBloc, MusicState>(
              builder: (context, state) {
                print('🎵 MusicListPage: Building with state: ${state.runtimeType}');
                if (state is MusicLoading) {
                  print('🎵 MusicListPage: Showing loading...');
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MusicError) {
                  print('🎵 MusicListPage: Showing error: ${state.message}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 64, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          'Lỗi: ${state.message}',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<MusicBloc>().add(LoadMusics());
                          },
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                } else if (state is MusicLoaded) {
                  print('🎵 MusicListPage: Loaded ${state.musics.length} musics');
                  if (state.musics.isEmpty) {
                    print('🎵 MusicListPage: No musics found, showing empty state');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.music_off, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            'Chưa có bài hát nào',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              print('🎵 MusicListPage: Manual refresh triggered');
                              context.read<MusicBloc>().add(LoadMusics());
                            },
                            child: const Text('Làm mới'),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.musics.length,
                    itemBuilder: (context, index) {
                      final music = state.musics[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              music.coverUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.music_note),
                                );
                              },
                            ),
                          ),
                          title: Text(
                            music.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ca sĩ: ${music.artist}'),
                              Text('Thể loại: ${music.genre}'),
                              Text('Năm: ${music.year}'),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddMusicPage(music: music),
                                  ),
                                );
                              } else if (value == 'delete') {
                                _showDeleteDialog(context, music);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 8),
                                    Text('Sửa'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Xóa', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MusicDetailPage(music: music),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('Không có dữ liệu'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMusicPage(),
            ),
          );
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, music) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa bài hát "${music.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<MusicBloc>().add(DeleteMusic(music.id));
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
