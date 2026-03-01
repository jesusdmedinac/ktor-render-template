FROM gradle:8.5-jdk21 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN ./gradlew buildFatJar --no-daemon

FROM openjdk:21-slim
EXPOSE 8080
COPY --from=build /home/gradle/src/build/libs/*-all.jar /app/ktor-render-template.jar
ENTRYPOINT ["java","-jar","/app/ktor-render-template.jar"]
