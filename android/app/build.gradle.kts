plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // ✅ utiliser l’id officiel
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ✅ requis pour Firebase
}

android {
    namespace = "com.example.projet_ia"
    compileSdk = flutter.compileSdkVersion

    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.projet_ia"
        minSdk = 23 // ✅ Firebase nécessite minSdk ≥ 23
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            // tu pourras plus tard définir ta propre clé ici
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 🔹 Import du BOM Firebase pour gérer les versions automatiquement
    implementation(platform("com.google.firebase:firebase-bom:34.4.0"))

    // 🔹 Firebase Core (obligatoire pour initialiser Firebase)
    implementation("com.google.firebase:firebase-analytics")

    // 🔹 Firebase Cloud Messaging (FCM) pour les notifications
    implementation("com.google.firebase:firebase-messaging")

    // 🔹 Kotlin Standard Library
    implementation("org.jetbrains.kotlin:kotlin-stdlib:2.0.21")
}
