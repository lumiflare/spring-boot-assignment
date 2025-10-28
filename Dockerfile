FROM gradle:8.7-jdk17 AS builder
WORKDIR /workspace

COPY gradlew gradlew.bat settings.gradle build.gradle ./
COPY gradle gradle

# ラッパーJARが無ければ生成（gradleコマンドはベースイメージに入ってます）
RUN test -f gradle/wrapper/gradle-wrapper.jar || gradle wrapper
RUN chmod +x gradlew

COPY src src

# BuildKitのキャッシュで高速化
RUN --mount=type=cache,target=/home/gradle/.gradle \
    ./gradlew bootJar --no-daemon -x test

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=builder /workspace/build/libs/*.jar /app/app.jar
ENV SPRING_PROFILES_ACTIVE=docker
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]