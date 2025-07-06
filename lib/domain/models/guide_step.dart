class GuideStep {
  final String imageAsset;
  final String title;
  final String content;
  final bool isLast;

  const GuideStep({
    required this.imageAsset,
    required this.title,
    required this.content,
    this.isLast = false,
  });
}
