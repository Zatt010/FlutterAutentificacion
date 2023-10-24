import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Movie {
  final String title;

  Movie(this.title);

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(json['title']);
  }
}

class PopularMoviesScreen extends StatefulWidget {
  @override
  _PopularMoviesScreenState createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> {
  Future<List<Movie>> fetchPopularMovies() async {
    final String apiKey = 'a7a46dffad0c3eaa781834c7a32faf74';
    final String baseUrl = 'https://api.themoviedb.org/3';
    final String endpoint = '/discover/movie';
    final String sortBy = 'popularity.desc';

    final Dio dio = Dio();
    try {
      final Response response = await dio.get(
        '$baseUrl$endpoint',
        queryParameters: {
          'sort_by': sortBy,
          'api_key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> movieData = response.data['results'];
        List<Movie> movies =
            movieData.map((json) => Movie.fromJson(json)).toList();
        return movies;
      } else {
        throw Exception('Error al cargar las películas populares');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Películas Populares'),
      ),
      body: FutureBuilder<List<Movie>>(
        future:
            fetchPopularMovies(), // Llama a la función para obtener las películas
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Movie> movies = snapshot.data ?? [];
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(movies[index].title),
                );
              },
            );
          }
        },
      ),
    );
  }
}
