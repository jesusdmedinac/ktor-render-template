FROM gradle:8.5-jdk21 AS build
WORKDIR /home/gradle/src
COPY --chown=gradle:gradle build.gradle.kts settings.gradle.kts gradlew gradlew.bat gradle.properties ./
COPY --chown=gradle:gradle gradle ./gradle
RUN ./gradlew dependencies --no-daemon
COPY --chown=gradle:gradle src ./src
RUN ./gradlew buildFatJar --no-daemon


FROM openjdk:21-slim
EXPOSE 8080
COPY --from=build /home/gradle/src/build/libs/*-all.jar /app/ktor-render-template.jar
ENTRYPOINT ["java","-jar","/app/ktor-render-template.jar"]
