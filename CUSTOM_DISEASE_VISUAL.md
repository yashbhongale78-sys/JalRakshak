# Custom Disease Input - Visual Guide

## Before and After Comparison

### Before: Standard Disease Selection
```
┌─────────────────────────────────────┐
│  ➕ Quick Report                    │
├─────────────────────────────────────┤
│                                     │
│  👤 Name                            │
│  [John Doe              ]           │
│                                     │
│  📍 Location                        │
│  [Guwahati, Kamrup      ]           │
│                                     │
│  🏥 Disease/Symptom                 │
│  [Fever                ▼]           │
│   • Fever                           │
│   • Diarrhea                        │
│   • Vomiting                        │
│   • Cholera                         │
│   • Typhoid                         │
│   • Jaundice                        │
│   • Other                           │
│                                     │
│  ⚠️  Caused By                      │
│  [Contaminated Water   ▼]           │
│                                     │
└─────────────────────────────────────┘
```

### After: "Other" Selected - Custom Input Appears
```
┌─────────────────────────────────────┐
│  ➕ Quick Report                    │
├─────────────────────────────────────┤
│                                     │
│  👤 Name                            │
│  [John Doe              ]           │
│                                     │
│  📍 Location                        │
│  [Guwahati, Kamrup      ]           │
│                                     │
│  🏥 Disease/Symptom                 │
│  [Other                ▼]           │
│                                     │
│  ✏️  Specify Disease/Symptom        │
│  [Malaria              ]            │
│   Enter disease name                │
│                                     │
│  ⚠️  Caused By                      │
│  [Contaminated Water   ▼]           │
│                                     │
└─────────────────────────────────────┘
```

## Step-by-Step User Flow

### Step 1: User Opens Form
```
┌─────────────────────────────────────┐
│  🏥 Disease/Symptom                 │
│  [Fever                ▼]           │
│                                     │
│  Default: Fever selected            │
│  No custom field visible            │
└─────────────────────────────────────┘
```

### Step 2: User Clicks Dropdown
```
┌─────────────────────────────────────┐
│  🏥 Disease/Symptom                 │
│  [Fever                ▼]           │
│  ┌─────────────────────────────┐   │
│  │ ✓ Fever                     │   │
│  │   Diarrhea                  │   │
│  │   Vomiting                  │   │
│  │   Skin Rash                 │   │
│  │   Cholera                   │   │
│  │   Typhoid                   │   │
│  │   Jaundice                  │   │
│  │   Other                     │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

### Step 3: User Selects "Other"
```
┌─────────────────────────────────────┐
│  🏥 Disease/Symptom                 │
│  [Other                ▼]           │
│                                     │
│  ⚡ Text field appears below!       │
└─────────────────────────────────────┘
```

### Step 4: Custom Field Appears
```
┌─────────────────────────────────────┐
│  🏥 Disease/Symptom                 │
│  [Other                ▼]           │
│                                     │
│  ✏️  Specify Disease/Symptom        │
│  [                     ]            │
│   Enter disease name                │
│                                     │
│  ← Cursor blinking, ready for input│
└─────────────────────────────────────┘
```

### Step 5: User Types Disease Name
```
┌─────────────────────────────────────┐
│  🏥 Disease/Symptom                 │
│  [Other                ▼]           │
│                                     │
│  ✏️  Specify Disease/Symptom        │
│  [Malaria|             ]            │
│   Enter disease name                │
│                                     │
│  ✓ Valid input                      │
└─────────────────────────────────────┘
```

### Step 6: User Submits Form
```
┌─────────────────────────────────────┐
│  [Submit Report]                    │
│                                     │
│  ⏳ Submitting...                   │
└─────────────────────────────────────┘
```

### Step 7: Success & Form Reset
```
┌─────────────────────────────────────┐
│  ✅ Report submitted successfully!  │
│                                     │
│  🏥 Disease/Symptom                 │
│  [Fever                ▼]           │
│                                     │
│  Custom field hidden again          │
│  Ready for next report              │
└─────────────────────────────────────┘
```

## Validation States

### Valid State
```
┌─────────────────────────────────────┐
│  ✏️  Specify Disease/Symptom        │
│  [Dengue               ]            │
│   Enter disease name                │
│                                     │
│  ✓ Valid                            │
└─────────────────────────────────────┘
```

### Empty State (Error)
```
┌─────────────────────────────────────┐
│  ✏️  Specify Disease/Symptom        │
│  [                     ]            │
│   Enter disease name                │
│                                     │
│  ❌ Please specify the disease      │
└─────────────────────────────────────┘
```

### Filled State
```
┌─────────────────────────────────────┐
│  ✏️  Specify Disease/Symptom        │
│  [Japanese Encephalitis]            │
│   Enter disease name                │
│                                     │
│  ✓ Valid                            │
└─────────────────────────────────────┘
```

## Real-World Examples

### Example 1: Malaria Report
```
User Input:
┌─────────────────────────────────────┐
│  Disease: [Other ▼]                 │
│  Specify: [Malaria]                 │
└─────────────────────────────────────┘

