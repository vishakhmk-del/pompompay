import 'package:pompompay/core/hook/hooks.dart';
import 'package:sizer/sizer.dart';

const primaryColor = Color(0xff0077C8);
// #00c7c8
// const secondaryColor = Color(0xff00c7c8);
const secondaryColor = Color.fromARGB(255, 11, 167, 219);

class MyTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    // colorScheme: const ColorScheme.light(),
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      primaryContainer: Color(0xffe4e2d4),
      /***graph theme***/
      primaryFixed: Color(0xff98c1d9),

      /*****************/
      onPrimaryFixed: Color(0xffffa600),
      secondaryFixed: Color(0xFFE1E1E1),

      //onSecondaryFixed: Color(0xFF7B1FA2),
      tertiary: Colors.white,
    ),
    textTheme: TextTheme(
      labelLarge: TextStyle(
        color: Colors.black,
        fontSize: 12.sp,
        fontFamily: 'Poppins-Medium',
        fontWeight: FontWeight.w800,
      ),
      labelMedium: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontFamily: 'Poppins-Medium',
      ),
      labelSmall: TextStyle(
        color: Colors.white,
        fontSize: 12.sp,
        fontFamily: 'Poppins-Medium',
      ),
      bodySmall: TextStyle(
        color: Colors.black,
        fontSize: 12.sp,
        fontFamily: 'Poppins-Medium',
      ),
      bodyMedium: TextStyle(
        color: Colors.black,
        fontSize: 16.sp,
        fontFamily: 'Poppins-Medium',
        fontWeight: FontWeight.w900,
      ),
      bodyLarge: TextStyle(
        color: Color(0xff293241),
        fontSize: 16.sp,
        fontFamily: 'Poppins-Medium',
        fontWeight: FontWeight.w900,
      ),
      headlineSmall: TextStyle(
        color: Colors.black,
        fontSize: 12.sp,
        fontFamily: 'Poppins-Medium',
        fontWeight: FontWeight.w800,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 12.sp,
        fontFamily: 'Poppins-Medium',
        fontWeight: FontWeight.w800,
      ),
      headlineLarge: TextStyle(
        color: Colors.black,
        fontSize: 14.sp,
        fontFamily: 'Poppins-Medium',
        fontWeight: FontWeight.w800,
      ),
      displaySmall: TextStyle(
        color: Colors.black,
        fontSize: 16.sp,
        fontFamily: 'Poppins-Medium',
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontFamily: 'Poppins-Medium',
      ),
      displayLarge: TextStyle(
        color: Colors.black,
        fontSize: 20.sp,
        fontFamily: 'Poppins-Medium',
      ),
      titleSmall: TextStyle(
        color: Colors.black,
        fontSize: 16.sp,
        fontFamily: 'Poppins-Medium',
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 18.sp,
        fontFamily: 'Poppins-Medium',
      ),
      titleLarge: TextStyle(
        color: Colors.black,
        fontSize: 20.sp,
        fontFamily: 'Poppins-Medium',
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(
            0xff12b2ba,
          ); // Inside color when checked in light mode
        }
        return Colors.white; // Inside color when unchecked in light mode
      }),
      checkColor: WidgetStateProperty.all<Color>(
        Colors.white,
      ), // Checkmark color in light mode
      side: const BorderSide(
        color: Colors.black, // Border color when unchecked in light mode
        width: 2, // Border width
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black, size: 20),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey.shade900,
    // colorScheme: const ColorScheme.light(),
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      primaryContainer: Color(0xffe4e2d4),
      /***graph theme***/
      primaryFixed: Color(0xff98c1d9),

      /*****************/
      onPrimaryFixed: Color(0xffffa600),
      secondaryFixed: Color(0xFFE1E1E1),

      // onSecondaryFixed: Color(0xFF7B1FA2),
      tertiary: Colors.black,
    ),
    textTheme: TextTheme(
      labelLarge: TextStyle(
        color: Colors.white,
        fontSize: 12.sp,
        fontFamily: 'Poppins-Medium',
        fontWeight: FontWeight.w800,
      ),
      labelMedium: TextStyle(
        color: const Color.fromRGBO(255, 255, 255, 1),
        fontSize: 14.sp,
        fontFamily: 'Poppins-Medium',
      ),
      labelSmall: TextStyle(
        color: Colors.white,
        fontSize: 12.sp,
        fontFamily: 'Poppins-Medium',
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 12.sp,
        fontFamily: 'Poppins-Medium',
        fontWeight: FontWeight.w800,
      ),
      headlineSmall: TextStyle(
        color: Colors.black,
        fontSize: 12.sp,
        fontFamily: 'Poppins-Medium',
        fontWeight: FontWeight.w800,
      ),
      headlineLarge: TextStyle(
        color: Colors.black,
        fontSize: 14.sp,
        fontFamily: 'Poppins-Medium',
        fontWeight: FontWeight.w800,
      ),
      displaySmall: TextStyle(
        color: Colors.black,
        fontSize: 16.sp,
        fontFamily: 'Poppins-Medium',
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontFamily: 'Poppins-Medium',
      ),
      displayLarge: TextStyle(
        color: Colors.black,
        fontSize: 20.sp,
        fontFamily: 'Poppins-Medium',
      ),
      bodySmall: TextStyle(
        color: Colors.black,
        fontSize: 14.sp,
        fontFamily: 'Poppins-Medium',
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontFamily: 'Poppins-Medium',
        fontWeight: FontWeight.w900,
      ),
      bodyLarge: TextStyle(
        color: Color(0xff293241),
        fontSize: 16.sp,
        fontFamily: 'Poppins-Medium',
        fontWeight: FontWeight.w900,
      ),
      titleSmall: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontFamily: 'Poppins-Medium',
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 18.sp,
        fontFamily: 'Poppins-Medium',
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 20.sp,
        fontFamily: 'Poppins-Medium',
        // letterSpacing: 1,
        // wordSpacing: 2,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(
            0xff12b2ba,
          ); // Inside color when checked in dark mode
        }
        return Colors.white; // Inside color when unchecked in dark mode
      }),
      checkColor: WidgetStateProperty.all<Color>(
        Colors.white,
      ), // Checkmark color in dark mode
      side: const BorderSide(
        color: Colors.black, // Border color when unchecked in dark mode
        width: 2, // Border width
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black, size: 20),
  );

  //common theme
  static ThemeData get googleFormTheme => ThemeData(
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE1E1E1), width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE1E1E1), width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE1E1E1), width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE1E1E1), width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    ),
  );

  static ThemeData get buttonStyleTheme => ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
    ),
  );

  static ThemeData get appIconTheme => ThemeData(
    iconTheme: const IconThemeData(color: Color(0xffe4e2d4), size: 20),
  );
}
