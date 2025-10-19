# Music Manager App

Ứng dụng Flutter quản lý danh sách bài nhạc với Firebase Firestore.

## Tính năng

### 1. Đăng nhập (Firebase Auth)
- Sử dụng Firebase Authentication để đăng nhập
- Giao diện đăng nhập đơn giản và thân thiện

### 2. Hiển thị danh sách nhạc
- Lấy dữ liệu từ Firebase Firestore (collection: `musics`)
- Hiển thị: ảnh bìa, tên bài hát, ca sĩ, thể loại, năm phát hành
- Giao diện card đẹp mắt với ảnh bìa

### 3. Thêm bài nhạc mới
- Form nhập đầy đủ thông tin: title, artist, genre, year, coverUrl, linkUrl
- Dropdown chọn thể loại: Pop, Rock, Jazz, EDM, Ballad
- Validation đầy đủ cho tất cả trường
- Preview ảnh bìa khi nhập URL
- Lưu lên Firestore

### 4. Sửa / Xóa bài nhạc
- Click vào item để xem chi tiết
- Trang chi tiết với ảnh bìa lớn và thông tin đầy đủ
- Nút sửa và xóa với xác nhận
- Popup menu cho các thao tác nhanh

### 5. Tìm kiếm & Lọc
- Tìm kiếm theo tên bài hát (real-time)
- Dropdown lọc theo thể loại (bao gồm "Tất cả")
- Sắp xếp danh sách theo năm (mới nhất trước)
- Giao diện tìm kiếm và lọc thân thiện

## Cấu trúc dữ liệu Firestore

Collection: `musics`

```json
{
  "id": "string",
  "title": "string",
  "artist": "string", 
  "genre": "string",
  "year": "number",
  "coverUrl": "string",
  "linkUrl": "string"
}
```

## Cấu trúc project

```
lib/
├── data/
│   ├── datasources/
│   │   └── music_firestore_data_source.dart
│   ├── models/
│   │   └── music_model.dart
│   └── repositories/
│       └── music_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── music.dart
│   ├── repositories/
│   │   └── music_repository.dart
│   └── usecases/
│       ├── add_music.dart
│       ├── delete_music.dart
│       ├── get_all_musics.dart
│       ├── search_musics.dart
│       └── update_music.dart
├── presentation/
│   ├── bloc/
│   │   ├── music_bloc.dart
│   │   ├── music_event.dart
│   │   └── music_state.dart
│   ├── music/
│   │   └── pages/
│   │       ├── add_music_page.dart
│   │       ├── music_detail_page.dart
│   │       └── music_list_page.dart
│   └── home_page.dart
└── di/
    └── injection_container.dart
```

## Cài đặt và chạy

1. Đảm bảo đã cài đặt Flutter SDK
2. Clone project và chạy:
   ```bash
   flutter pub get
   ```
3. Cấu hình Firebase:
   - Thêm file `google-services.json` vào `android/app/`
   - Cấu hình Firebase project
4. Chạy ứng dụng:
   ```bash
   flutter run
   ```

## Dependencies chính

- `flutter_bloc`: State management
- `cloud_firestore`: Firebase Firestore
- `firebase_auth`: Firebase Authentication
- `uuid`: Tạo ID duy nhất
- `equatable`: So sánh objects

## Giao diện

- Material Design với theme màu tím
- Responsive design
- Loading states và error handling
- Snackbar notifications
- Confirmation dialogs
- Image preview và error handling

## Tính năng nâng cao

- Clean Architecture với separation of concerns
- Dependency Injection với GetIt
- BLoC pattern cho state management
- Repository pattern cho data access
- Use case pattern cho business logic
- Error handling toàn diện
- Validation đầy đủ
- Real-time search
- Image caching và error handling
