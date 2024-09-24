import '../../../../model/product.dart';

class DetailProductResponse {
  final bool success;
  final String message;
  final Product? product;

  DetailProductResponse({
    required this.success,
    required this.message,
    this.product,
  });

  factory DetailProductResponse.fromJson(Map<String, dynamic> json) =>
      DetailProductResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
