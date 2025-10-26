class SubmitResult {
  final double score;
  final int total;

  SubmitResult({required this.score, required this.total});

  factory SubmitResult.fromJson(Map<String, dynamic> json) {
    return SubmitResult(
      score: (json['score'] as num).toDouble(),
      total: json['total'] as int,
    );
  }
}
