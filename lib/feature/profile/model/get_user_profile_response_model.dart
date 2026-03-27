import 'dart:convert';

class GetUserProfileResponseModel {
    final int? statusCode;
    final Data? data;
    final String? message;
    final bool? success;

    GetUserProfileResponseModel({
        this.statusCode,
        this.data,
        this.message,
        this.success,
    });

    GetUserProfileResponseModel copyWith({
        int? statusCode,
        Data? data,
        String? message,
        bool? success,
    }) => 
        GetUserProfileResponseModel(
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
            message: message ?? this.message,
            success: success ?? this.success,
        );

    factory GetUserProfileResponseModel.fromRawJson(String str) => GetUserProfileResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetUserProfileResponseModel.fromJson(Map<String, dynamic> json) => GetUserProfileResponseModel(
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
    final String? id;
    final String? userName;
    final String? email;
    final String? userType;
    final bool? isActive;
    final dynamic image;
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

    Data({
        this.id,
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
    });

    Data copyWith({
        String? id,
        String? userName,
        String? email,
        String? userType,
        bool? isActive,
        dynamic image,
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
    }) => 
        Data(
            id: id ?? this.id,
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
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        userName: json["userName"],
        email: json["email"],
        userType: json["user_type"],
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
        permissionId: json["permissionId"] == null ? null : PermissionId.fromJson(json["permissionId"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        userCode: json["user_code"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userName": userName,
        "email": email,
        "user_type": userType,
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
        "permissionId": permissionId?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "user_code": userCode,
        "__v": v,
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

class PermissionId {
    final String? id;
    final String? parentId;
    final String? name;
    final List<Permission>? permissions;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? v;

    PermissionId({
        this.id,
        this.parentId,
        this.name,
        this.permissions,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    PermissionId copyWith({
        String? id,
        String? parentId,
        String? name,
        List<Permission>? permissions,
        DateTime? createdAt,
        DateTime? updatedAt,
        int? v,
    }) => 
        PermissionId(
            id: id ?? this.id,
            parentId: parentId ?? this.parentId,
            name: name ?? this.name,
            permissions: permissions ?? this.permissions,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            v: v ?? this.v,
        );

    factory PermissionId.fromRawJson(String str) => PermissionId.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PermissionId.fromJson(Map<String, dynamic> json) => PermissionId(
        id: json["_id"],
        parentId: json["parentId"],
        name: json["name"],
        permissions: json["permissions"] == null ? [] : List<Permission>.from(json["permissions"]!.map((x) => Permission.fromJson(x))),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "parentId": parentId,
        "name": name,
        "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x.toJson())),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
    };
}

class Permission {
    final String? title;
    final String? icon;
    final String? path;
    final dynamic children;
    final String? id;

    Permission({
        this.title,
        this.icon,
        this.path,
        this.children,
        this.id,
    });

    Permission copyWith({
        String? title,
        String? icon,
        String? path,
        dynamic children,
        String? id,
    }) => 
        Permission(
            title: title ?? this.title,
            icon: icon ?? this.icon,
            path: path ?? this.path,
            children: children ?? this.children,
            id: id ?? this.id,
        );

    factory Permission.fromRawJson(String str) => Permission.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        title: json["title"],
        icon: json["icon"],
        path: json["path"],
        children: json["children"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "icon": icon,
        "path": path,
        "children": children,
        "_id": id,
    };
}

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
