import 'dart:convert';

class GetProjectListResponseModel {
    final int? statusCode;
    final Data? data;
    final String? message;
    final bool? success;

    GetProjectListResponseModel({
        this.statusCode,
        this.data,
        this.message,
        this.success,
    });

    GetProjectListResponseModel copyWith({
        int? statusCode,
        Data? data,
        String? message,
        bool? success,
    }) => 
        GetProjectListResponseModel(
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
            message: message ?? this.message,
            success: success ?? this.success,
        );

    factory GetProjectListResponseModel.fromRawJson(String str) => GetProjectListResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetProjectListResponseModel.fromJson(Map<String, dynamic> json) => GetProjectListResponseModel(
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
    final String? name;
    final String? agreement;
    final String? srs;
    final ProjectType? projectType;
    final PaymentStatus? cPaymentStatus;
    final PaymentStatus? ePaymentStatus;
    final String? cost;
    final bool? isActive;
    final DateTime? startDate;
    final String? endDate;
    final DateTime? billingDate;
    final String? price;
    final String? note;
    final List<Social>? social;
    final List<WorkSheet>? workSheet;
    final Id? userId;
    final Id? employeeId;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? code;
    final int? v;
    final String? id;

    Item({
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
        this.id,
    });

    Item copyWith({
        String? name,
        String? agreement,
        String? srs,
        ProjectType? projectType,
        PaymentStatus? cPaymentStatus,
        PaymentStatus? ePaymentStatus,
        String? cost,
        bool? isActive,
        DateTime? startDate,
        String? endDate,
        DateTime? billingDate,
        String? price,
        String? note,
        List<Social>? social,
        List<WorkSheet>? workSheet,
        Id? userId,
        Id? employeeId,
        DateTime? createdAt,
        DateTime? updatedAt,
        String? code,
        int? v,
        String? id,
    }) => 
        Item(
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
            id: id ?? this.id,
        );

    factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json["name"],
        agreement: json["agreement"],
        srs: json["srs"],
        projectType: json["project_type"] == null ? null : projectTypeValues.map[json["project_type"]],
        cPaymentStatus: json["c_payment_status"] == null ? null : paymentStatusValues.map[json["c_payment_status"]],
        ePaymentStatus: json["e_payment_status"] == null ? null : paymentStatusValues.map[json["e_payment_status"]],
        cost: json["cost"],
        isActive: json["is_active"],
        startDate: json["start_date"] == null ? null : DateTime.tryParse(json["start_date"]),
        endDate: json["end_date"],
        billingDate: json["billing_date"] == null ? null : DateTime.tryParse(json["billing_date"]),
        price: json["price"],
        note: json["note"],
        social: json["social"] == null ? [] : List<Social>.from(json["social"]!.map((x) => Social.fromJson(x))),
        workSheet: json["work_sheet"] == null ? [] : List<WorkSheet>.from(json["work_sheet"]!.map((x) => WorkSheet.fromJson(x))),
        userId: json["userId"] == null ? null : Id.fromJson(json["userId"]),
        employeeId: json["employeeId"] == null ? null : Id.fromJson(json["employeeId"]),
        createdAt: json["createdAt"] == null ? null : DateTime.tryParse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.tryParse(json["updatedAt"]),
        code: json["code"],
        v: json["__v"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "agreement": agreement,
        "srs": srs,
        "project_type": projectTypeValues.reverse[projectType],
        "c_payment_status": paymentStatusValues.reverse[cPaymentStatus],
        "e_payment_status": paymentStatusValues.reverse[ePaymentStatus],
        "cost": cost,
        "is_active": isActive,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate,
        "billing_date": billingDate?.toIso8601String(),
        "price": price,
        "note": note,
        "social": social == null ? [] : List<dynamic>.from(social!.map((x) => x.toJson())),
        "work_sheet": workSheet == null ? [] : List<dynamic>.from(workSheet!.map((x) => x.toJson())),
        "userId": userId?.toJson(),
        "employeeId": employeeId?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "code": code,
        "__v": v,
        "id": id,
    };
}

enum PaymentStatus {
    PAID,
    UNPAID
}

final paymentStatusValues = EnumValues({
    "paid": PaymentStatus.PAID,
    "unpaid": PaymentStatus.UNPAID
});

class Id {
    final String? id;
    final String? userName;
    final String? email;
    final UserType? userType;
    final String? employeeType;
    final bool? isActive;
    final String? image;
    final String? salary;
    final String? phone;
    final Whatsapp? whatsapp;
    final List<WorkSheet>? social;
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
    final String? website;

    Id({
        this.id,
        this.userName,
        this.email,
        this.userType,
        this.employeeType,
        this.isActive,
        this.image,
        this.salary,
        this.phone,
        this.whatsapp,
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
        this.website,
    });

