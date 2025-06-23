// android/app/build.gradle.kts

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // Standard way to apply Kotlin Android plugin
    id("com.google.gms.google-services") // Apply the plugin here
    // The Flutter Gradle Plugin must be applied last
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.lib1"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8 // Or JavaVersion.VERSION_11 if needed
        targetCompatibility = JavaVersion.VERSION_1_8 // Or JavaVersion.VERSION_11 if needed
    }

    kotlinOptions {
        jvmTarget = "1.8" // Or "11" if using JavaVersion.VERSION_11
    }

    defaultConfig {
        applicationId = "com.example.lib1"
        minSdk = 23 // You correctly set this
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            // TODO: Configure your release signing properly
            //  isMinifyEnabled = true
            //  isShrinkResources = true
            //  proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
     // If you have signingConfigs for release, they would be defined here
    // signingConfigs {
    //     create("release") {
    //         storeFile = file("your_release_keystore.jks")
    //         storePassword = "your_store_password"
    //         keyAlias = "your_key_alias"
    //         keyPassword = "your_key_password"
    //     }
    // }
}

dependencies {
    implementation(kotlin("stdlib-jdk8")) // Or specific version
    implementation(platform("com.google.firebase:firebase-bom:33.0.0")) // Use latest Firebase BoM
    implementation("com.google.firebase:firebase-analytics-ktx")
    implementation("com.google.firebase:firebase-auth-ktx")
    implementation("com.google.firebase:firebase-firestore-ktx")

    implementation("androidx.multidex:multidex:2.0.1")
}