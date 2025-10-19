import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:trainning/firebase_options.dart';
import 'package:trainning/data/datasources/music_firestore_data_source.dart';
import 'package:trainning/data/repositories/auth_repository_impl.dart';
import 'package:trainning/data/repositories/music_repository_impl.dart';
import 'package:trainning/domain/repositories/auth_repository.dart';
import 'package:trainning/domain/repositories/music_repository.dart';
import 'package:trainning/domain/usecases/add_music.dart';
import 'package:trainning/domain/usecases/auth_usecases.dart';
import 'package:trainning/domain/usecases/delete_music.dart';
import 'package:trainning/domain/usecases/get_all_musics.dart';
import 'package:trainning/domain/usecases/search_musics.dart';
import 'package:trainning/domain/usecases/update_music.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External - Firebase
  try {
    print('🔥 Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
    // If firebase_options.dart is missing or config invalid, propagate error
    rethrow;
  }
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Data sources
  sl.registerLazySingleton<MusicFirestoreDataSource>(
      () => MusicFirestoreDataSourceImpl(firestore: sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<MusicRepository>(() => MusicRepositoryImpl(firestoreDataSource: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetAllMusics(sl()));
  sl.registerLazySingleton(() => AddMusic(sl()));
  sl.registerLazySingleton(() => UpdateMusic(sl()));
  sl.registerLazySingleton(() => DeleteMusic(sl()));
  sl.registerLazySingleton(() => SearchMusics(sl()));
  sl.registerLazySingleton(() => WatchAuthState(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => RegisterWithEmail(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
}


