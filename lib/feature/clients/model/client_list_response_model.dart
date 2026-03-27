import 'dart:convert';

class ClientListResponseModel {
    final int? statusCode;
    final Data? data;
    final String? message;
    final bool? success;

    ClientListResponseModel({
        this.statusCode,
        this.data,
        this.message,
        this.success,
    });

    ClientListResponseModel copyWith({
        int? statusCode,
        Data? data,
        String? message,
        bool? success,
    }) => 
        ClientListResponseModel(
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
            message: message ?? this.message,
            success: success ?? this.success,
        );

    factory ClientListResponseModel.fromRawJson(String str) => ClientListResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ClientListResponseModel.fromJson(Map<String, dynamic> json) => ClientListResponseModel(
        statusCode: json["statusCode"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data?.toJson(),
        "message": message,
        "success": success,
    };
}

class Data {
    final List<Item>? items;
    final Meta? meta;

    Data({
        this.items,
        this.meta,
    });

    Data copyWith({
        List<Item>? items,
        Meta? meta,
    }) => 
        Data(
            items: items ?? this.items,
            meta: meta ?? this.meta,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
    };
}

class Item {
    final String? userName;
    final String? email;
    final UserType? userType;
    final bool? isActive;
    final String? image;
    final String? phone;
    final String? whatsapp;
    final String? website;
    final List<Social>? social;
    final List<dynamic>? documents;
    final List<Address>? address;
    final String? password;
    final String? mainPassword;
    final PermissionId? permissionId;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? userCode;
    final int? v;
    final String? refreshToken;
    final String? id;

    Item({
        this.userName,
        this.email,
        this.userType,
        this.isActive,
        this.image,
        this.phone,
        this.whatsapp,
        this.website,
        this.social,
        this.documents,
        this.address,
        this.password,
        this.mainPassword,
        this.permissionId,
        this.createdAt,
        this.updatedAt,
        this.userCode,
        this.v,
        this.refreshToken,
        this.id,
    });

    Item copyWith({
        String? userName,
        String? email,
        UserType? userType,
        bool? isActive,
        String? image,
        String? phone,
        String? whatsapp,
        String? website,
        List<Social>? social,
        List<dynamic>? documents,
        List<Address>? address,
        String? password,
        String? mainPassword,
        PermissionId? permissionId,
        DateTime? createdAt,
        DateTime? updatedAt,
        String? userCode,
        int? v,
        String? refreshToken,
        String? id,
    }) => 
        Item(
            userName: userName ?? this.userName,
            email: email ?? this.email,
            userType: userType ?? this.userType,
            isActive: isActive ?? this.isActive,
            image: image ?? this.image,
            phone: phone ?? this.phone,
            whatsapp: whatsapp ?? this.whatsapp,
            website: website ?? this.website,
            social: social ?? this.social,
            documents: documents ?? this.documents,
            address: address ?? this.address,
            password: password ?? this.password,
            mainPassword: mainPassword ?? this.mainPassword,
            permissionId: permissionId ?? this.permissionId,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            userCode: userCode ?? this.userCode,
            v: v ?? this.v,
            refreshToken: refreshToken ?? this.refreshToken,
            id: id ?? this.id,
        );

    factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        userName: json["userName"],
        email: json["email"],
        userType: userTypeValues.map[json["user_type"]]!,
        isActive: json["is_active"],
        image: json["image"],
        phone: json["phone"],
        whatsapp: json["whatsapp"],
        website: json["website"],
        social: json["social"] == null ? [] : List<Social>.from(json["social"]!.map((x) => Social.fromJson(x))),
        documents: json["documents"] == null ? [] : List<dynamic>.from(json["documents"]!.map((x) => x)),
        address: json["address"] == null ? [] : List<Address>.from(json["address"]!.map((x) => Address.fromJson(x))),
        password: json["password"],
        mainPassword: json["main_password"],
        permissionId: permissionIdValues.map[json["permissionId"]]!,
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        userCode: json["user_code"],
        v: json["__v"],
        refreshToken: json["refreshToken"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "userName": userName,
        "email": email,
        "user_type": userTypeValues.reverse[userType],
        "is_active": isActive,
        "image": image,
        "phone": phone,
        "whatsapp": whatsapp,
        "website": website,
        "social": social == null ? [] : List<dynamic>.from(social!.map((x) => x.toJson())),
        "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x)),
        "address": address == null ? [] : List<dynamic>.from(address!.map((x) => x.toJson())),
        "password": password,
        "main_password": mainPassword,
        "permissionId": permissionIdValues.reverse[permissionId],
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "user_code": userCode,
        "__v": v,
        "refreshToken": refreshToken,
        "id": id,
    };
}

class Address {
    final String? name;
    final String? where;
    final String? id;

    Address({
        this.name,
        this.where,
        this.id,
    });

    Address copyWith({
        String? name,
        String? where,
        String? id,
    }) => 
        Address(
            name: name ?? this.name,
            where: where ?? this.where,
            id: id ?? this.id,
        );

    factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        name: json["name"],
        where: json["where"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "where": where,
        "_id": id,
    };
}

enum PermissionId {
    THE_68_AECF091_CD8_E5_C713743_C53
}

final permissionIdValues = EnumValues({
    "68aecf091cd8e5c713743c53": PermissionId.THE_68_AECF091_CD8_E5_C713743_C53
});

class Social {
    final String? name;
    final String? link;
    final String? id;

    Social({
        this.name,
        this.link,
        this.id,
    });

    Social copyWith({
        String? name,
        String? link,
        String? id,
    }) => 
        Social(
            name: name ?? this.name,
            link: link ?? this.link,
            id: id ?? this.id,
        );

    factory Social.fromRawJson(String str) => Social.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Social.fromJson(Map<String, dynamic> json) => Social(
        name: json["name"],
        link: json["link"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "link": link,
        "_id": id,
    };
}

enum UserType {
    CLIENT
}

final userTypeValues = EnumValues({
    "client": UserType.CLIENT
});

class Meta {
    final int? currentPage;
    final int? from;
    final int? lastPage;
    final int? perPage;
    final int? to;
    final int? total;

    Meta({
        this.currentPage,
        this.from,
        this.lastPage,
        this.perPage,
        this.to,
        this.total,
    });

    Meta copyWith({
        int? currentPage,
        int? from,
        int? lastPage,
        int? perPage,
        int? to,
        int? total,
    }) => 
        Meta(
            currentPage: currentPage ?? this.currentPage,
            from: from ?? this.from,
            lastPage: lastPage ?? this.lastPage,
            perPage: perPage ?? this.perPage,
            to: to ?? this.to,
            total: total ?? this.total,
        );

    factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "per_page": perPage,
        "to": to,
        "total": total,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
