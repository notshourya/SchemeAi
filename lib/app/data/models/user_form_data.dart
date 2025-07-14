class UserFormData {
  final String? name;
  final int? age;
  final String? gender;
  final String? occupation;
  final double? annualIncome;
  final String? state;
  final String? district;
  final String? category; 
  final bool? isBelowPovertyLine;
  final String? educationLevel;
  final bool? isMarried;
  final int? numberOfChildren;
  final bool? hasDisability;
  final String? landOwnership; 
  final List<String>? interests; 

  UserFormData({
    this.name,
    this.age,
    this.gender,
    this.occupation,
    this.annualIncome,
    this.state,
    this.district,
    this.category,
    this.isBelowPovertyLine,
    this.educationLevel,
    this.isMarried,
    this.numberOfChildren,
    this.hasDisability,
    this.landOwnership,
    this.interests,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'occupation': occupation,
      'annualIncome': annualIncome,
      'state': state,
      'district': district,
      'category': category,
      'isBelowPovertyLine': isBelowPovertyLine,
      'educationLevel': educationLevel,
      'isMarried': isMarried,
      'numberOfChildren': numberOfChildren,
      'hasDisability': hasDisability,
      'landOwnership': landOwnership,
      'interests': interests,
    };
  }

  factory UserFormData.fromJson(Map<String, dynamic> json) {
    return UserFormData(
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      occupation: json['occupation'],
      annualIncome: json['annualIncome']?.toDouble(),
      state: json['state'],
      district: json['district'],
      category: json['category'],
      isBelowPovertyLine: json['isBelowPovertyLine'],
      educationLevel: json['educationLevel'],
      isMarried: json['isMarried'],
      numberOfChildren: json['numberOfChildren'],
      hasDisability: json['hasDisability'],
      landOwnership: json['landOwnership'],
      interests: json['interests'] != null 
          ? List<String>.from(json['interests']) 
          : null,
    );
  }

  UserFormData copyWith({
    String? name,
    int? age,
    String? gender,
    String? occupation,
    double? annualIncome,
    String? state,
    String? district,
    String? category,
    bool? isBelowPovertyLine,
    String? educationLevel,
    bool? isMarried,
    int? numberOfChildren,
    bool? hasDisability,
    String? landOwnership,
    List<String>? interests,
  }) {
    return UserFormData(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      annualIncome: annualIncome ?? this.annualIncome,
      state: state ?? this.state,
      district: district ?? this.district,
      category: category ?? this.category,
      isBelowPovertyLine: isBelowPovertyLine ?? this.isBelowPovertyLine,
      educationLevel: educationLevel ?? this.educationLevel,
      isMarried: isMarried ?? this.isMarried,
      numberOfChildren: numberOfChildren ?? this.numberOfChildren,
      hasDisability: hasDisability ?? this.hasDisability,
      landOwnership: landOwnership ?? this.landOwnership,
      interests: interests ?? this.interests,
    );
  }

  bool get isComplete {
    return name != null && 
           age != null && 
           gender != null && 
           occupation != null && 
           annualIncome != null && 
           state != null && 
           category != null;
  }

  String toPromptString() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln('User Profile:');
    if (name != null) buffer.writeln('Name: $name');
    if (age != null) buffer.writeln('Age: $age years');
    if (gender != null) buffer.writeln('Gender: $gender');
    if (occupation != null) buffer.writeln('Occupation: $occupation');
    if (annualIncome != null) buffer.writeln('Annual Income: ₹$annualIncome');
    if (state != null) buffer.writeln('State: $state');
    if (district != null) buffer.writeln('District: $district');
    if (category != null) buffer.writeln('Category: $category');
    if (isBelowPovertyLine != null) {
      buffer.writeln('Below Poverty Line: ${isBelowPovertyLine! ? "Yes" : "No"}');
    }
    if (educationLevel != null) buffer.writeln('Education: $educationLevel');
    if (isMarried != null) {
      buffer.writeln('Marital Status: ${isMarried! ? "Married" : "Unmarried"}');
    }
    if (numberOfChildren != null) buffer.writeln('Number of Children: $numberOfChildren');
    if (hasDisability != null) {
      buffer.writeln('Has Disability: ${hasDisability! ? "Yes" : "No"}');
    }
    if (landOwnership != null) buffer.writeln('Land Ownership: $landOwnership');
    if (interests != null && interests!.isNotEmpty) {
      buffer.writeln('Areas of Interest: ${interests!.join(", ")}');
    }
    
    return buffer.toString();
  }
}
