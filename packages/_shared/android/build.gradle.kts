import org.yaml.snakeyaml.Yaml

group = "com.jarvan.fluwx"
version = "1.0-SNAPSHOT"

buildscript {
    val kotlinVersion = "2.3.20"
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:9.0.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
        classpath("org.yaml:snakeyaml:2.6")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    id("com.android.library")
}

val agpMajor = com.android.Version.ANDROID_GRADLE_PLUGIN_VERSION.substringBefore('.').toInt()

if (agpMajor < 9) {
    apply(plugin = "org.jetbrains.kotlin.android")
}

android {
    namespace = "com.jarvan.fluwx"
    compileSdk = 34

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin", "${layout.buildDirectory.get().asFile}/generated/src/kotlin")
        }
        getByName("test") {
            java.srcDirs("src/test/kotlin")
        }
    }

    defaultConfig {
        minSdk = 24
        consumerProguardFiles("consumer-proguard-rules.txt")
    }

    dependencies {
        api("com.tencent.mm.opensdk:wechat-sdk-android:6.8.34")
        implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.10.2")
        implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.10.2")
        implementation("id.zelory:compressor:3.0.1")
        implementation("com.squareup.okhttp3:okhttp:5.2.1")
        testImplementation("org.jetbrains.kotlin:kotlin-test")
        testImplementation("org.mockito:mockito-core:5.0.0")
    }

    testOptions {
        unitTests {
            isIncludeAndroidResources = true
            all {
                it.useJUnitPlatform()

                it.outputs.upToDateWhen { false }

                it.testLogging {
                    events("passed", "skipped", "failed", "standardOut", "standardError")
                    showStandardStreams = true
                }
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}


project.extensions.configure(org.jetbrains.kotlin.gradle.dsl.KotlinAndroidProjectExtension::class.java) {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

fun Project.loadPubspec(): Map<String, Any> {
    val yamlDir = if (rootProject.hasProperty("yamlDir")) rootProject.ext["yamlDir"] as String else ""
    val pubspecPath = "${rootProject.projectDir.parent}${File.separator}${yamlDir}pubspec.yaml"
    val pubspecFile = if (file(pubspecPath).exists()) {
        File(pubspecPath)
    } else {
        val parentDir = File(file(".").absolutePath).parentFile
        File(parentDir, "pubspec.yaml")
    }

    @Suppress("UNCHECKED_CAST")
    return Yaml().load<Map<String, Any>>(pubspecFile.inputStream())
}

fun Project.generateFluwxConfigurations(
    interruptWeChatRequestByFluwx: String,
    flutterActivity: String,
    enableLogging: String,
) {
    val generateFolder = File("${layout.buildDirectory.get().asFile}/generated/src/kotlin/com/jarvan/fluwx")
    val template = """
        package com.jarvan.fluwx

        // auto generated
        internal object FluwxConfigurations {
            val flutterActivity: String = "&&flutterActivity&&"
            val enableLogging: Boolean = &&enableLogging&&
            val interruptWeChatRequestByFluwx: Boolean = &&interruptWeChatRequestByFluwx&&
        }
    """.trimIndent()

    if (!generateFolder.exists()) {
        generateFolder.mkdirs()
    }

    val source = template
        .replace("&&interruptWeChatRequestByFluwx&&", interruptWeChatRequestByFluwx)
        .replace("&&flutterActivity&&", flutterActivity)
        .replace("&&enableLogging&&", enableLogging)
    File("${generateFolder.absolutePath}/FluwxConfigurations.kt").writeText(source)
}

tasks.register("generateFluwxHelperFile") {
    doFirst {
        val config = loadPubspec()
        @Suppress("UNCHECKED_CAST")
        val fluwx = config["fluwx"] as? Map<String, Any>
        var enableLogging = "false"
        var interruptWeChatRequestByFluwx = "true"
        var flutterActivity = ""

        if (fluwx != null) {
            @Suppress("UNCHECKED_CAST")
            val androidConfig = fluwx["android"] as? Map<String, Any>
            if (androidConfig != null) {
                val iwr = androidConfig["interrupt_wx_request"]
                if (iwr != null && (iwr == "true" || iwr == "false")) {
                    interruptWeChatRequestByFluwx = iwr as String
                }
                val activity = androidConfig["flutter_activity"]
                if (activity != null) {
                    flutterActivity = activity as String
                }
            }

            val logging = fluwx["debug_logging"]
            if ("$logging" == "true" || "$logging" == "false") {
                enableLogging = "$logging"
            }
        }

        generateFluwxConfigurations(interruptWeChatRequestByFluwx, flutterActivity, enableLogging)
    }
}

configure<com.android.build.gradle.LibraryExtension> {
    libraryVariants.configureEach {
        registerGeneratedResFolders(
            project.files(File("${layout.buildDirectory.get().asFile}/generated/src/kotlin/com/jarvan/fluwx"))
                .builtBy(tasks.named("generateFluwxHelperFile"))
        )
    }
}
