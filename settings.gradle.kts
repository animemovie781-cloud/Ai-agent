pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://jitpack.io") }
    }
}

rootProject.name = "Jarvis AI Assistant"
include(":app")
include(":core:common")
include(":core:data")
include(":core:domain")
include(":core:ui")
include(":feature:ai")
include(":feature:voice")
include(":feature:accessibility")
include(":feature:overlay")
include(":feature:ocr")
include(":feature:screen")
include(":feature:automation")
include(":feature:notification")
include(":feature:gesture")
include(":feature:planner")
include(":feature:memory")
include(":feature:browser")
