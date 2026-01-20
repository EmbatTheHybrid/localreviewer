class Review {
  final String title;
  final String content;
  final String reviewImage;

  const Review({
    required this.title,
    required this.content,
    required this.reviewImage
  });

  @override
  String toString() {
    return "$title--$content--$reviewImage";
  }
}