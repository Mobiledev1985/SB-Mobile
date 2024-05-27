import 'package:equatable/equatable.dart';

class SBImages extends Equatable {
  final String primary;
  final List<String> secondary;
  final String? sitemap;

  const SBImages(
      {required this.primary, required this.secondary, required this.sitemap});

  @override
  List<Object> get props => [primary, secondary];

  factory SBImages.fromJson(Map<String, dynamic> json) {
    return SBImages(
        primary: json['primary'] ?? '',
        secondary: json['secondary'].cast<String>() ?? '',
        sitemap: json['sitemap']);
  }

  Map<String, dynamic> toJson() {
    return {'primary': primary, 'secondary': secondary};
  }
}