Database Entry:
{
  symptom_type: "Malaria",
  severity: "High",
  ...
}

Community Report:
{
  diseaseCounts: {
    "Malaria": 1
  }
}
```

### Example 2: Dengue Report
```
User Input:
┌─────────────────────────────────────┐
│  Disease: [Other ▼]                 │
│  Specify: [Dengue]                  │
└─────────────────────────────────────┘

Database Entry:
{
  symptom_type: "Dengue",
  severity: "High",
  ...
}

Alert (if 3+ cases):
{
  title: "Dengue Outbreak Alert",
  message: "3 cases of Dengue..."
}
```

### Example 3: Multiple Symptoms
```
User Input:
┌─────────────────────────────────────┐
│  Disease: [Other ▼]                 │
│  Specify: [Fever with Rash]         │
└─────────────────────────────────────┘

Database Entry:
{
  symptom_type: "Fever with Rash",
  severity: "Medium",
  ...
}
```

## Mobile View

### Portrait Mode
```
┌──────────────┐
│  Disease     │
│  [Other ▼]   │
│              │
│  Specify     │
│  [Malaria ]  │
│              │
│  Caused By   │
│  [Water  ▼]  │
│              │
│  [Submit]    │
└──────────────┘
```

### Landscape Mode
```
┌────────────────────────────────┐
│  Disease: [Other ▼]            │
│  Specify: [Malaria        ]    │
│  Caused:  [Water         ▼]    │
│           [Submit Report]      │
└────────────────────────────────┘
```

## Interaction States

### 1. Idle State
```
Disease: [Fever ▼]
Custom field: Hidden
```

### 2. Dropdown Open
```
Disease: [Fever ▼]
         ┌─────────┐
         │ Fever   │
         │ Other   │
         └─────────┘
Custom field: Hidden
```

### 3. Other Selected
```
Disease: [Other ▼]
Custom field: Visible (empty)
```

### 4. Typing
```
Disease: [Other ▼]
Custom field: [Mal|aria]
```

### 5. Submitted
```
Disease: [Fever ▼]
Custom field: Hidden (cleared)
```

## Color Coding

```
Normal State:
┌─────────────────────────────────────┐
│  ✏️  Specify Disease/Symptom        │
│  [                     ]            │
│   Enter disease name                │
└─────────────────────────────────────┘
Background: Dark (#1E293B)
Border: None
Text: Light (#F8FAFC)

Error State:
┌─────────────────────────────────────┐
│  ✏️  Specify Disease/Symptom        │
│  [                     ]            │
│  ❌ Please specify the disease      │
└─────────────────────────────────────┘
Background: Dark (#1E293B)
Border: Red (#F44336)
Error Text: Red (#F44336)

Focused State:
┌─────────────────────────────────────┐
│  ✏️  Specify Disease/Symptom        │
│  [Malaria|             ]            │
│   Enter disease name                │
└─────────────────────────────────────┘
Background: Dark (#1E293B)
Border: Blue (#2196F3)
Text: Light (#F8FAFC)
```

## Accessibility

### Screen Reader Announcement
```
"Disease/Symptom dropdown, Fever selected"
→ User selects Other
"Disease/Symptom dropdown, Other selected"
"Specify Disease/Symptom text field appeared"
→ User types
"Malaria"
→ User submits
"Report submitted successfully"
```

### Keyboard Navigation
```
Tab → Disease dropdown
Enter → Open dropdown
↓ → Navigate to "Other"
Enter → Select "Other"
Tab → Focus custom field
Type → Enter disease name
Tab → Next field
Enter → Submit
```

## Summary

✅ Clean, intuitive interface
✅ Smooth transitions
✅ Clear validation messages
✅ Accessible design
✅ Mobile-friendly
✅ User-friendly workflow

The custom disease input feature seamlessly integrates with the existing form!
