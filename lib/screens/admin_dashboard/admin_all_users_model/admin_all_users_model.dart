class UserModel {
  String? username;
  String? createDate;
  int? totalProfit;

  bool? isSelected;

  UserModel({
    this.username,
    this.isSelected = false,
    this.createDate,
    this.totalProfit,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    createDate = json['createdAt'];
    totalProfit = json['totalProfit'];

    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username ?? "";
    data['createdAt'] = this.createDate;
    data['totalProfit'] = this.totalProfit ?? "";

    isSelected = false;
    return data;
  }
}

class SingleUserData {
  final int? id;
  final String? username;
  final String? email;
  final String? address;
  final String? phone;
  final dynamic accountId;
  final String? createdAt;
  final String? updatedAt;

  SingleUserData({
    this.id,
    this.username,
    this.email,
    this.address,
    this.phone,
    this.accountId,
    this.createdAt,
    this.updatedAt,
  });

  SingleUserData copyWith({
    int? id,
    String? username,
    String? email,
    String? address,
    String? phone,
    dynamic accountId,
    String? createdAt,
    String? updatedAt,
  }) {
    return SingleUserData(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  SingleUserData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        username = json['username'] as String?,
        email = json['email'] as String?,
        address = json['address'] as String?,
        phone = json['phone'] as String?,
        accountId = json['accountId'],
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'address': address,
        'phone': phone,
        'accountId': accountId,
        'createdAt': createdAt,
        'updatedAt': updatedAt
      };
}
