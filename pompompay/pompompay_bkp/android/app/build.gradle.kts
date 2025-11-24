import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// --- Load local.properties ---
val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.reader(Charsets.UTF_8).use { reader ->
        localProperties.load(reader)
    }
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// --- Version Variables ---
val versionMajor = 1
val versionMinor = 0
val versionPatch = 3

android {
    namespace = "com.example.pompompay"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.pompaykerala.pompompay"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = 36
        versionCode = versionMajor * 10000 + versionMinor * 100 + versionPatch
        versionName = "${versionMajor}.${versionMinor}.${versionPatch}"
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
          //  signingConfig = signingConfigs.getByName("debug")
              signingConfig = signingConfigs.getByName("release")
        }
    }
}

afterEvaluate {
    val pubspecFile = rootProject.file("../pubspec.yaml")
    if (pubspecFile.exists()) {
        val lines = pubspecFile.readLines()
        val newVersion = "version: $versionMajor.$versionMinor.$versionPatch+${android.defaultConfig.versionCode}"

        val updatedLines = lines.map { line ->
            if (line.startsWith("version:")) newVersion else line
        }

        pubspecFile.writeText(updatedLines.joinToString("\n"))
    } else {
        throw GradleException("pubspec.yaml file not found!")
    }
}

tasks.register("updatePubspecVersion") {
    doLast {
        val flutterSdkPath = System.getenv("FLUTTER_HOME")
            ?: "${System.getProperty("user.home")}/flutter"

        exec {
            commandLine("$flutterSdkPath/bin/flutter", "pub", "get")
        }
    }
}

tasks.named("preBuild") {
    dependsOn("updatePubspecVersion")
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.material:material:1.12.0")
   // implementation ("androidx.core:core-ktx:1.12.0")
   // implementation ("androidx.core:core:1.12.0")

    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("androidx.multidex:multidex:2.0.1")
}

