class VaccinesModel {
  final String message;
  final Child child;

  VaccinesModel({required this.message, required this.child});

  factory VaccinesModel.fromJson(Map<String, dynamic> json) {
    return VaccinesModel(
      message: json['message'],
      child: Child.fromJson(json['child']),
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'child': child.toJson(),
  };
}

class Child {
  final int id;
  final int userId;
  final String childName;
  final String gender;
  final String birthDate;
  final String createdAt;
  final String updatedAt;
  final List<Vaccine> vaccines;

  Child({
    required this.id,
    required this.userId,
    required this.childName,
    required this.gender,
    required this.birthDate,
    required this.createdAt,
    required this.updatedAt,
    required this.vaccines,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
    id: json['id'],
    userId: json['user_id'],
    childName: json['child_name'],
    gender: json['gender'],
    birthDate: json['birth_date'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    vaccines:
        (json['vaccines'] as List<dynamic>)
            .map((e) => Vaccine.fromJson(e))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'child_name': childName,
    'gender': gender,
    'birth_date': birthDate,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'vaccines': vaccines.map((v) => v.toJson()).toList(),
  };
}

class Vaccine {
  final int id;
  final int childId;
  final String vaccineName;
  final String description;
  final String scheduledDate;
  final bool isCompleted;
  final String createdAt;
  final String updatedAt;

  Vaccine({
    required this.id,
    required this.childId,
    required this.vaccineName,
    required this.description,
    required this.scheduledDate,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vaccine.fromJson(Map<String, dynamic> json) => Vaccine(
    id: json['id'],
    childId: json['child_id'],
    vaccineName: json['vaccine_name'],
    description: json['description'],
    scheduledDate: json['scheduled_date'],
    isCompleted: json['is_completed'] == 1 || json['is_completed'] == true,
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'child_id': childId,
    'vaccine_name': vaccineName,
    'description': description,
    'scheduled_date': scheduledDate,
    'is_completed': isCompleted ? 1 : 0,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

class ChildrenResponse {
  final String message;
  final List<Child> children;

  ChildrenResponse({required this.message, required this.children});

  factory ChildrenResponse.fromJson(Map<String, dynamic> json) =>
      ChildrenResponse(
        message: json['message'],
        children:
            (json['children'] as List<dynamic>)
                .map((c) => Child.fromJson(c))
                .toList(),
      );

  Map<String, dynamic> toJson() => {
    'message': message,
    'children': children.map((c) => c.toJson()).toList(),
  };

  ChildrenResponse copyWith({String? message, List<Child>? children}) {
    return ChildrenResponse(
      message: message ?? this.message,
      children: children ?? this.children,
    );
  }
}

//-----------------------------------------

class FullVaccinesModel {
  final int id;
  final int childId;
  final String vaccineName;
  final String description;
  final String scheduledDate;
  final int isCompleted;
  final String createdAt;
  final String updatedAt;

  FullVaccinesModel({
    required this.id,
    required this.childId,
    required this.vaccineName,
    required this.description,
    required this.scheduledDate,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FullVaccinesModel.fromJson(Map<String, dynamic> json) {
    return FullVaccinesModel(
      id: json['id'],
      childId: json['child_id'],
      vaccineName: json['vaccine_name'],
      description: json['description'],
      scheduledDate: json['scheduled_date'],
      isCompleted: json['is_completed'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'child_id': childId,
      'vaccine_name': vaccineName,
      'description': description,
      'scheduled_date': scheduledDate,
      'is_completed': isCompleted,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

//------------------------

class CompletedVaccines {
  final String message;
  final Vaccine vaccine;

  CompletedVaccines({required this.message, required this.vaccine});

  factory CompletedVaccines.fromJson(Map<String, dynamic> json) {
    return CompletedVaccines(
      message: json['message'],
      vaccine: Vaccine.fromJson(json['vaccine']),
    );
  }
}

////////////////////////
