import 'dart:convert';

class GetProjectDetailsResponseModel {
    final int? statusCode;
    final Data? data;
    final String? message;
    final bool? success;

    GetProjectDetailsResponseModel({
        this.statusCode,
        this.data,
        this.message,
        this.success,
    });

    GetProjectDetailsResponseModel copyWith({
        int? statusCode,
        Data? data,
        String? message,
        bool? success,
    }) => 
        GetProjectDetailsResponseModel(
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
            message: message ?? this.message,
            success: success ?? this.success,
        );

    factory GetProjectDetailsResponseModel.fromRawJson(String str) => GetProjectDetailsResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetProjectDetailsResponseModel.fromJson(Map<String, dynamic> json) => GetProjectDetailsResponseModel(
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
    final String? name;
    final dynamic agreement;
    final dynamic srs;
    final String? projectType;
    final String? cPaymentStatus;
    final String? ePaymentStatus;
    final String? cost;
    final bool? isActive;
    final DateTime? startDate;
    final String? endDate;
    final DateTime? billingDate;
    final String? price;
    final String? note;
    final List<Social>? social;
    final List<WorkSheet>? workSheet;
    final String? userId;
    final String? employeeId;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? code;
    final int? v;

    Data({
        this.id,
        this.name,
        this.agreement,
        this.srs,
        this.projectType,
        this.cPaymentStatus,
        this.ePaymentStatus,
        this.cost,
        this.isActive,
        this.startDate,
        this.endDate,
        this.billingDate,
        this.price,
        this.note,
        this.social,
        this.workSheet,
        this.userId,
        this.employeeId,
        this.createdAt,
        this.updatedAt,
        this.code,
        this.v,
    });

    Data copyWith({
        String? id,
        String? name,
        dynamic agreement,
        dynamic srs,
        String? projectType,
        String? cPaymentStatus,
        String? ePaymentStatus,
        String? cost,
        bool? isActive,
        DateTime? startDate,
        String? endDate,
        DateTime? billingDate,
        String? price,
        String? note,
        List<Social>? social,
        List<WorkSheet>? workSheet,
        String? userId,
        String? employeeId,
        DateTime? createdAt,
        DateTime? updatedAt,
        String? code,
        int? v,
    }) => 
        Data(
            id: id ?? this.id,
            name: name ?? this.name,
            agreement: agreement ?? this.agreement,
            srs: srs ?? this.srs,
            projectType: projectType ?? this.projectType,
            cPaymentStatus: cPaymentStatus ?? this.cPaymentStatus,
            ePaymentStatus: ePaymentStatus ?? this.ePaymentStatus,
            cost: cost ?? this.cost,
            isActive: isActive ?? this.isActive,
            startDate: startDate ?? this.startDate,
            endDate: endDate ?? this.endDate,
            billingDate: billingDate ?? this.billingDate,
            price: price ?? this.price,
            note: note ?? this.note,
            social: social ?? this.social,
            workSheet: workSheet ?? this.workSheet,
            userId: userId ?? this.userId,
            employeeId: employeeId ?? this.employeeId,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            code: code ?? this.code,
            v: v ?? this.v,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        name: json["name"],
        agreement: json["agreement"],
        srs: json["srs"],
        projectType: json["project_type"],
        cPaymentStatus: json["c_payment_status"],
        ePaymentStatus: json["e_payment_status"],
        cost: json["cost"],
        isActive: json["is_active"],
        startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
        endDate: json["end_date"],
        billingDate: json["billing_date"] == null ? null : DateTime.parse(json["billing_date"]),
        price: json["price"],
        note: json["note"],
        social: json["social"] == null ? [] : List<Social>.from(json["social"]!.map((x) => Social.fromJson(x))),
        workSheet: json["work_sheet"] == null ? [] : List<WorkSheet>.from(json["work_sheet"]!.map((x) => WorkSheet.fromJson(x))),
        userId: json["userId"],
        employeeId: json["employeeId"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        code: json["code"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "agreement": agreement,
        "srs": srs,
        "project_type": projectType,
        "c_payment_status": cPaymentStatus,
        "e_payment_status": ePaymentStatus,
        "cost": cost,
        "is_active": isActive,
        "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date": endDate,
        "billing_date": "${billingDate!.year.toString().padLeft(4, '0')}-${billingDate!.month.toString().padLeft(2, '0')}-${billingDate!.day.toString().padLeft(2, '0')}",
        "price": price,
        "note": note,
        "social": social == null ? [] : List<dynamic>.from(social!.map((x) => x.toJson())),
        "work_sheet": workSheet == null ? [] : List<dynamic>.from(workSheet!.map((x) => x.toJson())),
        "userId": userId,
        "employeeId": employeeId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "code": code,
        "__v": v,
    };
}

class Social {
    final String? name;
    final String? link;
    final String? username;
    final String? password;
    final String? id;

    Social({
        this.name,
        this.link,
        this.username,
        this.password,
        this.id,
    });

    Social copyWith({
        String? name,
        String? link,
        String? username,
        String? password,
        String? id,
    }) => 
        Social(
            name: name ?? this.name,
            link: link ?? this.link,
            username: username ?? this.username,
            password: password ?? this.password,
            id: id ?? this.id,
        );

    factory Social.fromRawJson(String str) => Social.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Social.fromJson(Map<String, dynamic> json) => Social(
        name: json["name"],
        link: json["link"],
        username: json["username"],
        password: json["password"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "link": link,
        "username": username,
        "password": password,
        "_id": id,
    };
}

class WorkSheet {
    final String? name;
    final String? link;
    final String? id;

    WorkSheet({
        this.name,
        this.link,
        this.id,
    });

    WorkSheet copyWith({
        String? name,
        String? link,
        String? id,
    }) => 
        WorkSheet(
            name: name ?? this.name,
            link: link ?? this.link,
            id: id ?? this.id,
        );

    factory WorkSheet.fromRawJson(String str) => WorkSheet.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WorkSheet.fromJson(Map<String, dynamic> json) => WorkSheet(
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
