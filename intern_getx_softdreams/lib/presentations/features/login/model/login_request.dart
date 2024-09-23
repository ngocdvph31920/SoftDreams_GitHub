class LoginRequest {
  final int taxCode;
  final String userName;
  final String password;

  LoginRequest({
    required this.taxCode,
    required this.userName,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    taxCode: json["tax_code"],
    userName: json["user_name"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "tax_code": taxCode,
    "user_name": userName,
    "password": password,
  };
}
