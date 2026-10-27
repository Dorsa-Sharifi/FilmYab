class AdminStatistics {
  const AdminStatistics({
    required this.users,
    required this.cachedMedia,
    required this.reviews,
    required this.openReports,
  });

  final int users;
  final int cachedMedia;
  final int reviews;
  final int openReports;

  factory AdminStatistics.fromJson(Map<String, dynamic> json) =>
      AdminStatistics(
        users: (json['users'] as num?)?.toInt() ?? 0,
        cachedMedia: (json['cached_media'] as num?)?.toInt() ?? 0,
        reviews: (json['reviews'] as num?)?.toInt() ?? 0,
        openReports: (json['open_reports'] as num?)?.toInt() ?? 0,
      );
}
