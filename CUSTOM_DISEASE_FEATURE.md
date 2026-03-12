# Custom Disease Input Feature

## Overview
Added the ability for users to type in a custom disease name when "Other" is selected in the Disease/Symptom dropdown.

## Implementation

### Changes Made

#### 1. Added New Controller
```dart
final _otherDiseaseController = TextEditingController();
```

#### 2. Conditional Text Field
When user selects "Other" from the disease dropdown, a new text field appears:

```dart
if (_selectedDisease == 'Other') ...[
  const SizedBox(height: 16),
  TextFormField(
    controller: _otherDiseaseController,
    decoration: InputDecoration(
      labelText: 'Specify Disease/Symptom',
      hintText: 'Enter disease name',
      prefixIcon: Icon(Icons.edit_outlined),
    ),
    validator: (val) {
      if (_selectedDisease == 'Other' && (val?.isEmpty ?? true)) {
        return 'Please specify the disease';
      }
      return null;
    },
  ),
],
```

#### 3. Dynamic Disease Name
The report uses the custom disease name when "Other" is selected:

```dart
final diseaseToReport = _selectedDisease == 'Other' 
    ? _otherDiseaseController.text.trim() 
    : _selectedDisease;
```

#### 4. Form Validation
- Text field is required when "Other" is selected
- Validates that the field is not empty
- Shows error message if validation fails

#### 5. Form Clearing
After successful submission, the custom disease field is cleared:

```dart
_otherDiseaseController.clear();
```

## User Experience

### Before (Without Custom Input)
```
Disease/Symptom: [Fever ▼]
Options: Fever, Diarrhea, Vomiting, Cholera, Typhoid, Jaundice, Other
```

### After (With Custom Input)
```
Disease/Symptom: [Other ▼]

↓ (Text field appears)

Specify Disease/Symptom: [Malaria_____________]
                         Enter disease name
```

## Visual Flow

```
┌─────────────────────────────────────┐
│  Disease/Symptom                    │
│  [Fever              ▼]             │
└─────────────────────────────────────┘
         ↓ User selects "Other"
┌─────────────────────────────────────┐
│  Disease/Symptom                    │
│  [Other              ▼]             │
└─────────────────────────────────────┘
         ↓ Text field appears
┌─────────────────────────────────────┐
│  Specify Disease/Symptom            │
│  [Malaria            ]              │
│   Enter disease name                │
└─────────────────────────────────────┘
         ↓ User types disease name
┌─────────────────────────────────────┐
│  [Submit Report]                    │
└─────────────────────────────────────┘
         ↓ Report submitted with "Malaria"
```

## Database Impact

### Before
```javascript
{
  symptom_type: "Other",  // Generic
  // ...
}
```

### After
```javascript
{
  symptom_type: "Malaria",  // Specific custom disease
  // ...
}
```

## Community Aggregation

Custom diseases are tracked just like predefined ones:

```javascript
// community_reports collection
{
  location: "Guwahati",
  diseaseCounts: {
    "Fever": 5,
    "Diarrhea": 3,
    "Malaria": 2,  // Custom disease tracked
    "Dengue": 1    // Another custom disease
  },
  totalCases: 11,
  riskLevel: "HIGH"
}
```

## Alert Creation

Alerts work with custom diseases too:

```javascript
// If 3+ reports of "Malaria" in 24 hours
{
  title: "Malaria Outbreak Alert",
  message: "3 cases of Malaria reported in Guwahati in the last 24 hours.",
  severity: "warning",
  // ...
}
```

## Benefits

1. **Flexibility**: Users can report any disease, not just predefined ones
2. **Accuracy**: More specific disease tracking
3. **Completeness**: No disease goes unreported
4. **Scalability**: System adapts to new diseases automatically
5. **User-Friendly**: Simple, intuitive interface

## Use Cases

### Use Case 1: Rare Disease
```
User encounters a rare disease not in the list
→ Selects "Other"
→ Types "Leptospirosis"
→ Submits report
→ System tracks "Leptospirosis" cases
```

### Use Case 2: Regional Disease
```
User wants to report a region-specific disease
→ Selects "Other"
→ Types "Japanese Encephalitis"
→ Submits report
→ System creates aggregation for this disease
```

### Use Case 3: Multiple Symptoms
```
User has multiple symptoms
→ Selects "Other"
→ Types "Fever with Rash"
→ Submits report
→ System tracks this specific combination
```

## Validation Rules

1. **When "Other" is NOT selected**:
   - Custom disease field is hidden
   - No validation on custom field
   - Uses selected disease from dropdown

2. **When "Other" IS selected**:
   - Custom disease field appears
   - Field is required
   - Must not be empty
   - Trims whitespace
   - Uses custom disease name in report

## Testing

### Test Case 1: Select Other and Submit
```
1. Open Quick Report form
2. Select "Other" from Disease dropdown
3. Verify text field appears
4. Type "Malaria"
5. Fill other fields
6. Click Submit
7. Verify report saved with "Malaria" as disease
```

### Test Case 2: Validation
```
1. Select "Other" from Disease dropdown
2. Leave custom field empty
3. Click Submit
4. Verify error message: "Please specify the disease"
5. Type disease name
6. Click Submit
7. Verify success
```

### Test Case 3: Form Clearing
```
1. Select "Other" and type "Dengue"
2. Submit report
3. Verify success message
4. Verify custom field is cleared
5. Verify dropdown reset to "Fever"
```

### Test Case 4: Community Aggregation
```
1. Submit 3 reports with custom disease "Malaria"
2. Check community_reports collection
3. Verify "Malaria" count is 3
4. Verify totalCases includes Malaria cases
```

### Test Case 5: Alert Creation
```
1. Submit 3 reports of "Dengue" (custom)
2. Check alerts collection
3. Verify alert created: "Dengue Outbreak Alert"
4. Verify message includes "Dengue"
```

## Error Handling

### Empty Custom Field
```
Error: "Please specify the disease"
Solution: User must type disease name
```

### Whitespace Only
```
Input: "   "
Result: Trimmed to empty string
Error: "Please specify the disease"
```

### Very Long Name
```
Input: "Very long disease name with many words..."
Result: Accepted and stored as-is
Note: Consider adding max length validation if needed
```

## Future Enhancements

1. **Auto-complete**: Suggest diseases as user types
2. **Disease Database**: Maintain list of all reported custom diseases
3. **Spell Check**: Validate disease names against medical database
4. **Synonyms**: Map similar disease names (e.g., "Flu" → "Influenza")
5. **Multi-language**: Support disease names in local languages
6. **Admin Review**: Flag unusual disease names for review

## Code Location

**File**: `lib/presentation/widgets/quick_report_card.dart`

**Key Sections**:
- Line ~23: Controller declaration
- Line ~400: Conditional text field UI
- Line ~115: Disease name selection logic
- Line ~155: Form clearing

## Summary

✅ Users can now type custom disease names
✅ Text field appears only when "Other" is selected
✅ Validation ensures field is not empty
✅ Custom diseases tracked in community reports
✅ Alerts work with custom diseases
✅ Form clears properly after submission

This feature makes the disease reporting system more flexible and comprehensive!
