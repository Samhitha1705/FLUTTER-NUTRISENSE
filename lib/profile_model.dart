// profile_model.dart

class ProfileModel {
  // Basic Info
  String name;
  int age;
  String gender;
  String email;
  String phone;

  // Physical Info
  String bloodGroup;
  double height; // cm
  double weight; // kg

  // Medical Sections
  List<MedicalCondition> medicalConditions;
  List<Allergy> allergies;
  List<Medication> medications;
  List<Surgery> surgeries;
  List<FamilyHistory> familyHistory;
  List<Vaccination> vaccinations;

  Lifestyle lifestyle;
  WomenHealth? womenHealth;
  MenHealth? menHealth;

  ProfileModel({
    required this.name,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.medicalConditions,
    required this.allergies,
    required this.medications,
    required this.surgeries,
    required this.familyHistory,
    required this.vaccinations,
    required this.lifestyle,
    this.womenHealth,
    this.menHealth,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "age": age,
      "gender": gender,
      "email": email,
      "phone": phone,
      "bloodGroup": bloodGroup,
      "height": height,
      "weight": weight,
      "medicalConditions":
      medicalConditions.map((e) => e.toJson()).toList(),
      "allergies": allergies.map((e) => e.toJson()).toList(),
      "medications": medications.map((e) => e.toJson()).toList(),
      "surgeries": surgeries.map((e) => e.toJson()).toList(),
      "familyHistory": familyHistory.map((e) => e.toJson()).toList(),
      "vaccinations": vaccinations.map((e) => e.toJson()).toList(),
      "lifestyle": lifestyle.toJson(),
      "womenHealth": womenHealth?.toJson(),
      "menHealth": menHealth?.toJson(),
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json["name"],
      age: json["age"],
      gender: json["gender"],
      email: json["email"],
      phone: json["phone"],
      bloodGroup: json["bloodGroup"],
      height: (json["height"] as num).toDouble(),
      weight: (json["weight"] as num).toDouble(),
      medicalConditions: (json["medicalConditions"] as List)
          .map((e) => MedicalCondition.fromJson(e))
          .toList(),
      allergies: (json["allergies"] as List)
          .map((e) => Allergy.fromJson(e))
          .toList(),
      medications: (json["medications"] as List)
          .map((e) => Medication.fromJson(e))
          .toList(),
      surgeries: (json["surgeries"] as List)
          .map((e) => Surgery.fromJson(e))
          .toList(),
      familyHistory: (json["familyHistory"] as List)
          .map((e) => FamilyHistory.fromJson(e))
          .toList(),
      vaccinations: (json["vaccinations"] as List)
          .map((e) => Vaccination.fromJson(e))
          .toList(),
      lifestyle: Lifestyle.fromJson(json["lifestyle"]),
      womenHealth: json["womenHealth"] != null
          ? WomenHealth.fromJson(json["womenHealth"])
          : null,
      menHealth: json["menHealth"] != null
          ? MenHealth.fromJson(json["menHealth"])
          : null,
    );
  }
}

/////////////////////
// SUB MODELS
/////////////////////

class MedicalCondition {
  String name;
  String diagnosedYear;
  String notes;

  MedicalCondition({
    required this.name,
    required this.diagnosedYear,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "diagnosedYear": diagnosedYear,
    "notes": notes,
  };

  factory MedicalCondition.fromJson(Map<String, dynamic> json) =>
      MedicalCondition(
        name: json["name"],
        diagnosedYear: json["diagnosedYear"],
        notes: json["notes"],
      );
}

class Allergy {
  String type; // Food / Drug / Environmental
  String name;
  String severity; // Mild / Moderate / Severe
  String reaction;

  Allergy({
    required this.type,
    required this.name,
    required this.severity,
    required this.reaction,
  });

  Map<String, dynamic> toJson() => {
    "type": type,
    "name": name,
    "severity": severity,
    "reaction": reaction,
  };

  factory Allergy.fromJson(Map<String, dynamic> json) =>
      Allergy(
        type: json["type"],
        name: json["name"],
        severity: json["severity"],
        reaction: json["reaction"],
      );
}

class Medication {
  String name;
  String dosage;
  String frequency;
  String prescribedFor;

  Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.prescribedFor,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "dosage": dosage,
    "frequency": frequency,
    "prescribedFor": prescribedFor,
  };

  factory Medication.fromJson(Map<String, dynamic> json) =>
      Medication(
        name: json["name"],
        dosage: json["dosage"],
        frequency: json["frequency"],
        prescribedFor: json["prescribedFor"],
      );
}

class Surgery {
  String name;
  String year;
  String hospital;

  Surgery({
    required this.name,
    required this.year,
    required this.hospital,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "year": year,
    "hospital": hospital,
  };

  factory Surgery.fromJson(Map<String, dynamic> json) =>
      Surgery(
        name: json["name"],
        year: json["year"],
        hospital: json["hospital"],
      );
}

class FamilyHistory {
  String condition;
  String relation;

  FamilyHistory({
    required this.condition,
    required this.relation,
  });

  Map<String, dynamic> toJson() => {
    "condition": condition,
    "relation": relation,
  };

  factory FamilyHistory.fromJson(Map<String, dynamic> json) =>
      FamilyHistory(
        condition: json["condition"],
        relation: json["relation"],
      );
}

class Vaccination {
  String vaccineName;
  String year;

  Vaccination({
    required this.vaccineName,
    required this.year,
  });

  Map<String, dynamic> toJson() => {
    "vaccineName": vaccineName,
    "year": year,
  };

  factory Vaccination.fromJson(Map<String, dynamic> json) =>
      Vaccination(
        vaccineName: json["vaccineName"],
        year: json["year"],
      );
}

class Lifestyle {
  bool smoking;
  bool alcohol;
  bool exercise;
  String dietType;

  Lifestyle({
    required this.smoking,
    required this.alcohol,
    required this.exercise,
    required this.dietType,
  });

  Map<String, dynamic> toJson() => {
    "smoking": smoking,
    "alcohol": alcohol,
    "exercise": exercise,
    "dietType": dietType,
  };

  factory Lifestyle.fromJson(Map<String, dynamic> json) =>
      Lifestyle(
        smoking: json["smoking"],
        alcohol: json["alcohol"],
        exercise: json["exercise"],
        dietType: json["dietType"],
      );
}

class WomenHealth {
  bool pregnant;
  String lastPeriodDate;
  bool menopause;

  WomenHealth({
    required this.pregnant,
    required this.lastPeriodDate,
    required this.menopause,
  });

  Map<String, dynamic> toJson() => {
    "pregnant": pregnant,
    "lastPeriodDate": lastPeriodDate,
    "menopause": menopause,
  };

  factory WomenHealth.fromJson(Map<String, dynamic> json) =>
      WomenHealth(
        pregnant: json["pregnant"],
        lastPeriodDate: json["lastPeriodDate"],
        menopause: json["menopause"],
      );
}

class MenHealth {
  bool prostateIssues;

  MenHealth({
    required this.prostateIssues,
  });

  Map<String, dynamic> toJson() => {
    "prostateIssues": prostateIssues,
  };

  factory MenHealth.fromJson(Map<String, dynamic> json) =>
      MenHealth(
        prostateIssues: json["prostateIssues"],
      );
}