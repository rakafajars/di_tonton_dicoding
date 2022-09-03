part of 'movie_recommendation_bloc.dart';

abstract class MovieRecommendationEvent extends Equatable {
  const MovieRecommendationEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieRecommendationEvent extends MovieRecommendationEvent {
  final int id;

  FetchMovieRecommendationEvent(this.id);

  @override
  List<Object> get props => [id];
}
