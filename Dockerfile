
FROM openjdk:17-jdk-slim

WORKDIR .

COPY build/libs/dalle-0.0.1-SNAPSHOT.jar /dalle.jar

EXPOSE 8080

CMD ["java", "-jar", "dalle.jar"]