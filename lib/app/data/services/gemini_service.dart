import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../models/user_form_data.dart';
import '../models/scheme_recommendation.dart';

class GeminiService extends GetxService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  
  String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';


  bool get isConfigured => _apiKey.isNotEmpty;

  
  Future<List<SchemeRecommendation>> getSchemeRecommendations(UserFormData userData) async {
    if (!isConfigured) {
      throw 'Gemini API key not configured. Please add GEMINI_API_KEY to your .env file.';
    }

    try {
      final prompt = _buildPrompt(userData);
      final response = await _callGeminiAPI(prompt);
      return _parseRecommendations(response);
    } catch (e) {
      throw 'Failed to get scheme recommendations: ${e.toString()}';
    }
  }

  String _buildPrompt(UserFormData userData) {
    return '''
You are an expert on Indian government schemes and welfare programs. Analyze the following user profile and recommend the most relevant and beneficial government schemes they are eligible for.

${userData.toPromptString()}

Please provide 5-10 most relevant government scheme recommendations in the following JSON format:

{
  "recommendations": [
    {
      "scheme_name": "Name of the scheme",
      "description": "Brief description of the scheme (2-3 sentences)",
      "ministry": "Ministry/Department name",
      "category": "Category (Agriculture/Education/Health/Employment/Housing/Social Welfare/Women & Child Development/Rural Development/Financial Services/Skill Development)",
      "eligibility": [
        "Eligibility criterion 1",
        "Eligibility criterion 2"
      ],
      "benefits": [
        "Benefit 1",
        "Benefit 2"
      ],
      "application_process": "How to apply for this scheme",
      "required_documents": [
        "Document 1",
        "Document 2"
      ],
      "website": "Official website URL (if available)",
      "relevance_score": 0.95,
      "deadline": "Application deadline (if any)"
    }
  ]
}

Focus on:
1. Current and active government schemes
2. Schemes specifically relevant to the user's profile
3. Both central and state government schemes
4. Include schemes from multiple categories if applicable
5. Prioritize schemes with higher eligibility match
6. Include accurate and up-to-date information

Ensure all scheme names and details are accurate. If you're not certain about specific details, mention "Please verify details on official website" in the description.
''';
  }


  Future<String> _callGeminiAPI(String prompt) async {
    print('🔄 Calling Gemini API with model: gemini-1.5-flash');
    final url = Uri.parse('$_baseUrl?key=$_apiKey');
    
    final body = json.encode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'topK': 40,
        'topP': 0.95,
        'maxOutputTokens': 8192,
      },
      'safetySettings': [
        {
          'category': 'HARM_CATEGORY_HARASSMENT',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
        },
        {
          'category': 'HARM_CATEGORY_HATE_SPEECH',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
        },
        {
          'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
        },
        {
          'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
        }
      ]
    });

    print('🔄 Making HTTP POST request to: $url');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print('📊 Gemini API Response Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      print('✅ Gemini API call successful');
      final data = json.decode(response.body);
      
      if (data['candidates'] != null && 
          data['candidates'].isNotEmpty &&
          data['candidates'][0]['content'] != null &&
          data['candidates'][0]['content']['parts'] != null &&
          data['candidates'][0]['content']['parts'].isNotEmpty) {
        
        final result = data['candidates'][0]['content']['parts'][0]['text'];
        print('✅ Successfully extracted text response from Gemini');
        return result;
      } else {
        print('❌ Invalid response format from Gemini API');
        print('Response data: ${response.body}');
        throw 'Invalid response format from Gemini API';
      }
    } else {
      print('❌ Gemini API error (${response.statusCode}): ${response.body}');
      final errorData = json.decode(response.body);
      final errorMessage = errorData['error']?['message'] ?? 'Unknown error';
      throw 'Gemini API error (${response.statusCode}): $errorMessage';
    }
  }

  
  List<SchemeRecommendation> _parseRecommendations(String response) {
    try {

      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(response);
      if (jsonMatch == null) {
        throw 'No JSON found in response';
      }

      final jsonString = jsonMatch.group(0)!;
      final data = json.decode(jsonString);
      
      if (data['recommendations'] == null) {
        throw 'No recommendations found in response';
      }

      final List<dynamic> recommendationsData = data['recommendations'];
      
      return recommendationsData.map((item) {
        try {
          return SchemeRecommendation.fromGeminiResponse(item);
        } catch (e) {
          print('Error parsing recommendation: $e');
          print('Item data: $item');
        
          return SchemeRecommendation(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: item['scheme_name'] ?? 'Unknown Scheme',
            description: item['description'] ?? 'Description not available',
            ministry: item['ministry'] ?? 'Ministry not specified',
            category: item['category'] ?? 'General',
            eligibilityCriteria: [],
            benefits: [],
            applicationProcess: item['application_process'] ?? 'Please check official website',
            relevanceScore: 0.5,
            requiredDocuments: [],
          );
        }
      }).toList();
    } catch (e) {
      throw 'Failed to parse recommendations: ${e.toString()}';
    }
  }


  Future<SchemeRecommendation> getSchemeDetails(String schemeName) async {
    if (!isConfigured) {
      throw 'Gemini API key not configured';
    }

    final prompt = '''
Provide detailed information about the Indian government scheme: "$schemeName"

Please provide comprehensive details in the following JSON format:

{
  "scheme_name": "$schemeName",
  "description": "Detailed description of the scheme",
  "ministry": "Ministry/Department name",
  "category": "Category",
  "eligibility": ["Detailed eligibility criteria"],
  "benefits": ["All benefits and assistance provided"],
  "application_process": "Complete step-by-step application process",
  "required_documents": ["Complete list of required documents"],
  "website": "Official website URL",
  "helpline": "Helpline number (if available)",
  "last_date": "Application deadline (if any)",
  "budget_allocation": "Budget information (if available)"
}

Ensure all information is accurate and up-to-date.
''';

    try {
      final response = await _callGeminiAPI(prompt);
      final recommendations = _parseRecommendations('{"recommendations": [$response]}');
      return recommendations.first;
    } catch (e) {
      throw 'Failed to get scheme details: ${e.toString()}';
    }
  }


  Future<bool> testConnection() async {
    if (!isConfigured) return false;

    try {
      final testPrompt = 'Hello, this is a test. Please respond with "API connection successful".';
      final response = await _callGeminiAPI(testPrompt);
      return response.toLowerCase().contains('successful');
    } catch (e) {
      print('API test failed: $e');
      return false;
    }
  }


  Future<List<String>> getSchemeSuggestions(String keyword) async {
    if (!isConfigured) return [];

    final prompt = '''
List 10 Indian government schemes related to "$keyword". 
Provide only the scheme names, one per line, without any additional text or formatting.
''';

    try {
      final response = await _callGeminiAPI(prompt);
      return response
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .take(10)
          .toList();
    } catch (e) {
      print('Failed to get scheme suggestions: $e');
      return [];
    }
  }
}
