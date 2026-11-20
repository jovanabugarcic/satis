allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Keep Gradle outputs outside OneDrive to prevent sync/file-lock conflicts.
val localBuildRoot = System.getenv("LOCALAPPDATA")
    ?: (System.getProperty("user.home") + "/AppData/Local")
rootProject.layout.buildDirectory.set(file(localBuildRoot + "/SatisBuild"))
val newBuildDir: Directory = rootProject.layout.buildDirectory.get()

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
