import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  final bool official;
  
  const Video({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.official,
  });
  
  String get youtubeUrl => site == 'YouTube' 
      ? 'https://www.youtube.com/watch?v=$key'
      : '';
  
  String get youtubeThumbnailUrl => site == 'YouTube'
      ? 'https://img.youtube.com/vi/$key/0.jpg'
      : '';
  
  @override
  List<Object> get props => [id, key, name, site, type, official];
}

