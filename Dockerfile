# build
FROM docker.io/library/maven:3.9.6-eclipse-temurin-11 AS build
WORKDIR /workspace
COPY pom.xml .
RUN mvn -q -e -B -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -q -e -B -DskipTests package

# run (JRE 11)
FROM docker.io/library/eclipse-temurin:11-jre
ENV JAVA_OPTS=""
WORKDIR /app
COPY --from=build /workspace/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar /app/app.jar"]
