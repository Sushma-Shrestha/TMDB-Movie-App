import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/features/movies/infrastructure/infrastructure.dart';

void main() {
  const rawMovieExampleData = <String, dynamic>{
    'adult': false,
    'backdrop_path': '/A3m5GJu5kzAKK2wkGlzErlCCElT.jpg',
    'genre_ids': [16, 12, 28, 14],
    'id': 900667,
    'original_language': 'ja',
    'original_title': 'ONE PIECE FILM RED',
    'overview':
        'Uta — the most beloved singer in the world. Her voice, which she..',
    'popularity': 814.098,
    'poster_path': '/ogDXuVkO92GcETZfSofXXemw7gb.jpg',
    'release_date': '2022-08-06',
    'title': 'One Piece Film Red',
    'video': false,
    'vote_average': 7.4,
    'vote_count': 585
  };
  const movieExampleData = MovieModel(
      adult: false,
      backdropPath: '/A3m5GJu5kzAKK2wkGlzErlCCElT.jpg',
      genreIds: [16, 12, 28, 14],
      id: 900667,
      originalLanguage: 'ja',
      originalTitle: 'ONE PIECE FILM RED',
      overview:
          'Uta — the most beloved singer in the world. Her voice, which she..',
      popularity: 814.098,
      posterPath: '/ogDXuVkO92GcETZfSofXXemw7gb.jpg',
      releaseDate: '2022-08-06',
      title: 'One Piece Film Red',
      video: false,
      voteAverage: 7.4,
      voteCount: 585);

  group(
    'Test for movie model response',
    () {
      test(
        'can parse data to  movie model fromJson',
        () async {
          expect(
            MovieModel.fromJson(rawMovieExampleData),
            equals(movieExampleData),
          );
        },
      );
      test('can convert movie data model toJson', () {
        expect(movieExampleData.toJson(), rawMovieExampleData);
      });
    },
  );
}
