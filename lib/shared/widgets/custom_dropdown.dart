import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool required;
  final bool enabled;
  final IconData? prefixIcon;

  const CustomDropdown({
    Key? key,
    required this.label,
    this.hint,
    this.value,
    required this.items,
    required this.itemLabel,
    this.onChanged,
    this.validator,
    this.required = false,
    this.enabled = true,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        
      
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item)),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null 
                ? Icon(prefixIcon) 
                : null,
          ),
          isExpanded: true,
        ),
      ],
    );
  }
}


class GenderDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool required;

  const GenderDropdown({
    Key? key,
    this.value,
    this.onChanged,
    this.validator,
    this.required = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Gender',
      hint: 'Select your gender',
      value: value,
      items: const ['Male', 'Female', 'Other'],
      itemLabel: (item) => item,
      onChanged: onChanged,
      validator: validator ?? (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Gender is required';
        }
        return null;
      },
      required: required,
      prefixIcon: Icons.person_outline,
    );
  }
}

class StateDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool required;

  static const List<String> indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Jammu and Kashmir',
    'Ladakh',
    'Lakshadweep',
    'Puducherry',
  ];

  const StateDropdown({
    Key? key,
    this.value,
    this.onChanged,
    this.validator,
    this.required = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'State/UT',
      hint: 'Select your state',
      value: value,
      items: indianStates,
      itemLabel: (item) => item,
      onChanged: onChanged,
      validator: validator ?? (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'State is required';
        }
        return null;
      },
      required: required,
      prefixIcon: Icons.location_on_outlined,
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool required;

  static const List<String> categories = [
    'General',
    'OBC (Other Backward Class)',
    'SC (Scheduled Caste)',
    'ST (Scheduled Tribe)',
    'EWS (Economically Weaker Section)',
  ];

  const CategoryDropdown({
    Key? key,
    this.value,
    this.onChanged,
    this.validator,
    this.required = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Category',
      hint: 'Select your category',
      value: value,
      items: categories,
      itemLabel: (item) => item,
      onChanged: onChanged,
      validator: validator ?? (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Category is required';
        }
        return null;
      },
      required: required,
      prefixIcon: Icons.category_outlined,
    );
  }
}

class EducationDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool required;

  static const List<String> educationLevels = [
    'No formal education',
    'Primary (1st-5th)',
    'Secondary (6th-10th)',
    'Higher Secondary (11th-12th)',
    'Diploma',
    'Graduate',
    'Post Graduate',
    'PhD/Doctorate',
  ];

  const EducationDropdown({
    Key? key,
    this.value,
    this.onChanged,
    this.validator,
    this.required = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Education Level',
      hint: 'Select your education level',
      value: value,
      items: educationLevels,
      itemLabel: (item) => item,
      onChanged: onChanged,
      validator: validator ?? (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Education level is required';
        }
        return null;
      },
      required: required,
      prefixIcon: Icons.school_outlined,
    );
  }
}

class OccupationDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool required;

  static const List<String> occupations = [
    'Student',
    'Unemployed',
    'Farmer',
    'Agricultural Labourer',
    'Government Employee',
    'Private Employee',
    'Self Employed',
    'Business Owner',
    'Daily Wage Worker',
    'Skilled Worker',
    'Professional',
    'Retired',
    'Homemaker',
    'Other',
  ];

  const OccupationDropdown({
    Key? key,
    this.value,
    this.onChanged,
    this.validator,
    this.required = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Occupation',
      hint: 'Select your occupation',
      value: value,
      items: occupations,
      itemLabel: (item) => item,
      onChanged: onChanged,
      validator: validator ?? (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Occupation is required';
        }
        return null;
      },
      required: required,
      prefixIcon: Icons.work_outline,
    );
  }
}
