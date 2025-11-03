// Top-level build file for your Flutter Android project

// 🔹 Ajout du plugin Google Services (requis par Firebase)
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Plugin Google Services
        classpath("com.google.gms:google-services:4.4.2")

        // Kotlin Gradle plugin (doit correspondre à ta version)
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.0.21")

        // Plugin Android Gradle (même version que dans settings.gradle.kts)
        classpath("com.android.tools.build:gradle:8.5.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// 🔹 Tâche clean Flutter
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
// rootProject.layout.buildDirectory.value(newBuildDir)

// subprojects {
//     val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
//     project.layout.buildDirectory.value(newSubprojectBuildDir)
// }
// subprojects {
//     project.evaluationDependsOn(":app")
// }

// tasks.register<Delete>("clean") {
//     delete(rootProject.layout.buildDirectory)
// }
 