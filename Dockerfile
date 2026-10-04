# ---- Build stage ----
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

COPY gradlew settings.gradle build.gradle ./
COPY gradle ./gradle
RUN chmod +x gradlew && ./gradlew --no-daemon dependencies > /dev/null 2>&1 || true

COPY src ./src
RUN ./gradlew --no-daemon bootJar -x test

# ---- Run stage ----
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar

# Render/Railway truyen cong qua bien PORT (application.properties doc ${PORT:8080})
EXPOSE 8080
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75", "-jar", "app.jar"]