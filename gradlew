#!/bin/sh
set -e

# Determine GRADLE_HOME
if [ -z "$GRADLE_HOME" ]; then
  GRADLE_HOME="$(cd "$(dirname "$0")/.." && pwd)"
fi

# Find java
if [ -n "$JAVA_HOME" ]; then
  JAVA_EXE="$JAVA_HOME/bin/java"
else
  JAVA_EXE=java
fi

# Check for wrapper jar
WRAPPER_JAR="$GRADLE_HOME/gradle/wrapper/gradle-wrapper.jar"
if [ ! -f "$WRAPPER_JAR" ]; then
  echo "Downloading Gradle wrapper..."
  "$JAVA_EXE" -classpath "$JAVA_EXE" org.gradle.wrapper.GradleWrapperMain
fi

exec "$JAVA_EXE" -classpath "$WRAPPER_JAR" org.gradle.wrapper.GradleWrapperMain "$@"
