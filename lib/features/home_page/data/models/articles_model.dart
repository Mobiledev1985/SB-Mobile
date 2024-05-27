import 'package:equatable/equatable.dart';

class SocialsArticles extends Equatable {
  final List<Article> articles;

  const SocialsArticles({required this.articles});

  @override
  List<Object> get props => [articles];

  factory SocialsArticles.fromJson(Map<String, dynamic> json) {
    List<Article> articles = [];

    json['result'].forEach((element) {
      articles.add(Article.fromJson(element ?? ''));
    });

    return SocialsArticles(articles: articles);
  }
}

class Article extends Equatable {
  final String image;
  final String title;
  final String subTitle;
  final String markdown;
  final String postedAt;
  final String author;
  final String id;
  final int readTime;
  final List<String> tags;

  const Article(
      {required this.id,
      required this.title,
      required this.subTitle,
      required this.author,
      required this.image,
      required this.markdown,
      required this.readTime,
      required this.tags,
      required this.postedAt});

  @override
  List<Object> get props => [id, title, author, postedAt];

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subTitle: json['subtitle'] ?? '',
      author: json['author_name'] ?? '',
      image: json['image'] ?? '',
      markdown: json['markdown'] ?? '',
      postedAt: json['posted_at'] ?? '',
      readTime: json['read_time_mins'] ?? '',
      tags: json['tags'].cast<String>() ?? '',
    );
  }
}
