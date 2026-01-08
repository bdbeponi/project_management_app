import 'dart:convert';

class InvoiceListResponseModel {
  final int? statusCode;
  final InvoiceData? data;
  final String? message;
  final bool? success;

  InvoiceListResponseModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  InvoiceListResponseModel copyWith({
    int? statusCode,
    InvoiceData? data,
    String? message,
    bool? success,
  }) =>
      InvoiceListResponseModel(
        statusCode: statusCode ?? this.statusCode,
        data: data ?? this.data,
        message: message ?? this.message,
        success: success ?? this.success,
      );

  factory InvoiceListResponseModel.fromRawJson(String str) =>
      InvoiceListResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InvoiceListResponseModel.fromJson(Map<String, dynamic> json) =>
      InvoiceListResponseModel(
        statusCode: json["statusCode"],
        data: json["data"] == null ? null : InvoiceData.fromJson(json["data"]),
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

class InvoiceData {
  final List<InvoiceItem>? items;
  final Meta? meta;

  InvoiceData({
    this.items,
    this.meta,
  });

  InvoiceData copyWith({
    List<InvoiceItem>? items,
    Meta? meta,
  }) =>
      InvoiceData(
        items: items ?? this.items,
        meta: meta ?? this.meta,
      );

  factory InvoiceData.fromRawJson(String str) =>
      InvoiceData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
        items: json["items"] == null
            ? []
            : List<InvoiceItem>.from(
                json["items"]!.map((x) => InvoiceItem.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
      };
}

class InvoiceItem {
  final ClientId? clientId;
  final List<ProjectItem>? projects;
  final DateTime? issueDate;
  final int? totalAmount;
  final String? status;
  final String? notes;
  final String? id;
  final String? invoiceNumber;
  final int? discount;
  final int? tax;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  InvoiceItem({
    this.clientId,
    this.projects,
    this.issueDate,
    this.totalAmount,
    this.status,
    this.notes,
    this.id,
    this.invoiceNumber,
    this.discount,
    this.tax,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  InvoiceItem copyWith({
    ClientId? clientId,
    List<ProjectItem>? projects,
    DateTime? issueDate,
    int? totalAmount,
    String? status,
    String? notes,
    String? id,
    String? invoiceNumber,
    int? discount,
    int? tax,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      InvoiceItem(
        clientId: clientId ?? this.clientId,
        projects: projects ?? this.projects,
        issueDate: issueDate ?? this.issueDate,
        totalAmount: totalAmount ?? this.totalAmount,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        id: id ?? this.id,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        discount: discount ?? this.discount,
        tax: tax ?? this.tax,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory InvoiceItem.fromRawJson(String str) =>
      InvoiceItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
        clientId: json["clientId"] == null
            ? null
            : ClientId.fromJson(json["clientId"]),
        projects: json["projects"] == null
            ? []
            : List<ProjectItem>.from(
                json["projects"]!.map((x) => ProjectItem.fromJson(x))),
        issueDate: json["issueDate"] == null
            ? null
            : DateTime.parse(json["issueDate"]),
        totalAmount: json["totalAmount"],
        status: json["status"],
        notes: json["notes"],
        id: json["_id"],
        invoiceNumber: json["invoiceNumber"],
        discount: json["discount"],
        tax: json["tax"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "clientId": clientId?.toJson(),
        "projects": projects == null
            ? []
            : List<dynamic>.from(projects!.map((x) => x.toJson())),
        "issueDate": issueDate?.toIso8601String(),
        "totalAmount": totalAmount,
        "status": status,
        "notes": notes,
        "_id": id,
        "invoiceNumber": invoiceNumber,
        "discount": discount,
        "tax": tax,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class ClientId {
  final String? id;
  final String? userName;
  final String? email;
  final String? userType;
  final bool? isActive;
  final dynamic image;
  final String? phone;
  final String? whatsapp;
  final String? website;
  final List<SocialClient>? social;
  final List<dynamic>? documents;
  final List<Address>? address;
  final String? password;
  final String? mainPassword;
  final String? permissionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? userCode;
  final int? v;
  final String? refreshToken;
  final String? employeeType;
  final String? salary;

  ClientId({
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
    this.refreshToken,
    this.employeeType,
    this.salary,
  });

  ClientId copyWith({
    String? id,
    String? userName,
    String? email,
    String? userType,
    bool? isActive,
    dynamic image,
    String? phone,
    String? whatsapp,
    String? website,
    List<SocialClient>? social,
    List<dynamic>? documents,
    List<Address>? address,
    String? password,
    String? mainPassword,
    String? permissionId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userCode,
    int? v,
    String? refreshToken,
    String? employeeType,
    String? salary,
  }) =>
      ClientId(
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
        refreshToken: refreshToken ?? this.refreshToken,
        employeeType: employeeType ?? this.employeeType,
        salary: salary ?? this.salary,
      );

  factory ClientId.fromRawJson(String str) =>
      ClientId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClientId.fromJson(Map<String, dynamic> json) => ClientId(
        id: json["_id"],
        userName: json["userName"],
        email: json["email"],
        userType: json["user_type"],
        isActive: json["is_active"],
        image: json["image"],
        phone: json["phone"],
        whatsapp: json["whatsapp"],
        website: json["website"],
        social: json["social"] == null
            ? []
            : List<SocialClient>.from(
                json["social"]!.map((x) => SocialClient.fromJson(x))),
        documents: json["documents"] == null
            ? []
            : List<dynamic>.from(json["documents"]!.map((x) => x)),
        address: json["address"] == null
            ? []
            : List<Address>.from(
                json["address"]!.map((x) => Address.fromJson(x))),
        password: json["password"],
        mainPassword: json["main_password"],
        permissionId: json["permissionId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        userCode: json["user_code"],
        v: json["__v"],
        refreshToken: json["refreshToken"],
        employeeType: json["employee_type"],
        salary: json["salary"],
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
        "social": social == null
            ? []
            : List<dynamic>.from(social!.map((x) => x.toJson())),
        "documents": documents == null
            ? []
            : List<dynamic>.from(documents!.map((x) => x)),
        "address": address == null
            ? []
            : List<dynamic>.from(address!.map((x) => x.toJson())),
        "password": password,
        "main_password": mainPassword,
        "permissionId": permissionId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "user_code": userCode,
        "__v": v,
        "refreshToken": refreshToken,
        "employee_type": employeeType,
        "salary": salary,
      };
}

class SocialClient {
  final String? name;
  final String? link;
  final String? id;

  SocialClient({
    this.name,
    this.link,
    this.id,
  });

  SocialClient copyWith({
    String? name,
    String? link,
    String? id,
  }) =>
      SocialClient(
        name: name ?? this.name,
        link: link ?? this.link,
        id: id ?? this.id,
      );

  factory SocialClient.fromRawJson(String str) =>
      SocialClient.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SocialClient.fromJson(Map<String, dynamic> json) => SocialClient(
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

class ProjectItem {
  final ProjectId? projectId;
  final int? amount;
  final String? id;

  ProjectItem({
    this.projectId,
    this.amount,
    this.id,
  });

  ProjectItem copyWith({
    ProjectId? projectId,
    int? amount,
    String? id,
  }) =>
      ProjectItem(
        projectId: projectId ?? this.projectId,
        amount: amount ?? this.amount,
        id: id ?? this.id,
      );

  factory ProjectItem.fromRawJson(String str) =>
      ProjectItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProjectItem.fromJson(Map<String, dynamic> json) => ProjectItem(
        projectId: json["projectId"] == null
            ? null
            : ProjectId.fromJson(json["projectId"]),
        amount: json["amount"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "projectId": projectId?.toJson(),
        "amount": amount,
        "_id": id,
      };
}

class ProjectId {
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
  final List<SocialProject>? social;
  final List<WorkSheet>? workSheet;
  final String? userId;
  final String? employeeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? code;
  final int? v;

  ProjectId({
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

  ProjectId copyWith({
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
    List<SocialProject>? social,
    List<WorkSheet>? workSheet,
    String? userId,
    String? employeeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? code,
    int? v,
  }) =>
      ProjectId(
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

  factory ProjectId.fromRawJson(String str) =>
      ProjectId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProjectId.fromJson(Map<String, dynamic> json) => ProjectId(
        id: json["_id"],
        name: json["name"],
        agreement: json["agreement"],
        srs: json["srs"],
        projectType: json["project_type"],
        cPaymentStatus: json["c_payment_status"],
        ePaymentStatus: json["e_payment_status"],
        cost: json["cost"],
        isActive: json["is_active"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate: json["end_date"],
        billingDate: json["billing_date"] == null
            ? null
            : DateTime.parse(json["billing_date"]),
        price: json["price"],
        note: json["note"],
        social: json["social"] == null
            ? []
            : List<SocialProject>.from(
                json["social"]!.map((x) => SocialProject.fromJson(x))),
        workSheet: json["work_sheet"] == null
            ? []
            : List<WorkSheet>.from(
                json["work_sheet"]!.map((x) => WorkSheet.fromJson(x))),
        userId: json["userId"],
        employeeId: json["employeeId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
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
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date": endDate,
        "billing_date":
            "${billingDate!.year.toString().padLeft(4, '0')}-${billingDate!.month.toString().padLeft(2, '0')}-${billingDate!.day.toString().padLeft(2, '0')}",
        "price": price,
        "note": note,
        "social": social == null
            ? []
            : List<dynamic>.from(social!.map((x) => x.toJson())),
        "work_sheet": workSheet == null
            ? []
            : List<dynamic>.from(workSheet!.map((x) => x.toJson())),
        "userId": userId,
        "employeeId": employeeId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "code": code,
        "__v": v,
      };
}

class SocialProject {
  final String? name;
  final String? link;
  final String? username;
  final String? password;
  final String? id;

  SocialProject({
    this.name,
    this.link,
    this.username,
    this.password,
    this.id,
  });

  SocialProject copyWith({
    String? name,
    String? link,
    String? username,
    String? password,
    String? id,
  }) =>
      SocialProject(
        name: name ?? this.name,
        link: link ?? this.link,
        username: username ?? this.username,
        password: password ?? this.password,
        id: id ?? this.id,
      );

  factory SocialProject.fromRawJson(String str) =>
      SocialProject.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SocialProject.fromJson(Map<String, dynamic> json) => SocialProject(
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

  factory WorkSheet.fromRawJson(String str) =>
      WorkSheet.fromJson(json.decode(str));

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