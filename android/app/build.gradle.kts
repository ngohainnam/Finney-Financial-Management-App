plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // ✅ Firebase integration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // ✅ Flutter plugin (must be last)
}

android {
    namespace = "com.example.finney"

    // ✅ Updated to match latest plugin requirements
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.finney"
        minSdk = 23
        targetSdk = 35 // ✅ Required for POST_NOTIFICATIONS and newer plugins
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // ✅ If you're not signing manually, this is fine for testing
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true // ✅ Required for ZonedDateTime and notification libraries
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Required for flutter_local_notifications and modern APIs
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}