    Id copyWith({
        String? id,
        String? userName,
        String? email,
        UserType? userType,
        String? employeeType,
        bool? isActive,
        String? image,
        String? salary,
        String? phone,
        Whatsapp? whatsapp,
        List<WorkSheet>? social,
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
        String? website,
    }) => 
        Id(
            id: id ?? this.id,
            userName: userName ?? this.userName,
            email: email ?? this.email,
            userType: userType ?? this.userType,
            employeeType: employeeType ?? this.employeeType,
            isActive: isActive ?? this.isActive,
            image: image ?? this.image,
            salary: salary ?? this.salary,
            phone: phone ?? this.phone,
            whatsapp: whatsapp ?? this.whatsapp,
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
            website: website ?? this.website,
        );

    factory Id.fromRawJson(String str) => Id.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Id.fromJson(Map<String, dynamic> json) => Id(
        id: json["_id"],
        userName: json["userName"],
        email: json["email"],
        userType: json["user_type"] == null ? null : userTypeValues.map[json["user_type"]],
        employeeType: json["employee_type"],
        isActive: json["is_active"],
        image: json["image"],
        salary: json["salary"],
        phone: json["phone"],
        whatsapp: json["whatsapp"] == null ? null : whatsappValues.map[json["whatsapp"]],
        social: json["social"] == null ? [] : List<WorkSheet>.from(json["social"]!.map((x) => WorkSheet.fromJson(x))),
        documents: json["documents"] == null ? [] : List<dynamic>.from(json["documents"]!.map((x) => x)),
        address: json["address"] == null ? [] : List<Address>.from(json["address"]!.map((x) => Address.fromJson(x))),
        password: json["password"],
        mainPassword: json["main_password"],
        permissionId: json["permissionId"] == null ? null : permissionIdValues.map[json["permissionId"]],
        createdAt: json["createdAt"] == null ? null : DateTime.tryParse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.tryParse(json["updatedAt"]),
        userCode: json["user_code"],
        v: json["__v"],
        refreshToken: json["refreshToken"],
        website: json["website"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userName": userName,
        "email": email,
        "user_type": userTypeValues.reverse[userType],
        "employee_type": employeeType,
        "is_active": isActive,
        "image": image,
        "salary": salary,
        "phone": phone,
        "whatsapp": whatsappValues.reverse[whatsapp],
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
        "website": website,
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
    THE_68_AECF091_CD8_E5_C713743_C53,
    THE_68_F0878_E7614800_BA917_EB11
}

final permissionIdValues = EnumValues({
    "68aecf091cd8e5c713743c53": PermissionId.THE_68_AECF091_CD8_E5_C713743_C53,
    "68f0878e7614800ba917eb11": PermissionId.THE_68_F0878_E7614800_BA917_EB11
});

class WorkSheet {
    final Name? name;
    final Link? link;
    final String? id;

    WorkSheet({
        this.name,
        this.link,
        this.id,
    });

    WorkSheet copyWith({
        Name? name,
        Link? link,
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
        name: json["name"] == null ? null : nameValues.map[json["name"]],
        link: json["link"] == null ? null : linkValues.map[json["link"]],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "name": nameValues.reverse[name],
        "link": linkValues.reverse[link],
        "_id": id,
    };
}

enum Link {
    AUT_TEMPORE_VOLUPTA,
    EMPTY,
    IN_VERO_SED_VOLUPTAT,
    LABORIOSAM_IN_QUIS,
    REM_LABORE_FACERE_LA
}

final linkValues = EnumValues({
    "Aut tempore volupta": Link.AUT_TEMPORE_VOLUPTA,
    "": Link.EMPTY,
    "In vero sed voluptat": Link.IN_VERO_SED_VOLUPTAT,
    "Laboriosam in quis ": Link.LABORIOSAM_IN_QUIS,
    "Rem labore facere la": Link.REM_LABORE_FACERE_LA
});

enum Name {
    COLT_COOKE,
    EMILY_BURT,
    EMPTY,
    MARI_GOLDEN,
    PHOEBE_KINNEY
}

final nameValues = EnumValues({
    "Colt Cooke": Name.COLT_COOKE,
    "Emily Burt": Name.EMILY_BURT,
    "": Name.EMPTY,
    "Mari Golden": Name.MARI_GOLDEN,
    "Phoebe Kinney": Name.PHOEBE_KINNEY
});

enum UserType {
    CLIENT,
    EMPLOYEE
}

final userTypeValues = EnumValues({
    "client": UserType.CLIENT,
    "employee": UserType.EMPLOYEE
});

enum Whatsapp {
    EMPTY,
    NEMO_MOLESTIAE_DOLOR,
    THE_8801757820284,
    THE_8801991631136
}

final whatsappValues = EnumValues({
    "": Whatsapp.EMPTY,
    "Nemo molestiae dolor": Whatsapp.NEMO_MOLESTIAE_DOLOR,
    "8801757820284": Whatsapp.THE_8801757820284,
    "8801991631136": Whatsapp.THE_8801991631136
});

enum ProjectType {
    MONTHLY,
    PROJECT_BASED
}

final projectTypeValues = EnumValues({
    "monthly": ProjectType.MONTHLY,
    "project based": ProjectType.PROJECT_BASED
});

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