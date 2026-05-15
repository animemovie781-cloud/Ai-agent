@echo off
setlocal enabledelayedexpansion

rem Setup GRADLE_HOME if not set
if "%GRADLE_HOME%"=="" (
  set GRADLE_HOME=%~dp0..
)

rem Find java.exe
set JAVA_EXE=java.exe
if not "%JAVA_HOME%"=="" (
  set JAVA_EXE="%JAVA_HOME%\bin\java.exe"
)

rem Check if we need to download the wrapper jar
set WRAPPER_JAR=%GRADLE_HOME%\gradle\wrapper\gradle-wrapper.jar
if not exist "%WRAPPER_JAR%" (
  echo Downloading Gradle wrapper...
  "%JAVA_EXE%" -classpath "%JAVA_EXE%" org.gradle.wrapper.GradleWrapperMain
)

rem Run Gradle
"%JAVA_EXE%" -classpath "%WRAPPER_JAR%" org.gradle.wrapper.GradleWrapperMain %*
