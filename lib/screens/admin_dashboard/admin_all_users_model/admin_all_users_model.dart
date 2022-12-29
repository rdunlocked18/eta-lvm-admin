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
  final String? accountId;
  final String? createdAt;
  final String? updatedAt;
  final Metatrader? metatrader;
  bool isSelected = false;
  final int? totalProfit;

  SingleUserData({
    this.id,
    this.username,
    this.email,
    this.address,
    this.phone,
    this.accountId,
    this.createdAt,
    this.updatedAt,
    this.metatrader,
    this.totalProfit,
  });

  SingleUserData copyWith({
    int? id,
    String? username,
    String? email,
    String? address,
    String? phone,
    String? accountId,
    String? createdAt,
    String? updatedAt,
    Metatrader? metatrader,
    int? totalProfit,
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
      metatrader: metatrader ?? this.metatrader,
      totalProfit: totalProfit ?? this.totalProfit,
    );
  }

  SingleUserData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        username = json['username'] as String?,
        email = json['email'] as String?,
        address = json['address'] as String?,
        phone = json['phone'] as String?,
        accountId = json['accountId'] as String?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?,
        metatrader = (json['metatrader'] as Map<String, dynamic>?) != null
            ? Metatrader.fromJson(json['metatrader'] as Map<String, dynamic>)
            : null,
        totalProfit = json['totalProfit'] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'address': address,
        'phone': phone,
        'accountId': accountId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'metatrader': metatrader?.toJson(),
        'totalProfit': totalProfit.toString(),
      };
}

class Metatrader {
  final int? id;
  final int? userId;
  final String? serverId;
  final String? serverPassword;
  final String? serverName;
  final String? createdAt;
  final String? updatedAt;

  Metatrader({
    this.id,
    this.userId,
    this.serverId,
    this.serverPassword,
    this.serverName,
    this.createdAt,
    this.updatedAt,
  });

  Metatrader copyWith({
    int? id,
    int? userId,
    String? serverId,
    String? serverPassword,
    String? serverName,
    String? createdAt,
    String? updatedAt,
  }) {
    return Metatrader(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serverId: serverId ?? this.serverId,
      serverPassword: serverPassword ?? this.serverPassword,
      serverName: serverName ?? this.serverName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Metatrader.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        userId = json['userId'] as int?,
        serverId = json['serverId'] as String?,
        serverPassword = json['serverPassword'] as String?,
        serverName = json['serverName'] as String?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'serverId': serverId,
        'serverPassword': serverPassword,
        'serverName': serverName,
        'createdAt': createdAt,
        'updatedAt': updatedAt
      };
}
