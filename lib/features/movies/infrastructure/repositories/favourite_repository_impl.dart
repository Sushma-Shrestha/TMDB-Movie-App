import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/movies/infrastructure/models/favourite_model.dart';
import 'package:movie_app/features/movies/infrastructure/repositories/favourite_repository.dart';

/// Http implementation of [FavouriteRepositoryImpl]
class FavouriteRepositoryImpl implements FavouriteRepository {
  /// Creates a new instance of [FavouriteRepositoryImpl]
  FavouriteRepositoryImpl(this.httpService);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Http service used to access an Http client and make calls
  final HttpService httpService;

  @override
  Future<Either<Favourite, Failure>> fetchfavourites({
    required String uid,
    required bool forceRefresh,
  }) async {
    try {
      final favDoc = await _favourites.doc(uid).get();

      if (!favDoc.exists) {
        return left(
          Favourite(
            uid: uid,
            movieId: [],
          ),
        );
      } else {
        final favourite =
            Favourite.fromJson(favDoc.data()! as Map<String, dynamic>);
        return left(favourite);
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Right(Failure.fromException(e));
    }
  }

  @override
  Future<Either<void, Failure>> postfavourites({
    required String uid,
    required List<MovieInfo> movie,
  }) async {
    try {
      final favDoc = await _favourites.doc(uid).get();
      if (!favDoc.exists) {
        await _favourites.doc(uid).set({
          'uid': uid,
          'movieId[0]': {
            [
              {
                'id': movie[0].id,
                'image': movie[0].image,
                'title': movie[0].title
              }
            ]
          },
        });
      }
      return left(
        _favourites.doc(uid).update({
          'movieId': FieldValue.arrayUnion([
            {
              'id': movie[0].id,
              'image': movie[0].image,
              'title': movie[0].title
            }
          ])
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Right(Failure.fromException(e));
    }
  }

  @override
  Future<Either<void, Failure>> removefavourites({
    required String uid,
    required List<MovieInfo> movieId,
  }) async {
    try {
      var favDoc = await _favourites.doc(uid).get();
      if (favDoc.exists) {
        return left(
          _favourites.doc(uid).update({
            'movieId': FieldValue.arrayRemove([
              {
                'id': movieId[0].id,
                'image': movieId[0].image,
                'title': movieId[0].title
              }
            ])
          }),
        );
      } else {
        return left(
          _favourites.doc(uid).set({
            'uid': uid,
            'movieId': {
              'id': movieId[0].id,
              'image': movieId[0].image,
              'title': movieId[0].title
            },
          }),
        );
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Right(Failure.fromException(e));
    }
  }

  CollectionReference get _favourites =>
      _firestore.collection(FirebaseConstants.favouriteCollection);
}
