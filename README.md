# EduSphere Flutter Mobile App 📱

## نظرة عامة
تطبيق موبايل مبني بـ Flutter يحاكي بيل الـ Figma الخاص بـ EduSphere Student Portal.

## الشاشات المُنفَّذة
1. **Dashboard** - الشاشة الرئيسية مع الإحصائيات والمواد والمهام
2. **Attendance QR** - مسح الـ QR code لتسجيل الحضور
3. **Student Services** - خدمات الطلاب (grid menu)
4. **Medical Excuses** - رفع وتتبع الأعذار الطبية
5. **Complaints** - تقديم وعرض الشكاوى
6. **Academic Warnings** - التحذيرات الأكاديمية
7. **Official Requests** - طلب الوثائق الرسمية
8. **Curriculum Management** - خريطة المواد الدراسية
9. **Records & Enrollment** - السجل الأكاديمي والتسجيل
10. **Admin Panel** - لوحة تحكم الإدارة

## الألوان
- **Primary**: #E53935 (أحمر)
- **Background**: #F4F6F9 (رمادي فاتح)
- **Success**: #10B981 (أخضر)
- **Warning**: #F59E0B (برتقالي)

## كيفية التشغيل

### المتطلبات
- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio أو VS Code

### خطوات التشغيل
```bash
# استنساخ أو فتح المشروع
cd edusphere

# تحميل الـ packages
flutter pub get

# تشغيل على محاكي
flutter run

# بناء APK
flutter build apk --release
```

## هيكل المشروع
```
lib/
  main.dart                    # نقطة البداية
  app_theme.dart               # الألوان والـ theme
  screens/
    home_screen.dart           # Bottom Navigation scaffold
    dashboard_screen.dart      # الرئيسية
    attendance_qr_screen.dart  # QR Attendance
    student_services_screen.dart
    medical_excuses_screen.dart
    complaints_screen.dart
    academic_warnings_screen.dart
    official_requests_screen.dart
    curriculum_screen.dart
    records_screen.dart
    admin_panel_screen.dart
  widgets/
    stat_card.dart             # كارت الإحصائيات
    section_header.dart        # عنوان القسم
```

## الـ Dependencies
- `google_fonts` - Inter font
- `percent_indicator` - Progress bars
- `fl_chart` - Charts (جاهزة للإضافة)
