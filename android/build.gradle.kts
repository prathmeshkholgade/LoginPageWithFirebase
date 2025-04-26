plugins {
    id("com.android.application")
    kotlin("android")
}

android {
    namespace = "com.example.loginpage"
    compileSdk = 33
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.loginpage"
        minSdk = 19
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.8.10")
}
