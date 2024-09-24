class ListProductRequest {
  int page;
  int limit;
  ListProductRequest({
    required this.page,
    required this.limit,
  });
  factory ListProductRequest.fromJson(Map<String, dynamic> json) =>
      ListProductRequest(page: json["page"], limit: json["limit"]);
  Map<String, dynamic> toJson() => {"page": page, "limit": limit};
}
