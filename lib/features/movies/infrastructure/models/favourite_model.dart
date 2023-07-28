import 'package:freezed_annotation/freezed_annotation.dart';

part 'favourite_model.freezed.dart';
part 'favourite_model.g.dart';

@freezed
abstract class Favourite with _$Favourite {
  const factory Favourite({
    @JsonKey(name: 'uid') required String uid,
    @JsonKey(name: 'movieId') @Default([]) List<MovieInfo> movieId,
  }) = _Favourite;

  factory Favourite.fromJson(Map<String, dynamic> json) =>
      _$FavouriteFromJson(json);
}

@freezed
abstract class MovieInfo with _$MovieInfo {
  const factory MovieInfo({
    @JsonKey(name: 'id') @Default('') String id,
    @JsonKey(name: 'title') @Default('') String title,
    @JsonKey(name: 'image') @Default('') String image,
  }) = _MovieInfo;

  factory MovieInfo.fromJson(Map<String, dynamic> json) =>
      _$MovieInfoFromJson(json);
}
