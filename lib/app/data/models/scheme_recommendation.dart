class SchemeRecommendation {
  final String id;
  final String title;
  final String description;
  final String ministry;
  final String category;
  final List<String> eligibilityCriteria;
  final List<String> benefits;
  final String applicationProcess;
  final String? websiteUrl;
  final double relevanceScore;
  final List<String> requiredDocuments;
  final String? deadline;
  final bool isActive;

  SchemeRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.ministry,
    required this.category,
    required this.eligibilityCriteria,
    required this.benefits,
    required this.applicationProcess,
    this.websiteUrl,
    required this.relevanceScore,
    required this.requiredDocuments,
    this.deadline,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'ministry': ministry,
      'category': category,
      'eligibilityCriteria': eligibilityCriteria,
      'benefits': benefits,
      'applicationProcess': applicationProcess,
      'websiteUrl': websiteUrl,
      'relevanceScore': relevanceScore,
      'requiredDocuments': requiredDocuments,
      'deadline': deadline,
      'isActive': isActive,
    };
  }

  factory SchemeRecommendation.fromJson(Map<String, dynamic> json) {
    return SchemeRecommendation(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      ministry: json['ministry'] ?? '',
      category: json['category'] ?? '',
      eligibilityCriteria: json['eligibilityCriteria'] != null 
          ? List<String>.from(json['eligibilityCriteria']) 
          : [],
      benefits: json['benefits'] != null 
          ? List<String>.from(json['benefits']) 
          : [],
      applicationProcess: json['applicationProcess'] ?? '',
      websiteUrl: json['websiteUrl'],
      relevanceScore: json['relevanceScore']?.toDouble() ?? 0.0,
      requiredDocuments: json['requiredDocuments'] != null 
          ? List<String>.from(json['requiredDocuments']) 
          : [],
      deadline: json['deadline'],
      isActive: json['isActive'] ?? true,
    );
  }

  factory SchemeRecommendation.fromGeminiResponse(Map<String, dynamic> data) {
    return SchemeRecommendation(
      id: data['scheme_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: data['scheme_name'] ?? data['title'] ?? '',
      description: data['description'] ?? data['overview'] ?? '',
      ministry: data['ministry'] ?? data['department'] ?? '',
      category: data['category'] ?? data['type'] ?? '',
      eligibilityCriteria: _parseListFromString(data['eligibility'] ?? data['eligibility_criteria']),
      benefits: _parseListFromString(data['benefits'] ?? data['scheme_benefits']),
      applicationProcess: data['application_process'] ?? data['how_to_apply'] ?? '',
      websiteUrl: data['website'] ?? data['official_website'],
      relevanceScore: _parseRelevanceScore(data['relevance_score'] ?? data['match_percentage']),
      requiredDocuments: _parseListFromString(data['required_documents'] ?? data['documents_needed']),
      deadline: data['deadline'] ?? data['last_date'],
      isActive: data['is_active'] ?? true,
    );
  }

  static List<String> _parseListFromString(dynamic input) {
    if (input == null) return [];
    if (input is List) return List<String>.from(input);
    if (input is String) {
  
      return input
          .split(RegExp(r'[•\-\*\n]|\d+\.|,'))
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return [];
  }

  static double _parseRelevanceScore(dynamic score) {
    if (score == null) return 0.0;
    if (score is num) return score.toDouble();
    if (score is String) {
    
      final cleaned = score.replaceAll(RegExp(r'[^\d.]'), '');
      final parsed = double.tryParse(cleaned) ?? 0.0;
      return parsed > 1 ? parsed / 100 : parsed;
    }
    return 0.0;
  }

  String get formattedRelevanceScore {
    return '${(relevanceScore * 100).toInt()}%';
  }

  bool get hasDeadline {
    return deadline != null && deadline!.isNotEmpty;
  }

  bool get hasWebsite {
    return websiteUrl != null && websiteUrl!.isNotEmpty;
  }

  String get shortDescription {
    if (description.length <= 100) return description;
    return '${description.substring(0, 100)}...';
  }

  List<String> get topBenefits {
    return benefits.take(3).toList();
  }

  String get eligibilityText {
    if (eligibilityCriteria.isEmpty) return 'No specific criteria mentioned';
    return eligibilityCriteria.join(' • ');
  }

  String get benefitsText {
    if (benefits.isEmpty) return 'Benefits not specified';
    return benefits.join(' • ');
  }

  String get documentsText {
    if (requiredDocuments.isEmpty) return 'Document requirements not specified';
    return requiredDocuments.join(' • ');
  }
}

class SchemeCategory {
  static const String agriculture = 'Agriculture';
  static const String education = 'Education';
  static const String health = 'Health';
  static const String employment = 'Employment';
  static const String housing = 'Housing';
  static const String socialWelfare = 'Social Welfare';
  static const String womenAndChild = 'Women & Child Development';
  static const String rural = 'Rural Development';
  static const String financial = 'Financial Services';
  static const String skill = 'Skill Development';

  static List<String> get all => [
    agriculture,
    education,
    health,
    employment,
    housing,
    socialWelfare,
    womenAndChild,
    rural,
    financial,
    skill,
  ];
}
