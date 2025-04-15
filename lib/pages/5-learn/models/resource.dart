enum ResourceType { video, article }

class Resource {
  final ResourceType type;
  final String title;
  final String url;

  const Resource({required this.type, required this.title, required this.url});
}
