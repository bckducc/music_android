import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:trainning/domain/entities/music.dart';
import 'package:trainning/presentation/bloc/music_bloc.dart';
import 'package:trainning/presentation/bloc/music_event.dart';
import 'package:trainning/presentation/bloc/music_state.dart';

class AddMusicPage extends StatefulWidget {
  final Music? music;

  const AddMusicPage({super.key, this.music});

  @override
  State<AddMusicPage> createState() => _AddMusicPageState();
}

class _AddMusicPageState extends State<AddMusicPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _yearController = TextEditingController();
  final _coverUrlController = TextEditingController();
  final _linkUrlController = TextEditingController();
  
  String _selectedGenre = 'Pop';
  final List<String> _genres = ['Pop', 'Rock', 'Jazz', 'EDM', 'Ballad'];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.music != null) {
      _titleController.text = widget.music!.title;
      _artistController.text = widget.music!.artist;
      _selectedGenre = widget.music!.genre;
      _yearController.text = widget.music!.year.toString();
      _coverUrlController.text = widget.music!.coverUrl;
      _linkUrlController.text = widget.music!.linkUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.music != null ? 'Sửa bài hát' : 'Thêm bài hát mới'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<MusicBloc, MusicState>(
        listener: (context, state) {
          if (state is MusicOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is MusicError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tên bài hát *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.music_note),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên bài hát';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Artist Field
                TextFormField(
                  controller: _artistController,
                  decoration: const InputDecoration(
                    labelText: 'Ca sĩ *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên ca sĩ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Genre Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedGenre,
                  decoration: const InputDecoration(
                    labelText: 'Thể loại *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
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
                  },
                ),
                const SizedBox(height: 16),

                // Year Field
                TextFormField(
                  controller: _yearController,
                  decoration: const InputDecoration(
                    labelText: 'Năm phát hành *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập năm phát hành';
                    }
                    final year = int.tryParse(value);
                    if (year == null || year < 1900 || year > DateTime.now().year + 1) {
                      return 'Năm không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Cover URL Field
                TextFormField(
                  controller: _coverUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL ảnh bìa *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.image),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập URL ảnh bìa';
                    }
                    if (!(Uri.tryParse(value)?.hasAbsolutePath ?? false)) {
                      return 'URL không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Link URL Field
                TextFormField(
                  controller: _linkUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL file nhạc *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập URL file nhạc';
                    }
                    if (!(Uri.tryParse(value)?.hasAbsolutePath ?? false)) {
                      return 'URL không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Preview Image
                if (_coverUrlController.text.isNotEmpty)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _coverUrlController.text,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, size: 48, color: Colors.red),
                                SizedBox(height: 8),
                                Text('Không thể tải ảnh'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                // Save Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveMusic,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.music != null ? 'Cập nhật' : 'Thêm bài hát',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveMusic() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final music = Music(
        id: widget.music?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        artist: _artistController.text.trim(),
        genre: _selectedGenre,
        year: int.parse(_yearController.text),
        coverUrl: _coverUrlController.text.trim(),
        linkUrl: _linkUrlController.text.trim(),
      );

      if (widget.music != null) {
        context.read<MusicBloc>().add(UpdateMusic(music));
      } else {
        context.read<MusicBloc>().add(AddMusic(music));
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _yearController.dispose();
    _coverUrlController.dispose();
    _linkUrlController.dispose();
    super.dispose();
  }
}
