import '../../../../model/product.dart';

class ListProductResponse {
  final bool success;
  final String message;
  final List<Product> data;

  ListProductResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ListProductResponse.fromJson(Map<String, dynamic> json) =>
      ListProductResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] != null
            ? List<Product>.from(json["data"].map((x) => Product.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
