import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
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

val versionProps =  Properties()
file("$rootDir/../version.properties").inputStream().use {
    versionProps.load(it)
}


val versionMajor = versionProps.getProperty("versionMajor").toInt()
val versionMinor = versionProps.getProperty("versionMinor").toInt()
val versionPatch = versionProps.getProperty("versionPatch").toInt()

android {
    namespace = "com.pompaykerala.pompompay"
    compileSdk = 37
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    
    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.pompaykerala.pompompay"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = 37
        versionCode = versionMajor * 10000 + versionMinor * 100 + versionPatch
        versionName = "${versionMajor}.${versionMinor}.${versionPatch}"
        ndk {
            abiFilters.add("arm64-v8a")
        }

        vectorDrawables.useSupportLibrary = true
        
    }

    externalNativeBuild {
        cmake {
            path = file("src/main/cpp/CMakeLists.txt")
        }
    }
    
    packaging {
        jniLibs {
            // this lets the Gradle pipeline repackage native libs properly and avoids legacy caching
            useLegacyPackaging = false
        }
    }

   /* splits {
            abi {
                isEnable = true
                reset()
                include("arm64-v8a")
                isUniversalApk = false
            }
        } */

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

// Helpful task to force rebuild & set LDFLAGS for native linkers during Gradle tasks
tasks.register<Exec>("ensureLinkerPageSize") {
    // This is a no-op execution that only ensures environment variables are visible to subprocesses.
    // Gradle's Kotlin DSL doesn't let us directly inject linker flags into every plugin easily,
    // but this helps ensure Gradle runs with env we need if any native sub-build respects them.
    commandLine("bash", "-lc", "echo ensureLinkerPageSize")
    environment("LDFLAGS", "-Wl,--max-page-size=16384")
    environment("CPPFLAGS", "-Wl,--max-page-size=16384")
}

tasks.named("preBuild").configure {
    dependsOn("ensureLinkerPageSize")
}

dependencies {
    implementation("com.google.android.material:material:1.12.0")
   // implementation ("androidx.core:core-ktx:1.12.0")
   // implementation ("androidx.core:core:1.12.0")
    implementation("androidx.camera:camera-core:1.3.2")
    implementation("androidx.datastore:datastore-preferences:1.1.1")

    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("androidx.multidex:multidex:2.0.1")
}

