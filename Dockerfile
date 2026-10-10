FROM eclipse-temurin:25-jdk AS build
WORKDIR /app
COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN chmod +x mvnw
COPY src src
RUN ./mvnw -B -DskipTests package
FROM eclipse-temurin:25-jre
WORKDIR /app
ENV TZ=Asia/Ho_Chi_Minh \
    SPRING_PROFILES_ACTIVE=render \
    JAVA_TOOL_OPTIONS="-Duser.timezone=Asia/Ho_Chi_Minh -XX:MaxRAMPercentage=60.0"
COPY --from=build /app/target/*.war /app/qaute.war
USER 10001:10001
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/qaute.war"]
