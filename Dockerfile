FROM gradle:8.7-jdk21 AS builder
WORKDIR /app
COPY build.gradle settings.gradle gradlew ./
COPY gradle gradle
RUN chmod +x gradlew
COPY src/main/resources/specs src/main/resources/specs
RUN --mount=type=cache,target=/home/gradle/.gradle ./gradlew clean compileJava --no-daemon
COPY . .
RUN --mount=type=cache,target=/home/gradle/.gradle ./gradlew clean bootWar --no-daemon

FROM eclipse-temurin:21-jre-alpine
RUN addgroup -S spring && adduser -S spring -G spring
WORKDIR /app
COPY --from=builder /app/build/libs/*war app.war
RUN chown -R spring:spring /app
USER spring

ENV JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.war"]